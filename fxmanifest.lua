fx_version 'adamant'

game 'gta5'

description 'MasterkinG32 Robbery'

version '1.0.0'

client_scripts {
	'config.lua',
	'client/*.lua'
}
server_scripts {
	'config.lua',
	'server/server.lua',
	'server/masterking32_loader.lua'
}

dependency 'es_extended'
