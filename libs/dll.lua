--STOPSKIDDINGSKID
--dll.lua
--speedsterkawaii
--startup/init script for NYX

--main functions

checkcaller = function()
    return true 
end

newcclosure = function(a1)
	return coroutine_wrap(function(...)
		while true do
			coroutine_yield(a1(...))
		end
	end)
end

getfpscap = function()
    local ren = game:GetService("RunService").RenderStepped:Wait()
    return math.floor(1 / ren + 0.5)
end

setfpscap = function(fps)
end

getsenv = function(script)--may have to rewrite this
    if typeof(script) ~= "Instance" or (script.ClassName ~= "Script" and script.ClassName ~= "LocalScript" and script.ClassName ~= "ModuleScript") then
        error("must be a Script, LocalScript, or ModuleScript.", 69)
    end
    
    local env = {
        script = script
    }
    
    return env
end

getscripthash = function(script)
    assert(typeof(script) == "Instance" and script:IsA("LuaSourceContainer"), 
           "argument #1 is not a 'LuaSourceContainer'", 0)
    return script:GetHash()
end


getrunningscripts = function()
    local returnable = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and v.Enabled then
            table.insert(returnable, v)
        elseif v:IsA("ModuleScript") then
            table.insert(returnable, v)
        end
    end
    return returnable
end

getcallingscript = function()
    local s = debug.info(2, 's')  
    for _, v in ipairs(game:GetDescendants()) do
        if v:GetFullName() == s then
            return v
        end
    end
    return nil
end

fireclickdetector = function(part)
    local cd = part:FindFirstChild("ClickDetector") or part
    local oldParent = cd.Parent
    local p = Instance.new("Part")
    
    p.Transparency = 1
    p.Size = Vector3.new(30, 30, 30)
    p.Anchored = true
    p.CanCollide = false
    p.Parent = workspace

    cd.Parent = p
    cd.MaxActivationDistance = math.huge

    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        p.CFrame = workspace.Camera.CFrame * CFrame.new(0, 0, -20) + 
                    (workspace.Camera.CFrame.LookVector * Vector3.new(1, 1, 1))
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(20, 20), workspace.CurrentCamera.CFrame)
    end)

    cd.MouseClick:Once(function()
        conn:Disconnect()
        cd.Parent = oldParent
        p:Destroy()
    end)
end

