--[[
   File: misc.lua
   Author: speedsterkawaii

   Poorly written functions 💔💔 vanities macros aliases etc
]]

--todo later: it CAN work but i think we need to revert the modulescripts source or something
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        --nyxsigned_module_injection_restart()
         system("msg * TELEPORT FAILURE") -- cheap me
    end
end)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Watermark = Instance.new('ScreenGui', Players.LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new('Frame', Watermark)
local ImageLabel = Instance.new('ImageLabel', Frame)

Watermark.Name = "Watermark"
Watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel.Position = UDim2.new(0.4151, 0, 0.3941, 0) -- Fixed position
ImageLabel.Size = UDim2.new(0, 325, 0, 204)
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel.Image = "rbxassetid://18864815989"
ImageLabel.ScaleType = Enum.ScaleType.Crop
ImageLabel.ImageTransparency = 1 -- Start fully transparent

local blurEffect = Instance.new("BlurEffect", Lighting)
blurEffect.Size = 0 

local function animateImage()
    local blurIn = TweenService:Create(blurEffect, TweenInfo.new(1), {Size = 24}) -- Maximum blur
    blurIn:Play()

    local fadeIn = TweenService:Create(ImageLabel, TweenInfo.new(1), {ImageTransparency = 0})
    fadeIn:Play()
    fadeIn.Completed:Wait()

    wait(2)

    local fadeOut = TweenService:Create(ImageLabel, TweenInfo.new(1), {ImageTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()

    local blurOut = TweenService:Create(blurEffect, TweenInfo.new(1), {Size = 0})
    blurOut:Play()
    blurOut.Completed:Wait()

    blurEffect:Destroy()
    Watermark:Destroy()
end

animateImage()



-- too lazy to do it but its possible, just not the best :c
function firesignal(signal) -- this will fire all connections for a given RBXScriptSignal
    if typeof(signal) ~= "RBXScriptSignal" then
        error("Expected an RBXScriptSignal, got " .. typeof(signal)) --todo: replace error with warn later on because error has a problem where execution stops? idk its odd
    end

   -- I AM NOT DOING THE REST
   error("firesignal is not implanted")
end

function info(...) -- possible via print address but im external so
  print(...)
end

function getfpscap() -- not effective it will always return 60
    local fps = workspace:GetRealPhysicsFPS()
    return fps
end

function GetObjects(id)
    local objects = {}
    table.insert(objects, game:GetService("InsertService"):LoadLocalAsset(id))
    return objects
end


-- aliases or fake

function getconnections(signal: RBXScriptSignal): {Connection} -- FAKE i will work on this another day
    local connections = {}

    local function mockConnection(func)
        local conn = {}
        conn.Enabled = true
        conn.ForeignState = false
        conn.LuaConnection = true
        conn.Function = func
        conn.Thread = coroutine.running()

        function conn:Fire(...)
            if self.Enabled then
                func(...)
            end
        end

        function conn:Defer(...)
            if self.Enabled then
                task.defer(func, ...)
            end
        end

        function conn:Disconnect()
            self.Enabled = false
        end

        function conn:Disable()
            self.Enabled = false
        end

        function conn:Enable()
            self.Enabled = true
        end

        return conn
    end

    for i = 1, 5 do
        table.insert(connections, mockConnection(function() print("Connected function " .. i) end))
    end

    return connections
end

local cyropackage = [[
local CorePackages = game:GetService("CorePackages") return require(CorePackages.Packages.Cryo)
]]
local jestshit = [[
local CorePackages = game:GetService("CorePackages")
return require(CorePackages.Packages.Dev.JestGlobals)
]]
-- fake decompile to expirement with
function decompile(source)
    if source:IsA("LocalScript") then
        return "-- Disassembled "..source.Name
    elseif source:IsA("ModuleScript") then
        if source.Name == "JestGlobals" then
            return jestshit
        elseif source.Name == "Cryo" then
            return cyropackage
        else
            return "-- Disassembled "..source.Name
        end
    else
        return "-- why is bro decompiling a script?"
    end
end

function PROTOSMASHER_LOADED() -- i hate unnamed esp :c
   return true
end

-- more aliases
function toclipboard(junk)
   setclipboard(junk)
end

function setrbxclipboard(junk)
   setclipboard(junk)
end

-- base64 

--[[
why do people need so much aliases just stick to one
]]
-- i have 3 base64 decode and encode functions which 2 are in luau and one is in c
-- and the c one has a problem where it doesnt decode it properly when sent the content
--it has a url decoding problem so im just gonna stick to this temporarily
local basedummy='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function base64_fake_encode(data)
    return ((data:gsub('.', function(x) 
        local r, b = '', x:byte()
        for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
        return b:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

function base64_fake_decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

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
    return base64encode(byteString)
end

crypt.generatekey = function()
    return crypt.generatebytes(32)
end

-- these are placeholders - meaning i gotta add actual function so ill add them later
function crypt.encrypt(data, key, iv, mode)
    local iv = iv or crypt.generatebytes(16)  
    local encrypted = "encrypted_" .. data
    return encrypted, iv
end

function crypt.decrypt(data, key, iv, mode)
    local decrypted = string.gsub(data, "^encrypted_", "")
    return decrypted
end

crypt.hash = function(tohash,algor)
end
