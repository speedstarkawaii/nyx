--[[
   File: misc.lua
   Author: speedsterkawaii

   Poorly written functions 💔💔 vanities macros aliases etc
]]

function firesignal(signal) -- this will fire all connections for a given RBXScriptSignal
    if typeof(signal) ~= "RBXScriptSignal" then
        error("Expected an RBXScriptSignal, got " .. typeof(signal)) --todo: replace error with warn later on because error has a problem where execution stops? idk its odd
    end

   -- I AM NOT DOING THE REST
end

function info(...) -- possible via print address but im external so
  print(...)
end

function PROTOSMASHER_LOADED() -- i hate unnamed esp :c
   return true
end

-- unused functions by people, just added though
function random_string(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    if length <= 0 then
        error("Length must be a positive integer.") -- we shall return -10 random length
        return ""
    end
    
    math.randomseed(tick())
    
    local function randomchar()
        local index = math.random(1, #charset)
        return charset:sub(index, index)
    end
    
    local randomresult = ""
    for i = 1, length do
        randomresult = randomresult .. randomchar()
    end
    
    return randomString
end

-- base64 

--[[
why do people need so much aliases just stick to one
this was for unc
]]

crypt = {} -- store
base64 = {}

crypt.base64encode = function(arg1)
return base64encode(arg1)
end

crypt.base64decode = function(arg2)
return base64decode(arg2)
end

crypt.base64_encode = function(arg1)
return base64encode(arg1)
end

crypt.base64_decode = function(arg2)
return base64decode(arg2)
end

crypt.base64 = {}
crypt.base64.encode = function(omg)
return base64encode(omg)
end

crypt.base64.decode = function(stop_making_me_Write_this)
return base64decode(stop_making_me_Write_this)
end

base64.encode = function(vanity)
   return base64encode(vanity)
end

base64.decode = function(vanity)
   return base64decode(vanity)
end

base64_encode = function(vanity)
   return base64encode(vanity)
end

base64_decode = function(vanity)
   return base64decode(vanity)
end

crypt.generatebytes = function(size)
    local randomBytes = {}
    for i = 1, size do
        randomBytes[i] = string.char(math.random(0, 255))
    end
    local byteString = table.concat(randomBytes)
    return crypt.base64Encode(byteString)
end

crypt.generatekey = function()
    return crypt.generatebytes(32)
end
