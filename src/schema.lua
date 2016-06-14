return {
    no_consumer = true,
    fields = {
        array_element_count = { required = false, type = "number", default = 20 },
        container_depth = { required = false, type = "number", default = 10 },
        object_entry_count = { required = false, type = "number", default = 15 },
        object_entry_name_length = { required = false, type = "number", default = 50 },
        source = { required = false, type = "string", enum = {"request", "response", "message"}, default = "request" },
        string_value_length = { required = false, type = "number", default = 500 }
    }
}
