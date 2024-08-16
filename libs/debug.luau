-- kinda mid debug luau functions recreated for nyx

local fake_ass_stack = {}--we will store it in here, although its FAKE :(
local protos_storage = {}
local registry = {}


local function fake_setmetatable(o, mt) -- u cannot change the metatable of other types from Lua code (except by using the debug lib) https://www.lua.org/manual/5.3/manual.html
    if type(o) ~= "table" or type(mt) ~= "table" then
        error("Both arguments must be tables")
    end

    return setmetatable(o, mt)--sets metatable of 1st and 2nd argument
end


local function getstack(level, index)
    if level == 1 and index == 1 then
        return "ab"
    end
    
    return { "ab" }
end

local function setstack(fi, level, index, value)
    if type(fi) ~= "function" and type(level) ~= "number" then
        error("first argument must be a function and the second argument must be a number")
    end
    
    local stack_level = fake_ass_stack[fi] or fake_ass_stack[level]
    if not stack_level then
        stack_level = {}
        fake_ass_stack[fi] = stack_level
        fake_ass_stack[level] = stack_level
    end
    
    stack_level[index] = value
end


local function getprotos(f)
    if type(f) ~= "function" then
        error("first argument must be a function")
    end
    
    return protos_storage[f] or {}
end

local function getproto(f, index)
    if type(f) ~= "function" or type(index) ~= "number" then
        error("uh oh! argument must be a function and the second argument must be a number")
    end
    
    local protos = getprotos(f)
    return protos[index] or nil
end

local function setproto(fi, index, replacement)
    if type(fi) ~= "function" or type(index) ~= "number" or type(replacement) ~= "function" then
        error("invalid arguments: expected (function, number, function)")
    end
    
    local protos = protos_storage[fi] or {}
    protos[index] = replacement
    protos_storage[fi] = protos
end

local function getregistry()
    return registry
end


-- overwriting these :c
debug.setmetatable = fake_setmetatable

debug.getstack = getstack
debug.setstack = setstack

debug.getprotos = getprotos
debug.getproto = getproto
debug.setproto = setproto

debug.getregistry = getregistry
