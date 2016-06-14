local cjson = require "cjson"
local responses = require "kong.tools.responses"
local BasePlugin = require "kong.plugins.base_plugin"

local JsonThreadProtectionHandler = BasePlugin:extend()

JsonThreadProtectionHandler.PRIORITY = 500

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

    local status, res = pcall(cjson.decode, body)
    if not status then
        return nil, responses.send_HTTP_BAD_REQUEST("Invalid container depth, max " .. config.container_depth .. " allowed.")
    end

    -----------------------------------
    -- Validate the array element count
    -----------------------------------
    if config.array_element_count > 0 then

    end

    -----------------------------------
    -- Validate the object entry count
    -----------------------------------
    if config.object_entry_count > 0 then

    end

    -----------------------------------
    -- Validate the entry name length
    -----------------------------------
    if config.object_entry_name_length > 0 then

    end

    -----------------------------------
    -- Validate the string value length
    -----------------------------------
    if config.string_value_length > 0 then

    end
end

return JsonThreadProtectionHandler

