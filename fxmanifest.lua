fx_version 'cerulean'
game 'gta5'

author 'zLeqitEclipse'
description 'ESX Give Car Keys'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua',
	'locales/en.lua',
	'locales/de.lua',
	'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
	'locales/en.lua',
	'locales/de.lua',
	'config.lua'
}

dependency 'es_extended'
