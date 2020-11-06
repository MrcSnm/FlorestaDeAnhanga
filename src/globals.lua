--Map Related
GAME_MAP = nil
GAME_MAP_NAME = "assets/maps/main_map.lua"
player = nil


LEVELS = {
    GROUND_LEVEL = 1,
    PLAYER_LEVEL = 2
}


--Config Related

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 544
VIRTUAL_HEIGHT = 320




-- Function calls

function global_init()
    global_StartTalkiesTheme()
    love.keyboard.keysPressed = {} 
    love.mouse.hasBeenPressed = false
    math.randomseed(os.time())

end

function global_StartTalkiesTheme()
    Talkies.optionCharacter = '>'
    Talkies.backgroundColor = {0, 0, 0, 0.6}

end

function global_update(dt)
    Talkies.update(dt)
end

function global_keypress(key)
    if key == "space" then Talkies.onAction()
    elseif key == "up" then Talkies.prevOption()
    elseif key == "down" then Talkies.nextOption()
    end
end


function global_draw_overlay()

    Talkies.draw()
end