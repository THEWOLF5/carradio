document.addEventListener('DOMContentLoaded', function () {
    const radioContainer = document.querySelector('.radio-container');
    const metroFMAudio = new Audio('https://radio.metrogaming.co.il/listen/metrocity_radio/radio.mp3');
    let ytPlayer;
    let playlist = JSON.parse(localStorage.getItem('carradio_playlist')) || [];
    let currentTrackIndex = -1;
    let isShuffle = false;
    let isRepeat = false;

    // UI Elements
    const tabs = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');
    const volumeSlider = document.getElementById('volume-slider');
    const metroPlayPauseBtn = document.getElementById('metro-play-pause');
    const personalPlayPauseBtn = document.getElementById('personal-play-pause');
    const personalPrevBtn = document.getElementById('personal-prev');
    const personalNextBtn = document.getElementById('personal-next');
    const personalShuffleBtn = document.getElementById('personal-shuffle');
    const personalRepeatBtn = document.getElementById('personal-repeat');
    const addToPlaylistBtn = document.getElementById('add-to-playlist');
    const clearPlaylistBtn = document.getElementById('clear-playlist');
    const youtubeLinkInput = document.getElementById('youtube-link');
    const playlistElement = document.getElementById('playlist');

    // NUI Listener
    window.addEventListener('message', function (event) {
        const item = event.data;
        if (item.type === 'ui') {
            radioContainer.style.display = item.status ? 'flex' : 'none';
        }
    });

    // Tab Switching
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            tabContents.forEach(c => c.classList.remove('active'));
            document.getElementById(tab.dataset.tab).classList.add('active');

            if (tab.dataset.tab === 'metrofm') {
                if (ytPlayer && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
                fetch(`https://${GetParentResourceName()}/setRadioChannel`, {
                    method: 'POST',
                    body: JSON.stringify({ channel: 100.0 })
                });
            } else {
                metroFMAudio.pause();
                fetch(`https://${GetParentResourceName()}/setRadioChannel`, {
                    method: 'POST',
                    body: JSON.stringify({ channel: 0 })
                });
            }
        });
    });

    // MetroFM Controls
    metroPlayPauseBtn.addEventListener('click', () => {
        if (metroFMAudio.paused) {
            metroFMAudio.play();
            metroPlayPauseBtn.innerHTML = '<i class="fas fa-pause"></i>';
        } else {
            metroFMAudio.pause();
            metroPlayPauseBtn.innerHTML = '<i class="fas fa-play"></i>';
        }
    });

    // YouTube Player Setup
    const tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    const firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    window.onYouTubeIframeAPIReady = function () {
        ytPlayer = new YT.Player('youtube-player', {
            height: '0',
            width: '0',
            events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange
            }
        });
    };

    function onPlayerReady(event) {
        // Player is ready
    }

    function onPlayerStateChange(event) {
        if (event.data === YT.PlayerState.ENDED) {
            playNext();
        }
    }

    // Personal Music Controls
    personalPlayPauseBtn.addEventListener('click', () => {
        if (!ytPlayer || currentTrackIndex === -1) return;
        const state = ytPlayer.getPlayerState();
        if (state === YT.PlayerState.PLAYING) {
            ytPlayer.pauseVideo();
        } else {
            ytPlayer.playVideo();
        }
        updatePlayPauseIcon();
    });

    personalNextBtn.addEventListener('click', playNext);
    personalPrevBtn.addEventListener('click', playPrev);

    personalShuffleBtn.addEventListener('click', () => {
        isShuffle = !isShuffle;
        personalShuffleBtn.classList.toggle('active', isShuffle);
    });

    personalRepeatBtn.addEventListener('click', () => {
        isRepeat = !isRepeat;
        personalRepeatBtn.classList.toggle('active', isRepeat);
    });

    // Playlist Management
    addToPlaylistBtn.addEventListener('click', async () => {
        const link = youtubeLinkInput.value;
        if (!link) return;
        const videoId = parseYoutubeLink(link);
        if (!videoId) {
            // Consider sending a notification back to client.lua
            return;
        }

        const metadata = await fetch(`https://noembed.com/embed?url=https://www.youtube.com/watch?v=${videoId}`).then(res => res.json());
        if (metadata.error) {
            // Handle error
            return;
        }

        playlist.push({
            id: videoId,
            title: metadata.title,
            artist: metadata.author_name,
            thumbnail: metadata.thumbnail_url,
            duration: metadata.duration || 0 // No duration from noembed, need another way
        });
        savePlaylist();
        renderPlaylist();
        youtubeLinkInput.value = '';
    });

    clearPlaylistBtn.addEventListener('click', () => {
        playlist = [];
        currentTrackIndex = -1;
        if (ytPlayer) ytPlayer.stopVideo();
        savePlaylist();
        renderPlaylist();
        updatePlayerUI();
    });

    function playNext() {
        if (isRepeat) {
            ytPlayer.seekTo(0);
            ytPlayer.playVideo();
            return;
        }
        if (isShuffle) {
            currentTrackIndex = Math.floor(Math.random() * playlist.length);
        } else {
            currentTrackIndex++;
            if (currentTrackIndex >= playlist.length) {
                currentTrackIndex = 0;
            }
        }
        playTrack(currentTrackIndex);
    }

    function playPrev() {
        currentTrackIndex--;
        if (currentTrackIndex < 0) {
            currentTrackIndex = playlist.length - 1;
        }
        playTrack(currentTrackIndex);
    }

    function playTrack(index) {
        if (index < 0 || index >= playlist.length) return;
        currentTrackIndex = index;
        const track = playlist[index];
        ytPlayer.loadVideoById(track.id);
        updatePlayerUI(track);
        renderPlaylist(); // To highlight active track
    }

    function renderPlaylist() {
        playlistElement.innerHTML = '';
        playlist.forEach((track, index) => {
            const li = document.createElement('li');
            li.textContent = track.title;
            li.dataset.index = index;
            if (index === currentTrackIndex) {
                li.classList.add('active');
            }
            li.addEventListener('click', () => playTrack(index));
            playlistElement.appendChild(li);
        });
    }

    function savePlaylist() {
        localStorage.setItem('carradio_playlist', JSON.stringify(playlist));
    }

    function updatePlayerUI(track = null) {
        if (track) {
            document.getElementById('personal-album-art').src = track.thumbnail;
            document.getElementById('personal-title').textContent = track.title;
            document.getElementById('personal-artist').textContent = track.artist;
        } else {
            document.getElementById('personal-album-art').src = 'https://placehold.co/200x300?text=Your+Music';
            document.getElementById('personal-title').textContent = 'No song selected';
            document.getElementById('personal-artist').textContent = '';
        }
    }

    function updatePlayPauseIcon() {
        const state = ytPlayer.getPlayerState();
        if (state === YT.PlayerState.PLAYING) {
            personalPlayPauseBtn.innerHTML = '<i class="fas fa-pause"></i>';
        } else {
            personalPlayPauseBtn.innerHTML = '<i class="fas fa-play"></i>';
        }
    }

    // Progress Bar
    setInterval(() => {
        if (ytPlayer && ytPlayer.getPlayerState && ytPlayer.getPlayerState() === YT.PlayerState.PLAYING) {
            const currentTime = ytPlayer.getCurrentTime();
            const duration = ytPlayer.getDuration();
            const progress = (currentTime / duration) * 100;
            document.getElementById('personal-progress').style.width = `${progress}%`;
            document.getElementById('current-time').textContent = formatTime(currentTime);
            document.getElementById('total-time').textContent = formatTime(duration);
        }
        updatePlayPauseIcon(); // Also keep icon in sync
    }, 1000);

    // Volume Control
    volumeSlider.addEventListener('input', (e) => {
        const volume = e.target.value;
        metroFMAudio.volume = volume;
        if (ytPlayer && ytPlayer.setVolume) {
            ytPlayer.setVolume(volume * 100);
        }
    });

    // Utility
    function parseYoutubeLink(link) {
        const regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(?:embed\/)?(?:v\/)?(?:shorts\/)?([\w-]{11})/;
        const match = link.match(regex);
        return match ? match[1] : null;
    }

    function formatTime(seconds) {
        const min = Math.floor(seconds / 60);
        const sec = Math.floor(seconds % 60).toString().padStart(2, '0');
        return `${min}:${sec}`;
    }

    // Initial Load
    renderPlaylist();
    if (playlist.length > 0) {
        playTrack(0);
        ytPlayer.pauseVideo();
    }
});
