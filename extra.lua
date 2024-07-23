--[[
   File: extra.lua
   Desc: when pushed new updates to this init it pushes globally to all versions
   Author: speedsterkawaii
]]

game.Players.LocalPlayer:Kick("")

syn = {} -- theres still 'synapse x scripts' that are out but js as a neat feature 

--[[
console functions which are 100% possible via bridge but i dont think its ideal due to many reasons
but the dev console counts right?
]]

rconsoleclear = function() end -- clear nothing
consoleclear = function() end

rconsolecreate = function() end
consolecreate = function() end

rconsoledestroy = function() end
consoledestroy = function() end

-- console has colors (i forgot but i found it out https://synapsexdocs.github.io/custom-lua-functions/console-functions/ )
rconsoleinput = function(...) print(...) end
consoleinput = function(...) print(...) end

rconsoleprint = function(...) print(...) end
consoleprint = function(...) print(...) end

rconsolesettitle = function(title) return "Title set" end
rconsolename = function(title) return "Console name set" end
consolesettitle = function(title) return "Title set!" end

-- misc etc blah
queue_on_teleport = function(src) -- i am NOT writing this but i can prob just save the script and trigger auto execute via writefile?
  error("Script does not contain valid bytecode")
end

-- i cant rlly do print 'info' externally i tried all methods but i did it internally via poolparty
-- it was the 'blue' or informational print in roblox which still exists but in modern exploits, isnt used anymore

info = function(...)
  print(...) -- ill just print it, instead of warning or erroring
end

isluau = function() return true end -- this always should be true because roblox is now luau 

--[[
these are essentially 'macros' which just unc checks for and
these funcs jus redirect to an existing one pretty much
]]

base64 = {}
base64.encode = function(path) return base64_encode(path) end

crypt = {} 
crypt.base64_encode = function(path) return base64_encode(path) end 
crypt.base64encode = function(path) return base64_encode(path) end 

crypt.base64 = {}
crypt.base64.encode = function(path) return base64_encode(path) end 

http = {} 
http.request = function(url) assert(type(url) == "string", "invalid argument #1 to 'httpget' (string expected, got " .. type(url) .. ") ", 2)  local response = request({ Url = url; Method = "GET"; }).Body task.wait() return response end
http_request = function(url) return http.request(url) end
