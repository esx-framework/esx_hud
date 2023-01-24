fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'ESX hud'
version '1.0.2'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/player/main.lua',
	'client/vehicle/main.lua'
}

ui_page 'web/dist/index.html'

files {
	'web/dist/**',
	'web/dist/assets/**',
}

dependencies {
    'es_extended',
    'esx_status',
	'oxmysql'
  }
