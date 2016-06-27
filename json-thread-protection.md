---
id: page-plugin
title: Plugins - Json Threat Protection
header_title: Json Threat Protection
header_icon: /assets/images/icons/plugins/jsonthreadprotection.png
breadcrumbs:
    Plugins: /plugins
nav:
    - label: Getting Started
    items:
        - label: Terminology
        - label: Configuration
---

Like XML-based services, APIs that support JavaScript object notation (JSON) are vulnerable to content-level attacks. Simple JSON attacks attempt to use structures that overwhelm JSON parsers to crash a service and induce application-level denial-of-service attacks. All settings are optional and should be tuned to optimize your service requirements against potential vulnerabilities.

----

## Terminology

- `API`: your upstream service, for which Kong proxies requests to.
- `Plugin`: a plugin executes actions inside Kong during the request/response lifecycle.
- `Consumer`: a developer or service using the API. When using Kong, a Consumer authenticates itself with Kong which proxies every call to the upstream API.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
--data "name=json-threat-protection"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter            | required     | description
---                       | ---          | ---
`name`                    | *required*   | The name of the plugin to use, in this case: `json-threat-protection`
`config.array_element_count`  | *optional*   | Specifies the maximum number of elements allowed in an array. If you do not specify this element, or if you specify a negative integer, the system does not enforce a limit. Defaults to `0`.
`config.container_depth`  | *optional*   | Specifies the maximum allowed containment depth, where the containers are objects or arrays. For example, an array containing an object which contains an object would result in a containment depth of 3. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.object_entry_count`  | *optional*   | Specifies the maximum number of entries allowed in an object. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.object_entry_name_length`  | *optional*   | Specifies the maximum string length allowed for a property name within an object. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.source`  | *optional*   | Message to be screened for JSON payload attacks. This is most commonly set to request, as you will typically need to validate inbound requests from client apps. When set to message, this element will automatically evaluate the request message when attached to the request flow and the response message when attached to the response flow. Valid values: request, response, or message. Defaults to `request`.
`config.string_value_length`  | *optional*   | Specifies the maximum length allowed for a string value. If you do not specify this element, or if you specify a negative integer, the system does not enforce a limit. Defaults to `0`.

----


