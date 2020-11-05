require "src.libs"

function love.load()
    GAME_MAP = sti(GAME_MAP_NAME)

    player = findObject(GAME_MAP, "Player")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        vsync = true,
        resizable = true,
        fullscreen = false  
    })

    love.keyboard.keysPressed = {} 
    love.mouse.hasBeenPressed = false

end

function love.mousepressed(x, y, button)
    love.mouse.hasBeenPressed = true
end

function love.mouse.wasPressed()
    return love.mouse.hasBeenPressed
end


function love.update(dt)

    GAME_MAP:update(dt)

end

function love.resize(w,h)
    push:resize(w,h)
end

function love.draw()

    GAME_MAP:draw()

end