-- i can do this via bridge i just dont feel like it
local vim = game:GetService('VirtualInputManager')

 function mouse1click(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 0, true, game, false)
    task.wait()
    vim:SendMouseButtonEvent(x, y, 0, false, game, false)
end

 function mouse2click(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 1, true, game, false)
    task.wait()
    vim:SendMouseButtonEvent(x, y, 1, false, game, false)
end

 function mouse1press(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 0, true, game, false)
end

 function mouse1release(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 0, false, game, false)
end

 function mouse2press(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 1, true, game, false)
end

 function mouse2release(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseButtonEvent(x, y, 1, false, game, false)
end

 function mousescroll(x, y, a)
    x, y = x or 0, y or 0
    vim:SendMouseWheelEvent(x, y, a or false, game)
end

 function mousemoverel(relx, rely)
    relx, rely = relx or 0, rely or 0
    local Pos = workspace.CurrentCamera.ViewportSize
    local x = Pos.X * relx
    local y = Pos.Y * rely
    vim:SendMouseMoveEvent(x, y, game)
end

 function mousemoveabs(x, y)
    x, y = x or 0, y or 0
    vim:SendMouseMoveEvent(x, y, game)
end
