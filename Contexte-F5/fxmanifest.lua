----------------------BY DHZ----------------------
---------------discord.gg/ZKJcrDddYx--------------
----------------------BY DHZ----------------------
fx_version 'adamant'
game 'gta5'

shared_scripts {
  'shared/config.lua',
}

client_scripts {
  "src/components/*.lua",
  "src/ContextUI.lua",
  'client/client.lua',
  'client/function.lua'
}

server_scripts {
  '@async/async.lua',
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/server.lua',
}
