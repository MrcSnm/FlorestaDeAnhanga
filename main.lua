require "src.libs"

function love.load()
    global_init()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    gStateMachine = StateMachine
    {
        ["menu"] = MenuState,
        ["main"] = MainState
    }

    gStateMachine:change("menu")
    

end

function checkCollision(map, collisionLayers, x, y)
    local _x, _y = map:convertPixelToTile(x,y)
    _x = math.floor(_x)
    _y = math.floor(_y)
    for k, layer in ipairs(collisionLayers) do
        local tile = layer.data[_y][_x]
        if tile then
            print(layer.name)
            return true
        end
    end
end



function love.mousepressed(x, y, button)
    love.mouse.hasBeenPressed = true
end

function love.mouse.wasPressed()
    return love.mouse.hasBeenPressed
end


function love.keypressed(key)
    global_keypress(key)
    
end

function love.keyreleased(key)
    global_keyup(key)
end


function love.update(dt)
    gStateMachine:update(dt)
    global_update(dt)
end


function love.resize(w,h)
    --push:resize(w,h)
    
end

function love.draw()
    gStateMachine:render()
end