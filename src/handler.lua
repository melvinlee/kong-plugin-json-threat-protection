local cjson = require "cjson"
local string = require "string"
local responses = require "kong.tools.responses"
local BasePlugin = require "kong.plugins.base_plugin"

local JsonThreadProtectionHandler = BasePlugin:extend()

JsonThreadProtectionHandler.PRIORITY = 500

----------------------
-- Utility function --
----------------------

-- Determine with a Lua table can be treated as an array.
-- Explicitly returns "not an array" for very sparse arrays.
-- Returns:
-- -1   Not an array
-- 0    Empty table
-- >0   Highest index in the array
local function is_array(table)
    local max = 0
    local count = 0
    for k, v in pairs(table) do
        if type(k) == "number" then
            if k > max then max = k end
            count = count + 1
        else
            return -1
        end
    end
    if max > count * 2 then
        return -1
    end

    return max
end

function validateJson(json, array_element_count, object_entry_count, object_entry_name_length, string_value_length)
    if type(json) == "table" then

        --------------------------------------
        -- Validate the array element count --
        --------------------------------------
        if array_element_count > 0 then
            local array_children = is_array(json)
            if array_children > array_element_count then
                return responses.send_HTTP_BAD_REQUEST("Invalid array element count, max " .. array_element_count .. " allowed, found " .. array_children .. ".")
            end
        end

        local children_count = 0
        for k,v in pairs(json) do
            children_count = children_count + 1
            ------------------------------------
            -- Validate the entry name length --
            ------------------------------------
            if object_entry_name_length > 0 then
                if string.len(k) > object_entry_name_length then
                    return responses.send_HTTP_BAD_REQUEST("Invalid object entry name length, max " .. object_entry_name_length .. " allowed, found " .. string.len(k) .. " (" .. k .. ").")
                end
            end

            -- recursively repeat the same procedure
            validateJson(v, array_element_count, object_entry_count, object_entry_name_length, string_value_length)
        end

        -------------------------------------
        -- Validate the object entry count --
        -------------------------------------
        if object_entry_count > 0 then
            if children_count > object_entry_count then
                return responses.send_HTTP_BAD_REQUEST("Invalid object entry count, max " .. object_entry_count .. " allowed, found " .. children_count .. ".")
            end
        end

    else
        --------------------------------------
        -- Validate the string value length --
        --------------------------------------
        if string_value_length > 0 then
            if string.len(json) > string_value_length then
                return responses.send_HTTP_BAD_REQUEST("Invalid string value length, max " .. string_value_length .. " allowed, found " .. string.len(json) .. " (" .. json .. ").")
            end
        end
    end
end

---------------------------
-- Plugin implementation --
---------------------------

function JsonThreadProtectionHandler:new()
    JsonThreadProtectionHandler.super.new(self, "JSON Thread Protection")
end

function JsonThreadProtectionHandler:access(config)
    JsonThreadProtectionHandler.super.access(self)

    ngx.req.read_body()
    local body = ngx.req.get_body_data()

    -- TODO: Error when no json body?
    if not body then
        return nil, responses.send_OK()
    end

    -------------------------------
    -- Validate the container depth
    -------------------------------
    if config.container_depth > 0 then
        cjson.decode_max_depth(config.container_depth)
    end

    local status, json = pcall(cjson.decode, body)
    if not status then
        return responses.send_HTTP_BAD_REQUEST("Invalid container depth, max " .. config.container_depth .. " allowed.")
    end

    -- source

    validateJson(json, config.array_element_count, config.object_entry_count, config.object_entry_name_length, config.string_value_length)

    return responses.send_HTTP_OK()

end

return JsonThreadProtectionHandler

