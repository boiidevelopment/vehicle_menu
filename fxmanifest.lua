--[[
---------------------------
  ____   ____ _____ _____ 
 |  _ \ / __ \_   _|_   _|
 | |_) | |  | || |   | |  
 |  _ <| |  | || |   | |  
 | |_) | |__| || |_ _| |_ 
 |____/ \____/_____|_____|
                                                    
---------------------------                                              
       Vehicle Menu
          V1.0.0              
---------------------------
]]

fx_version 'cerulean'
games { 'gta5' }

name 'vehicle_menu'
version '1.0.0'
description 'BOII Development - Vehicle Menu (Standalone)'
author 'boiidevelopment'
lua54 'yes'

ui_page 'ui/index.html'
nui_callback_strict_mode 'true'

files {
    'ui/**'
}

shared_script 'loader.lua'
shared_script 'config.lua'
shared_script 'utils.lua'

shared_scripts {
    'locales/*'
}

server_scripts {
    'modules/**/server.lua'
}

client_scripts {
    'modules/**/client.lua',
    'ui/lua/*'
}

escrow_ignore {
    '**'
}