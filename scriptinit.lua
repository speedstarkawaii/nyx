--shit too lazy to do in c

writefile("nyx_ver.ver", "3.2")

-- MACROS
base64 = {} base64.encode = function(path) return base64_encode(path) end base64.decode = function(path) return base64_decode(path) end
crypt = {} crypt.base64_encode = function(path) return base64_encode(path) end crypt.base64encode = function(path) return base64_encode(path) end  crypt.base64_decode = function(path) return base64_decode(path) end crypt.base64decode = function(path) return base64_decode(path) end
crypt.base64 = {} crypt.base64.encode = function(path) return base64_encode(path) end  crypt.base64.decode = function(path) return base64_decode(path) end

http = {} 

http.request = function(url) 
assert(type(url) == "string", "invalid argument #1 to 'httpget' (string expected, got " .. type(url) .. ") ", 2) --thanks plusgiant
local response = request({ Url = url; Method = "GET"; }).Body 
task.wait()
return response 
end

function hookfunction(old, hook)--fake
    return function(...)
        local result = {hook(...)}
        
        local oldResult = {old(...)}

        return unpack(result), unpack(oldResult)
    end
end

error = function(msg)
assert(typeof(msg) == "string", "argument #1 expects a string")
msg = string.gsub(msg, "CoreGui.RobloxGui.Modules.Common.PolicyService:0:", "CoreGui.SignedModuleScript:")

print(msg)
end

SAVED_METATABLE = SAVED_METATABLE or {}
local lua_setmetatable = setmetatable
setmetatable = function(a, b)
    local c, d = pcall(function()
        local c = lua_setmetatable(a, b)
    end)
    SAVED_METATABLE[a] = b
    if not c then
        error(d)
    end
    return a
end

getrawmetatable = function(a)
    local Old_Meta = SAVED_METATABLE[a]
    local New = {}
    local New_A = {}
    for i,v in pairs(a) do
        New[i] = v
    end
    return SAVED_METATABLE[a]
end

setrawmetatable = function(a, b)
    local mtb = getrawmetatable(a)
    table.foreach(b, function(aa, bb)
        mtb[aa] = bb
    end)
    return a
end
