require "src.libs"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    GAME_MAP = sti(GAME_MAP_NAME)

    CAMERA = Camera(0,0)
    player = Player(GAME_MAP, CAMERA)


    LIGHTING_SHADER = DayNightLightShader(CAMERA, GAME_MAP)
    GAME_MAP.layers["objects"].visible = false

    LIGHTING_SHADER:addLightSource(player.lightSource)
    CAMERA:zoom(2)

    global_init()

    player.x = player.x - love.graphics.getWidth() / 2
    player.y = player.y - love.graphics.getHeight() / 2
    print(player.x)

    
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
    GAME_MAP:update(dt)
    global_update(dt)


    if(love.keyboard.wasPressed("right")) then
        CAMERA:move(10, 0)
    elseif(love.keyboard.wasPressed("left")) then
        CAMERA:move(-10,0)
    end
    if(love.keyboard.wasPressed("up")) then
        CAMERA:move(0,-10)
    elseif(love.keyboard.wasPressed("down")) then
        CAMERA:move(0, 10)
    end
    player:update(dt)


end

function love.resize(w,h)
    --push:resize(w,h)
    
end

function love.draw()

    LIGHTING_SHADER:draw(function()

        --DAY_NIGHT_SHADER:draw(function()
           GAME_MAP:draw(-CAMERA.x, -CAMERA.y, CAMERA.scale, CAMERA.scale) --Currently only ground level 
           CAMERA:attach()
                player:draw()
           CAMERA:detach()
        --end)
    end)

    global_draw_overlay()

end