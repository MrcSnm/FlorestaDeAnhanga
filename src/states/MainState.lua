MainState = Class("MainState", State)

local defeatAnimation
function MainState:enter()
    WORLD = bump.newWorld()
    GAME_MAP = sti(GAME_MAP_NAME, {"bump"})
    CAVE = STI_Object(GAME_MAP, "Cave")
    GAME_MAP:bump_init(WORLD)

    CAMERA = Camera(0,0)
    player = Player(GAME_MAP, CAMERA)
    player.x = player.x - love.graphics.getWidth() / 2
    player.y = player.y - love.graphics.getHeight() / 2

    CAMERA:lookAt(player.x, player.y)

    LIGHTING_SHADER = DayNightLightShader(CAMERA, GAME_MAP)
    defeatAnimation = DefeatAnimation(CAMERA)
    CLOCK_INTERFACE = Interface(LIGHTING_SHADER.daynight, defeatAnimation, player)



    ANIMAL_SPAWNER = AnimalSpawner(GAME_MAP, CLOCK_INTERFACE)
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

    global_pushTimedSpeech(CLOCK_INTERFACE, player)
    global_pushAchievements(CLOCK_INTERFACE)


end

function MainState:update(dt)
    GAME_MAP:update(dt)


    if(love.keyboard.wasPressed("right")) then
        if(CAMERA.x+10 < GAME_MAP.width * GAME_MAP.tilewidth) then
            CAMERA:move(10, 0)
        end
    elseif(love.keyboard.wasPressed("left")) then
        if(CAMERA.x > 10) then
            CAMERA:move(-10,0)
        end
    end
    if(love.keyboard.wasPressed("up")) then
        if(CAMERA.y > 10) then
            CAMERA:move(0,-10)
        end
    elseif(love.keyboard.wasPressed("down")) then
        if(CAMERA.y+10 < GAME_MAP.height * GAME_MAP.tileheight) then
            CAMERA:move(0, 10)
        end
    end
    player:update(dt)
    ANIMAL_SPAWNER:update(dt)


    --1*dt = 1 second = 1 hour
    --(1*dt /60) = 1 minute = 1 hour
    -- LIGHTING_SHADER.daynight.time = LIGHTING_SHADER.daynight.time + (1*dt/60)*5

    --Game over at time = 15
    if not Talkies.isOpen() then
        LIGHTING_SHADER.daynight.time = LIGHTING_SHADER.daynight.time + (1*dt/20)
    end
    CLOCK_INTERFACE:update(dt)

    if player.canInput then
        if love.keyboard.wasPressed("return") then
            player:interaction(ANIMAL_SPAWNER)
        end
    end
end

function MainState:render()
    love.graphics.clear()
    LIGHTING_SHADER:draw(function()
        GAME_MAP:draw(-CAMERA.x, -CAMERA.y, CAMERA.scale, CAMERA.scale) --Currently only ground level 
        CAMERA:attach()
            player:draw()
            ANIMAL_SPAWNER:draw()
        CAMERA:detach()

        hump_x_sti_renderTopLayers(GAME_MAP_TOP_LAYERS, GAME_MAP, CAMERA)
    end)
        -- hump_x_sti_showCamBounds(CAMERA, GAME_MAP)

    CLOCK_INTERFACE:draw()
end