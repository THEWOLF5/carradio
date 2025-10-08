document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('.radio-container');
    const stationList = document.querySelector('.station-list');
    const volumeSlider = document.querySelector('.volume-slider');
    const closeBtn = document.querySelector('.close-btn');
    const logo = document.getElementById('logo');

    let currentStation = null;

    // Close UI and send data back to Lua
    const closeUI = () => {
        container.style.display = 'none';
        fetch(`https://carradio/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({})
        }).catch(err => console.error('Error closing UI:', err));
    };

    // Handle station click
    const selectStation = (stationElement, station) => {
        if (currentStation) {
            currentStation.classList.remove('active');
        }
        stationElement.classList.add('active');
        currentStation = stationElement;

        fetch(`https://carradio/play`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ station: station.url })
        }).catch(err => console.error('Error playing station:', err));
    };

    // NUI Message Listener
    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.type === 'ui') {
            container.style.display = data.status ? 'block' : 'none';
        } else if (data.type === 'setup') {
            logo.src = data.logo;
            stationList.innerHTML = '';
            data.stations.forEach(station => {
                const li = document.createElement('li');
                li.textContent = station.name;
                li.addEventListener('click', () => selectStation(li, station));
                stationList.appendChild(li);
            });
        }
    });

    // Volume control
    volumeSlider.addEventListener('input', (e) => {
        fetch(`https://carradio/volume`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ volume: e.target.value / 100 })
        }).catch(err => console.error('Error setting volume:', err));
    });

    // Close button
    closeBtn.addEventListener('click', closeUI);

    // Close with Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeUI();
        }
    });
});