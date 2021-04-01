fx_version 'cerulean'

game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/*css',
	'html/static/js/*.js',

	'html/static/config/config.json',

	'html/static/img/*.png',
	'html/static/img/coque/*.png',
	'html/static/img/background/*.jpg',
	'html/static/img/icons_app/*.png',
	'html/static/img/icons_app/*.svg',
	'html/static/img/app_bank/*.png',
	'html/static/img/app_tchat/*.png',
	'html/static/img/twitter/*.png',
	'html/static/sound/Twitter_Sound_Effect.ogg',
	'html/static/fonts/fontawesome-webfont.eot',
	'html/static/fonts/fontawesome-webfont.ttf',
	'html/static/fonts/fontawesome-webfont.woff',
	'html/static/fonts/fontawesome-webfont.woff2',

	'html/static/sound/*.ogg',

}

client_script {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/animation.lua',
	'client/client.lua',
	'client/photo.lua',
	'client/app_tchat.lua',
	'client/bank.lua',
	'client/twitter.lua',

	-- ADDONS

	-- Racing
	'addons/racing/client.lua',

	-- Service calls
	'addons/pscall/client.lua'
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/server.lua',
	'server/app_tchat.lua',
	'server/twitter.lua',

	-- ADDONS

	-- Racing
	'addons/racing/server.lua',

	-- Service calls
	'addons/pscall/server.lua'
}
