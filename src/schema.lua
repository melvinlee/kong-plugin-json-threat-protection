return {
    no_consumer = true,
    fields = {
        array_element_count = { required = false, type = "number", default = 0 },
        container_depth = { required = false, type = "number", default = 0 },
        object_entry_count = { required = false, type = "number", default = 0 },
        object_entry_name_length = { required = false, type = "number", default = 0 },
        source = { required = false, type = "string", enum = {"request", "response", "message"}, default = "request" },
        string_value_length = { required = false, type = "number", default = 0 }
    }
}
