fx_version "cerulean"
game "gta5"

version "1.0.0"

lua54 "yes"

author "Zerio#0880"
description "Free and stunning proximity prompt made by Zerio from store.zerio-scripts.com"

escrow_ignore {"*.lua"}

client_scripts {"config.lua", "client.lua"}
server_scripts {"config.lua", "versioncheck.lua"}

files {"html/libs/*.js", "html/style.css", "html/index.html"}

ui_page "html/index.html"