randomstring = function(length)
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""

    for i = 1, length do
        local index = math.random(1, #characters)
        result = result .. characters:sub(index, index)
    end

    return result
end

crash = function()--why do i have?
  while true do 
  end
end

identifyexecutor = function()
    local name = randomstring(3)
    local version = "5.0" 

    return name, version
end


GetObjects = function(rbx)
	return { game:GetService("InsertService"):LoadLocalAsset(rbx) }
end

isrbxactive = function() --always returns false since our interface is external and requires roblox to be (out of focus)
    return false
end

gethui = function()
    return game:GetService("CoreGui") 
end


getscriptbytecode = function(script)--need to overthink this
    if not script or not script:IsA("Script") then
        return nil
    end
    
    local success, bytecode = pcall(function()
        return script.Source --ill add later i have in c
    end)
    
    if success then
        return bytecode
    else
        return nil
    end
end
dumpstring = getscriptbytecode

IS_NYX_ENV = function(SECURE)
  if (SECURE == "SECURE_ENV") then
    return true --in special cases!
  else
    return false
end

iscclosure = function(a) 
	return not pcall(function(b,c)
		setfenv(a, getfenv(a))
		return b,c
	end)
end


islclosure = function(a) 
	return pcall(function(b,c)
		setfenv(a, getfenv(a))
		return b,c
	end)
end

getinstances = function()
	return game:GetDescendants()
end

getscripts = function()
	local a = {}
	for i,v in pairs(getinstances()) do
		if v:IsA("LocalScript") or v:IsA("ModuleScript") then
			table.insert(a, v)
		end
	end
	return a
end

request = function(options)  
    local Event = Instance.new("BindableEvent") 
    local RequestInternal = game:GetService("HttpService").RequestInternal
    local Request = RequestInternal(game:GetService("HttpService"), options)
    local Start = Request.Start
    local Response 
    Start(Request, function(state, response)
        Response = response Event:Fire() end) 
    Event.Event:Wait() 
    return Response 
end
http_request = request

HttpGet = function(url)
    return request({
        Url = url,
        Method = "GET"
    }).Body
end

getgenv = function(a, b) -- Bad getgenv, it is detected in games that have a check if getfenv is edited. It might get detected or not.
	return a and b and rawset(getfenv(), a, b) or rawget(getfenv(), a) or setmetatable({}, {__index = getfenv(),__newindex = function(self, index, value)getfenv()[index] = value end})
end
  

--thread identity level spoofing yes
--not in C need ls access

local exploit_thread = 3

getthreadidentity = function()
    return exploit_thread 
end

identity_spoofed = function()
  print("Current identity is "..exploit_thread)
end

setthreadidentity = function(identity)
    if type(identity) ~= "number" then
        error("identity must be a number", 69420)
    end
    exploit_thread = identity 
    printidentity = identity_spoofed 
end

getidentity = getthreadidentity
getthreadcontext = getthreadidentity

setidentity = setthreadidentity
setthreadcontext = setthreadidentity

--libraries 
--file lib 
--enc stuff

local files = {}
local folders = {}

function isfolder(path)
    return folders[path] ~= nil
end

function makefolder(path)
    if not isfolder(path) then
        folders[path] = true
    end
end

function delfolder(path)
    if isfolder(path) then
        folders[path] = nil
        for filePath in pairs(files) do
            if filePath:match("^" .. path .. "/") then
                files[filePath] = nil
            end
        end
    end
end

function writefile(path, content)
    files[path] = content
end

function readfile(path)
    return files[path] or nil
end

function appendfile(path, content)
    if files[path] then
        files[path] = files[path] .. content
    else
        files[path] = content
    end
end

function isfile(path)
    return files[path] ~= nil
end

function listfiles(path)
    local result = {}
    for filePath in pairs(files) do
        if path == nil or filePath:match("^" .. (path .. "/") or "^" .. path .. "$") then
            table.insert(result, filePath)
        end
    end
    return result
end

function delfile(path)
    if isfile(path) then
        files[path] = nil
    end
end

function loadfile(path)
    local content = readfile(path)
    if content then
        return loadstring(content)
    end
end

function dofile(path)
    local func = loadfile(path)
    if func then
        func()
    end
end

lz4compress = function(input)
	local output = ""
	local pos = 1
	local len = #input
	while pos <= len do
		local max_match_len = 0
		local max_match_pos = pos
		local len = #input
		for i = pos - 1, 1, -1 do
			local match_len = 0
			while i + match_len <= len and input:sub(pos + match_len, pos + match_len) == input:sub(i + match_len, i + match_len) do
				match_len = match_len + 1
			end
			if match_len > max_match_len then
				max_match_len = match_len
				max_match_pos = i
			end
		end
		local match_pos, match_len = max_match_pos, max_match_len
		if match_len > 4 then
			output = output .. "*" .. string.char(math.floor(match_pos / 256)) .. string.char(match_pos % 256) .. string.char((match_len - 4) % 256)
			pos = pos + match_len
		else
			output = output .. input:sub(pos, pos)
			pos = pos + 1
		end
	end
	return output
end

lz4decompress = function(input)
	local output = ""
	local pos = 1
	local len = #input
	while pos <= len do
		local byte = input:sub(pos, pos)
		if byte == "*" then
			local match_pos = input:byte(pos + 1) * 256 + input:byte(pos + 2)
			local match_len = input:byte(pos + 3) + 4
			output = output .. output:sub(#output - match_pos + 1, #output - match_pos + match_len)
			pos = pos + 4
		else
			output = output .. byte
			pos = pos + 1
		end
	end
	return output
end

base64encode = function(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

base64decode = function(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end
