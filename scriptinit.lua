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
