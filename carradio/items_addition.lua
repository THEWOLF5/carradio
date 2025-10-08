-- QB-CarMusic Items Integration
-- Add these items to your qb-core/shared/items.lua file

-- IMPORTANT: Add these entries to your existing items.lua file
-- Do NOT replace the entire file, just add these entries

-- Car Music Player Items (Optional - if you want physical items)
['car_radio'] = {
    ['name'] = 'car_radio',
    ['label'] = 'Car Radio System',
    ['weight'] = 2500,
    ['type'] = 'item',
    ['image'] = 'car_radio.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Advanced car radio system with YouTube streaming capability. Install in compatible vehicles.'
},

['car_speakers'] = {
    ['name'] = 'car_speakers',
    ['label'] = 'Premium Car Speakers',
    ['weight'] = 1500,
    ['type'] = 'item',
    ['image'] = 'car_speakers.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'High-quality speakers for enhanced audio experience. Increases maximum volume and audio quality.'
},

['car_amplifier'] = {
    ['name'] = 'car_amplifier',
    ['label'] = 'Car Audio Amplifier',
    ['weight'] = 3000,
    ['type'] = 'item',
    ['image'] = 'car_amplifier.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Professional audio amplifier. Increases proximity range and volume output.'
},

['car_subwoofer'] = {
    ['name'] = 'car_subwoofer',
    ['label'] = 'Car Subwoofer',
    ['weight'] = 4000,
    ['type'] = 'item',
    ['image'] = 'car_subwoofer.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Heavy-duty subwoofer for deep bass. Enhances audio quality and presence.'
},

['bluetooth_adapter'] = {
    ['name'] = 'bluetooth_adapter',
    ['label'] = 'Bluetooth Audio Adapter',
    ['weight'] = 200,
    ['type'] = 'item',
    ['image'] = 'bluetooth_adapter.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Wireless audio adapter for streaming music. Enables remote control features.'
},

-- Car Audio Enhancement Items
['audio_upgrade_kit'] = {
    ['name'] = 'audio_upgrade_kit',
    ['label'] = 'Audio Upgrade Kit',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'audio_upgrade_kit.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Complete audio upgrade kit. Improves overall sound quality and unlocks advanced features.'
},

['premium_membership'] = {
    ['name'] = 'premium_membership',
    ['label'] = 'Premium Music Membership',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'premium_membership.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Premium music streaming membership. Unlocks high-quality audio and extended playlist features.'
},

-- Installation Tools
['car_tool_kit'] = {
    ['name'] = 'car_tool_kit',
    ['label'] = 'Car Installation Toolkit',
    ['weight'] = 1500,
    ['type'] = 'item',
    ['image'] = 'car_tool_kit.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Professional tools for installing car audio equipment. Required for audio system installations.'
},

-- Optional: Music-related consumables
['aux_cable'] = {
    ['name'] = 'aux_cable',
    ['label'] = 'AUX Audio Cable',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'aux_cable.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Standard 3.5mm auxiliary audio cable for direct device connection.'
},

['usb_cable'] = {
    ['name'] = 'usb_cable',
    ['label'] = 'USB Audio Cable',
    ['weight'] = 150,
    ['type'] = 'item',
    ['image'] = 'usb_cable.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'USB cable for charging devices and digital audio connection.'
},

-- VIP/Special Items
['golden_radio'] = {
    ['name'] = 'golden_radio',
    ['label'] = 'Golden Car Radio',
    ['weight'] = 5000,
    ['type'] = 'item',
    ['image'] = 'golden_radio.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Rare golden car radio with unlimited features. Shows premium status and unlocks exclusive options.'
},

['diamond_speakers'] = {
    ['name'] = 'diamond_speakers',
    ['label'] = 'Diamond-Encrusted Speakers',
    ['weight'] = 3000,
    ['type'] = 'item',
    ['image'] = 'diamond_speakers.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Luxury speakers with diamond accents. Provides the highest audio quality and maximum proximity range.'
},

-- Alternative: If you prefer NOT to use physical items
-- You can comment out all the above items and the music system
-- will work without requiring any inventory items

--[[
    INSTALLATION NOTES:
    
    1. Copy the items you want from above
    2. Paste them into your qb-core/shared/items.lua file
    3. Make sure to add commas between items if needed
    4. Create corresponding images for each item (128x128 PNG format)
    5. Place images in your inventory resource's images folder
    
    IMAGE NAMES NEEDED:
    - car_radio.png
    - car_speakers.png
    - car_amplifier.png
    - car_subwoofer.png
    - bluetooth_adapter.png
    - audio_upgrade_kit.png
    - premium_membership.png
    - car_tool_kit.png
    - aux_cable.png
    - usb_cable.png
    - golden_radio.png
    - diamond_speakers.png
    
    OPTIONAL FEATURES:
    If you add these items, you can modify the config.lua to require
    certain items for advanced features:
    
    Config.RequiredItems = {
        basicMusic = nil,                    -- No item required for basic music
        premiumFeatures = 'premium_membership', -- Require membership for premium features
        highQuality = 'car_speakers',        -- Require speakers for high quality
        extendedRange = 'car_amplifier',     -- Require amplifier for extended range
        installation = 'car_tool_kit'        -- Require tools for installations
    }
--]]

--[[
    BUSINESS INTEGRATION IDEAS:
    
    These items can be sold at:
    - Auto parts stores
    - Electronics shops
    - Mechanic shops
    - Premium dealerships
    - Black market (for rare items)
    
    You can also integrate with:
    - Crafting systems
    - Vehicle modification shops
    - Player-owned businesses
    - Import/export systems
--]]