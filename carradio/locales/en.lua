local Locale = {}

Locale['en'] = {
    -- General Messages
    ['music_player_opened'] = 'Music player opened',
    ['music_player_closed'] = 'Music player closed',
    ['music_started'] = 'Music started playing',
    ['music_stopped'] = 'Music stopped',
    ['music_paused'] = 'Music paused',
    ['music_resumed'] = 'Music resumed',
    
    -- Error Messages
    ['not_in_vehicle'] = 'You must be in a vehicle to use the music player',
    ['vehicle_not_supported'] = 'This vehicle does not support music playback',
    ['cannot_control_music'] = 'You cannot control music in this vehicle',
    ['invalid_youtube_url'] = 'Invalid YouTube URL',
    ['no_song_playing'] = 'No song currently playing',
    ['player_not_ready'] = 'Music player is not ready',
    ['failed_to_play'] = 'Failed to play the video',
    ['video_not_found'] = 'Video not found or is private',
    ['video_restricted'] = 'Video owner has restricted playback',
    ['invalid_video_id'] = 'Invalid video ID',
    ['playlist_empty'] = 'Playlist is empty',
    ['playlist_full'] = 'Playlist is full (maximum %s songs)',
    
    -- Success Messages
    ['added_to_playlist'] = 'Added to playlist',
    ['removed_from_playlist'] = 'Removed from playlist',
    ['playlist_cleared'] = 'Playlist cleared',
    ['playlist_saved'] = 'Playlist "%s" saved successfully',
    ['volume_changed'] = 'Volume set to %s%%',
    ['shuffle_enabled'] = 'Shuffle enabled',
    ['shuffle_disabled'] = 'Shuffle disabled',
    ['repeat_off'] = 'Repeat disabled',
    ['repeat_single'] = 'Repeat single song',
    ['repeat_playlist'] = 'Repeat playlist',
    
    -- Warning Messages
    ['proximity_audio_warning'] = 'Music is now audible to nearby players',
    ['high_volume_warning'] = 'High volume may disturb other players',
    ['engine_off_warning'] = 'Music will stop when engine turns off',
    ['low_battery_warning'] = 'Vehicle battery is low, music may stop',
    
    -- Info Messages
    ['song_added_history'] = 'Song added to history',
    ['settings_saved'] = 'Settings saved',
    ['quality_changed'] = 'Audio quality changed to %s',
    ['autoplay_enabled'] = 'Autoplay enabled',
    ['autoplay_disabled'] = 'Autoplay disabled',
    ['notifications_enabled'] = 'Notifications enabled',
    ['notifications_disabled'] = 'Notifications disabled',
    
    -- UI Labels
    ['current_song'] = 'Current Song',
    ['no_song_selected'] = 'No song playing',
    ['volume'] = 'Volume',
    ['playlist'] = 'Playlist',
    ['search'] = 'Search',
    ['settings'] = 'Settings',
    ['audio_quality'] = 'Audio Quality',
    ['autoplay_next'] = 'Autoplay next song',
    ['show_notifications'] = 'Show notifications',
    ['pause_on_exit'] = 'Pause when exiting vehicle',
    ['stop_on_engine_off'] = 'Stop when engine turns off',
    ['recent_urls'] = 'Recent URLs',
    ['enter_youtube_url'] = 'Enter YouTube URL',
    ['play'] = 'Play',
    ['pause'] = 'Pause',
    ['stop'] = 'Stop',
    ['next'] = 'Next',
    ['previous'] = 'Previous',
    ['shuffle'] = 'Shuffle',
    ['repeat'] = 'Repeat',
    ['add_to_playlist'] = 'Add to Playlist',
    ['clear_playlist'] = 'Clear Playlist',
    ['save_playlist'] = 'Save Playlist',
    ['remove'] = 'Remove',
    ['close'] = 'Close',
    
    -- Time Formats
    ['duration_format'] = '%d:%02d',
    ['time_remaining'] = '%s remaining',
    ['time_elapsed'] = '%s elapsed',
    
    -- Admin Commands
    ['admin_music_stopped'] = 'Admin stopped music in vehicle %s',
    ['admin_stats_title'] = 'Car Music System Statistics',
    ['admin_active_vehicles'] = 'Active Vehicles: %d',
    ['admin_playing_music'] = 'Playing Music: %d',
    ['admin_proximity_zones'] = 'Proximity Zones: %d',
    ['admin_rate_limited'] = 'Rate Limited Players: %d',
    ['admin_system_reloaded'] = 'Car music system reloaded',
    ['admin_no_permission'] = 'You do not have permission to use this command',
    ['admin_invalid_vehicle'] = 'Invalid vehicle ID',
    ['admin_vehicle_not_found'] = 'Vehicle not found',
    
    -- Vehicle Restrictions
    ['restricted_emergency'] = 'Emergency vehicles cannot play music',
    ['restricted_military'] = 'Military vehicles cannot play music',
    ['restricted_aircraft'] = 'Aircraft cannot play music',
    ['restricted_boats'] = 'Boats cannot play music',
    ['restricted_motorcycles'] = 'Motorcycles cannot play music',
    ['restricted_bicycles'] = 'Bicycles cannot play music',
    
    -- Permission Messages
    ['no_permission'] = 'You do not have permission to use the car music system',
    ['owner_only'] = 'Only the vehicle owner can control the music',
    ['passenger_only'] = 'You must be a passenger to control music',
    ['driver_only'] = 'Only the driver can control music',
    
    -- Quality Settings
    ['quality_low'] = 'Low (144p)',
    ['quality_medium'] = 'Medium (240p)',
    ['quality_high'] = 'High (360p)',
    ['quality_ultra'] = 'Ultra (720p)',
    
    -- Proximity Messages
    ['proximity_range'] = 'Proximity Range: %d meters',
    ['proximity_volume'] = 'Proximity Volume: %d%%',
    ['max_volume'] = 'Maximum Volume: %d%%',
    ['others_can_hear'] = 'Others can hear your music!',
    ['music_nearby'] = 'Music playing nearby',
    
    -- Loading Messages
    ['loading_video'] = 'Loading video...',
    ['buffering'] = 'Buffering...',
    ['connecting'] = 'Connecting...',
    ['processing'] = 'Processing...',
    
    -- Playlist Messages
    ['playlist_empty_description'] = 'Your playlist is empty. Add songs from the search tab.',
    ['playlist_item_added'] = 'Item added to playlist',
    ['playlist_item_removed'] = 'Item removed from playlist',
    ['playlist_reordered'] = 'Playlist reordered',
    ['playlist_shuffled'] = 'Playlist shuffled',
    ['playlist_exported'] = 'Playlist exported',
    ['playlist_imported'] = 'Playlist imported',
    
    -- History Messages
    ['history_cleared'] = 'History cleared',
    ['history_empty'] = 'No recent URLs',
    ['history_item_removed'] = 'Item removed from history',
    
    -- Network Messages
    ['connection_lost'] = 'Connection to server lost',
    ['connection_restored'] = 'Connection to server restored',
    ['sync_failed'] = 'Failed to sync with server',
    ['sync_success'] = 'Successfully synced with server',
    
    -- Rate Limiting
    ['rate_limited'] = 'Too many requests. Please wait before trying again.',
    ['cooldown_active'] = 'Please wait %d seconds before the next request',
    
    -- Battery Messages
    ['battery_low'] = 'Vehicle battery is low (%d%%)',
    ['battery_critical'] = 'Vehicle battery is critically low (%d%%)',
    ['battery_dead'] = 'Vehicle battery is dead',
    ['battery_charging'] = 'Vehicle battery is charging',
    
    -- Engine Messages
    ['engine_started'] = 'Engine started',
    ['engine_stopped'] = 'Engine stopped',
    ['engine_stalled'] = 'Engine stalled',
    ['fuel_low'] = 'Fuel is low',
    ['fuel_empty'] = 'Out of fuel',
    
    -- Integration Messages
    ['phone_integration'] = 'Connected to phone',
    ['phone_disconnected'] = 'Disconnected from phone',
    ['vehicle_locked'] = 'Vehicle is locked',
    ['vehicle_unlocked'] = 'Vehicle is unlocked',
    ['vehicle_damaged'] = 'Vehicle is too damaged for music',
    
    -- Keybind Descriptions
    ['keybind_open_music'] = 'Open Car Music Player',
    ['keybind_play_pause'] = 'Play/Pause Music',
    ['keybind_next_song'] = 'Next Song',
    ['keybind_prev_song'] = 'Previous Song',
    ['keybind_volume_up'] = 'Volume Up',
    ['keybind_volume_down'] = 'Volume Down',
    ['keybind_shuffle'] = 'Toggle Shuffle',
    ['keybind_repeat'] = 'Toggle Repeat',
    
    -- Help Messages
    ['help_title'] = 'Car Music Player Help',
    ['help_description'] = 'Control music in your vehicle using YouTube URLs',
    ['help_usage'] = 'Usage: Press %s to open the music player while in a vehicle',
    ['help_commands'] = 'Available Commands:',
    ['help_keybinds'] = 'Keybinds:',
    ['help_features'] = 'Features:',
    ['help_support'] = 'For support, contact an administrator',
    
    -- Debug Messages
    ['debug_player_created'] = 'Music player created for %s',
    ['debug_player_destroyed'] = 'Music player destroyed for %s',
    ['debug_music_loaded'] = 'Music loaded: %s',
    ['debug_volume_changed'] = 'Volume changed to %d%% for %s',
    ['debug_proximity_updated'] = 'Proximity audio updated for vehicle %s',
    ['debug_state_synced'] = 'Music state synced for vehicle %s',
    ['debug_cleanup_performed'] = 'Cleanup performed: removed %d old entries',
    
    -- Error Codes
    ['error_code_1'] = 'Error 1: Invalid request',
    ['error_code_2'] = 'Error 2: Player not found',
    ['error_code_3'] = 'Error 3: Vehicle not supported',
    ['error_code_4'] = 'Error 4: Permission denied',
    ['error_code_5'] = 'Error 5: Rate limited',
    ['error_code_6'] = 'Error 6: Invalid URL',
    ['error_code_7'] = 'Error 7: Network error',
    ['error_code_8'] = 'Error 8: Resource unavailable',
    ['error_code_9'] = 'Error 9: Playlist full',
    ['error_code_10'] = 'Error 10: Unknown error',
}