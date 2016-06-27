local schemas = require "kong.dao.schemas_validation"
local validate_entity = schemas.validate_entity

local json_thread_protection_schema = require "kong.plugins.json-thread-protection.schema"

describe("JSON Thread Protection schema", function()
    it("should work when no configuration has been set", function()
        local config = {}
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.array_element_count == 0)
        assert.is_true(config.container_depth == 0)
        assert.is_true(config.object_entry_count == 0)
        assert.is_true(config.object_entry_name_length == 0)
        assert.is_true(config.source == "request")
        assert.is_true(config.string_value_length == 0)
    end)

    it("should work when array element count is not set", function()
        local config = { container_depth = 10, object_entry_count = 15, object_entry_name_length = 15, source = "request", string_value_length = 100 }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.array_element_count == 0)
    end)

    it("should work when container depth is not set", function()
        local config = { array_element_count = 10, object_entry_count = 15, object_entry_name_length = 15, source = "request", string_value_length = 100 }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.container_depth == 0)
    end)

    it("should work when object entry count is not set", function()
        local config = { array_element_count = 10, container_depth = 15, object_entry_name_length = 15, source = "request", string_value_length = 100 }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.object_entry_count == 0)
    end)

    it("should work when object entry entry name length is not set", function()
        local config = { array_element_count = 10, container_depth = 15, object_entry_count = 15, source = "request", string_value_length = 100 }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.object_entry_name_length == 0)
    end)

    it("should work when source is not set", function()
        local config = { array_element_count = 10, container_depth = 15, object_entry_count = 15, object_entry_name_length = 10, string_value_length = 100 }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.source == "request")
    end)

    it("should not work when source has an invalid value", function()
        local config = { source = "unknown" }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.falsy(valid)
        assert.truthy(err)
    end)

    it("should work when string value length is not set", function()
        local config = { array_element_count = 10, container_depth = 15, object_entry_count = 15, object_entry_name_length = 10, source = "request" }
        local valid, err = validate_entity(config, json_thread_protection_schema)
        assert.truthy(valid)
        assert.falsy(err)
        assert.is_true(config.string_value_length == 0)
    end)
end)
