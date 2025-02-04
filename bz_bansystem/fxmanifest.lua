fx_version 'cerulean'
game 'gta5'

author 'BRAINLEZZ'
description 'Simple ban script'
version '1.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Use OxMySQL
    'server.lua'
}

dependencies {
    'oxmysql', -- Make sure OxMySQL is installed
    'es_extended' -- If using ESX, otherwise remove
}