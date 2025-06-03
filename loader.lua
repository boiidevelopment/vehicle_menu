--- @section Constants

local SELECTED_LANGUAGE <const> = GetConvar('locale', 'en-EN'):lower()
local LANGUAGE <const> = SELECTED_LANGUAGE:gsub('en%-', '')

--- @section Tables

local locale = {}

--- @section Import Utils Modules

--- Notifications Module
NOTIFICATIONS = exports.boii_utils:get('modules.notifications')

--- Keys Module
KEYS = exports.boii_utils:get('modules.keys')
KEY_LIST = KEYS.get_keys()

-- Vehicles Module.
VEHICLES = exports.boii_utils:get('modules.vehicles')

--- @section Functions

--- Loads the locale file based on the server configured language.
if IsDuplicityVersion() then
    local function load_locale(language)
        local file_path = ('locales/%s.lua'):format(language)
        local file_content = LoadResourceFile(GetCurrentResourceName(), file_path)
        if not file_content then return load_locale('en') end
        local success, locale_table = pcall(function() return assert(load(file_content))() end)
        if not success or type(locale_table) ~= 'table' then return load_locale('en') end
        locale = locale_table
    end
    load_locale(LANGUAGE)

    RegisterServerEvent('vehicle_menu:sv:request_locale')
    AddEventHandler('vehicle_menu:sv:request_locale', function()
        local src = source
        TriggerClientEvent('vehicle_menu:cl:receive_locale', src, locale)
    end)
else
    RegisterNetEvent('vehicle_menu:cl:receive_locale')
    AddEventHandler('vehicle_menu:cl:receive_locale', function(locale_data)
        print('client received locale')
        locale = locale_data
    end)

    local function request_locale()
        TriggerServerEvent('vehicle_menu:sv:request_locale')
    end
    request_locale()
end

--- Retrieves a string from the loaded language file.
--- @param key string: String name for locale entry.
--- @param ... any: Optional arguments for string formatting.
--- @return string: The locale text.
function L(key, ...)
    return locale[key] and string.format(locale[key], ...) or key
end