require "src.libs"

function love.load()
    global_init()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    WORLD = bump.newWorld()
    GAME_MAP = sti(GAME_MAP_NAME, {"bump"})
    CAVE = STI_Object(GAME_MAP, "Cave")
    GAME_MAP:bump_init(WORLD)

    CAMERA = Camera(0,0)
    player = Player(GAME_MAP, CAMERA)
    player.x = player.x - love.graphics.getWidth() / 2
    player.y = player.y - love.graphics.getHeight() / 2


    LIGHTING_SHADER = DayNightLightShader(CAMERA, GAME_MAP)
    ANIMAL_SPAWNER = AnimalSpawner(GAME_MAP)
    GAME_MAP.layers["objects"].visible = false
    GAME_MAP.layers["spawns"].visible = false

    GAME_MAP_TOP_LAYERS = {}
    COLLISION_LAYERS = getCollisionLayers(GAME_MAP, {"holes", "trees", "holes2", "water"})
    table.insert(GAME_MAP_TOP_LAYERS, separateLayer(GAME_MAP, "trees_top"))
    table.insert(GAME_MAP_TOP_LAYERS, separateLayer(GAME_MAP, "trees2"))

    LIGHTING_SHADER:addLightSource(player.lightSource)


    AMBIENCE = Assets.getMusic("Forest_Ambience.mp3")
    NATURE = Assets.getMusic("grip of nature.ogg")
    NATURE:setLooping(true)
    NATURE:setVolume(0.2)
    NATURE:play()
    AMBIENCE:setLooping(true)
    AMBIENCE:play()

    CAMERA:zoom(2)

    ACT:pushAction(ActionSequence({
        ActionDelay(0.5),
        ActionCallback(function()
        global_InitialSpeech(player)
        end)
    }))


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
    if player.canInput then
        if key == "return" then
            player:interaction(ANIMAL_SPAWNER)
        end
    end
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
    ANIMAL_SPAWNER:update(dt)
end


function love.resize(w,h)
    --push:resize(w,h)
    
end

function love.draw()

    LIGHTING_SHADER:draw(function()
        GAME_MAP:draw(-CAMERA.x, -CAMERA.y, CAMERA.scale, CAMERA.scale) --Currently only ground level 
        CAMERA:attach()
            player:draw()
            ANIMAL_SPAWNER:draw()
        CAMERA:detach()

        hump_x_sti_renderTopLayers(GAME_MAP_TOP_LAYERS, GAME_MAP, CAMERA)
    end)
        -- hump_x_sti_showCamBounds(CAMERA, GAME_MAP)

    global_draw_overlay()

end