fx_version("cerulean")
game("gta5")

version("1.0.4")

lua54("yes")

author("Zerio")
description("Free and stunning proximity prompt made by Zerio from store.zerio-scripts.com")

escrow_ignore({ "*.lua" })

shared_scripts({
  -- '@es_extended/imports.lua', -- Uncomment if you use esx legacy 1.8.5 or above
})
client_scripts({ "config.lua", "client.lua" })

files({ "html/libs/*.js", "html/style.css", "html/index.html" })

ui_page("html/index.html")

provides({
  "zerio-proximityprompt",
  "zerio-proximityprompts",
})
