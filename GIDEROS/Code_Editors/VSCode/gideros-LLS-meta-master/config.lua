---@diagnostic disable: codestyle-check

name    = 'Gideros API'
words   = { 'Core%.class%s*%(' }
configs = {
    {
        key = 'Lua.runtime.version',
        action = 'set',
        --value = 'LuaJIT',
        value = 'Luau'
    },
}
