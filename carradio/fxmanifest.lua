fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Advanced Car Radio System'
version '1.0.0'

shared_script {
    '@qb-core/shared/locale.lua',
    'config.lua'
}
dependencies {
    'qb-core',
    'pma-voice'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}

client_script 'client.lua'
server_script 'server.lua'
