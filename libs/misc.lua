--[[
   File: misc.lua
   Author: speedsterkawaii

   Poorly written functions 💔💔
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

-- unused functions by people, just added though
function random_string(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    if length <= 0 then
        error("Length must be a positive integer.")
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
