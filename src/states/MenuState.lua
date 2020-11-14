MenuState = Class("MenuState", State)

local menu 
function MenuState:enter()
    menu = Menu()
    FADER:setColor(0,0,0,1)
    FADER:fadeTo(1, 0, 0, 0, 0)
end

function MenuState:update(dt)
    menu:update(dt)
end

function MenuState:render()
    menu:draw()
end