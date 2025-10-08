fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Advanced Car Radio System'
version '2.0.0'

shared_scripts {
    'config.lua',
    'items.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/assets/logo.png'
}

dependencies {
    'qb-core',
    'xsound'
}
