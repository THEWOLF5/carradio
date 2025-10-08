Config = {}

-- General Settings
Config.Debug = false -- Set to true for debug messages

-- Music Settings
Config.MaxVolume = 100 -- Maximum volume level (0-100)
Config.DefaultVolume = 30 -- Default volume when music starts
Config.SharedVolumeThreshold = 40 -- Volume % above which nearby players can hear
Config.MaxDistance = 15.0 -- Maximum distance for nearby players to hear music (meters)
Config.FadeDistance = 10.0 -- Distance where music starts to fade for nearby players

-- Vehicle Settings
Config.AllowedVehicleClasses = {
    [0] = true,  -- Compacts
    [1] = true,  -- Sedans
    [2] = true,  -- SUVs
    [3] = true,  -- Coupes
    [4] = true,  -- Muscle
    [5] = true,  -- Sports Classics
    [6] = true,  -- Sports
    [7] = true,  -- Super
    [8] = false, -- Motorcycles
    [9] = true,  -- Off-road
    [10] = true, -- Industrial
    [11] = true, -- Utility
    [12] = true, -- Vans
    [13] = false, -- Cycles
    [14] = false, -- Boats
    [15] = false, -- Helicopters
    [16] = false, -- Planes
    [17] = true,  -- Service
    [18] = true,  -- Emergency
    [19] = true,  -- Military
    [20] = true,  -- Commercial
    [21] = false  -- Trains
}

-- Restricted Vehicles (specific vehicle hashes that don't allow music)
Config.RestrictedVehicles = {
    -- Add vehicle hashes here if needed
    -- GetHashKey('police'),
    -- GetHashKey('ambulance'),
}

-- YouTube Settings
Config.YouTubeAPI = {
    enabled = true,
    -- You can add YouTube API key here for enhanced features (optional)
    apiKey = "", -- Leave empty if not using YouTube API
    maxDuration = 600, -- Maximum song duration in seconds (10 minutes)
    allowLiveStreams = false, -- Allow live YouTube streams
    allowPlaylists = true -- Allow YouTube playlists
}

-- UI Settings
Config.UISettings = {
    openKey = 'F7', -- Key to open music player UI
    toggleKey = 'F8', -- Key to quickly toggle music on/off
    animationDuration = 300, -- UI animation duration in ms
    showNotifications = true, -- Show notifications for music events
    rememberVolume = true, -- Remember last volume setting
    rememberLastSong = true -- Remember last played song
}

-- Audio Settings
Config.AudioSettings = {
    engine3D = true, -- Use 3D audio for nearby players
    reverb = false, -- Apply reverb effect inside vehicles
    lowPassFilter = true, -- Apply low-pass filter for muffled effect from outside
    bassBoost = false, -- Apply bass boost inside vehicles
    fadeInDuration = 2.0, -- Fade in duration when music starts (seconds)
    fadeOutDuration = 1.5, -- Fade out duration when music stops (seconds)
    crossfade = true -- Crossfade between songs
}

-- Permissions
Config.Permissions = {
    requireItem = false, -- Require specific item to use music player
    itemName = 'music_player', -- Item name if required
    blacklistedJobs = {
        -- 'police',
        -- 'ambulance'
    },
    adminBypass = true -- Allow admins to bypass restrictions
}

-- Performance Settings
Config.Performance = {
    updateInterval = 100, -- Update interval for music sync (ms)
    maxConcurrentPlayers = 50, -- Maximum concurrent music players
    cleanupInterval = 300000, -- Cleanup interval for stopped music (5 minutes)
    enableCaching = true, -- Enable URL caching for performance
    cacheExpireTime = 3600 -- Cache expire time in seconds (1 hour)
}

-- Supported Platforms
Config.SupportedPlatforms = {
    youtube = true,
    soundcloud = false, -- Not implemented yet
    spotify = false, -- Not implemented yet
    twitch = false, -- Not implemented yet
    direct = true -- Direct MP3/OGG URLs
}

-- Blacklisted URLs/Domains
Config.BlacklistedDomains = {
    -- Add domains you want to block
    -- 'example-bad-site.com',
}

-- Sound Effects
Config.SoundEffects = {
    enabled = true,
    startSound = 'car_music_start',
    stopSound = 'car_music_stop',
    volumeChangeSound = 'car_music_volume',
    errorSound = 'car_music_error'
}

-- Logging
Config.Logging = {
    enabled = true,
    logMusicEvents = true,
    logVolumeChanges = false,
    logPlayerActions = true
}