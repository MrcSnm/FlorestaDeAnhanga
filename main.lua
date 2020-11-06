require "src.libs"

function love.load()
    GAME_MAP = sti(GAME_MAP_NAME)

    player = Player(GAME_MAP, "Player")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    global_init()
    
end

function love.mousepressed(x, y, button)
    love.mouse.hasBeenPressed = true
end

function love.mouse.wasPressed()
    return love.mouse.hasBeenPressed
end


function love.keypressed(key)
    global_keypress(key)
    --if(key == "right") then
      --  Camera:setPosition(Camera.x+10, Camera.y)
    --end
end


function love.update(dt)
    GAME_MAP:update(dt)
    global_update(dt)


end

function love.resize(w,h)
    --push:resize(w,h)
end

function love.draw()

    GAME_MAP:draw() --Currently only ground level 
    player:draw()
    global_draw_overlay()

end