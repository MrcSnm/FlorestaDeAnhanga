MenuState = Class("MenuState", State)

local menu 
function MenuState:enter()
    menu = Menu()

end

function MenuState:update(dt)
    menu:update(dt)
end

function MenuState:render()
    menu:draw()
end