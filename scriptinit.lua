-- NYX INIT SCRIPT hi skid how did you find this?

-- libraries, although these are just macros and redirect to C

base64 = {}
base64.encode = function(path) return base64_encode(path) end
base64.decode = function(path) return base64_decode(path) end

crypt = {} 
crypt.base64_encode = function(path) return base64_encode(path) end 

crypt.base64encode = function(path) return base64_encode(path) end 
crypt.base64_decode = function(path) return base64_decode(path) end
crypt.base64decode = function(path) return base64_decode(path) end

crypt.base64 = {}
crypt.base64.encode = function(path) return base64_encode(path) end 
crypt.base64.decode = function(path) return base64_decode(path) end

http = {} 
http.request = function(url) assert(type(url) == "string", "invalid argument #1 to 'httpget' (string expected, got " .. type(url) .. ") ", 2)  local response = request({ Url = url; Method = "GET"; }).Body task.wait() return response end
http_request = function(url) return http.request(url) end

rconsoleclear = function() end
consoleclear = function() end

rconsolecreate = function() end
consolecreate = function() end

rconsoledestroy = function() end
consoledestroy = function() end

rconsoleinput = function() end
consoleinput = function() end

rconsoleprint = function() end
consoleprint = function() end

rconsolesettitle = function() end
rconsolename = function() end
rconsolename = function() end

-- attempted (at least) to recreate script functions

checkcaller = function()
    return true
end

getcallingscript = function()
    return "no calling script!"
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
