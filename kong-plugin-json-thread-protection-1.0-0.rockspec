package = "kong-plugin-json-thread-protection"
version = "1.0-0"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/Trust1Team/kong-plugin-json-thread-protection",
  tag = "1.0.0"
}
description = {
  summary = "The Kong JSON Thread Protection plugin.",
  license = "MIT",
  homepage = "http://www.trust1team.com",
  detailed = [[
  ]],
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.json-thread-protection.handler"] = "src/handler.lua",
    ["kong.plugins.json-thread-protection.schema"] = "src/schema.lua"
  }
}