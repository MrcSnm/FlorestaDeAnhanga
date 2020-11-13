--Map Related
GAME_MAP = nil
GAME_MAP_NAME = "assets/maps/main_map.lua"

CAVE =  nil
player = nil


SPEECH = 
{
    {"Sinto que este local aos poucos se torna mais quente."},
    {"Acho que deveria me preparar para o pior..."},
    {"Vou tentar levar meus companheiros para um local seguro."},
    {"Acredito que esta caverna ao lado possa ser interessante."},
    {"Talvez seja uma boa ideia."},
    {"Devo tentar meu melhor para ajudar contra este clima..."}, --6
    {".--.--."}, --7
    {"Acredito que meu tempo se limite a esta noite."}, --8
    {"Devo terminar antes do amanhecer, sinto uma onda intensa chegando"} --9
}

function global_InitialSpeech(anhanga)

    anhanga.canInput = false
    anhanga:think(SPEECH[1][1])
    anhanga:think(SPEECH[2][1])
    anhanga:say  (SPEECH[3][1])
    anhanga:say  (SPEECH[4][1])
    anhanga:think(SPEECH[5][1])
    anhanga:say(SPEECH[6][1])
    anhanga:think(SPEECH[7][1])
    anhanga:think(SPEECH[8][1])
    anhanga:say (SPEECH[9][1], function()
        anhanga.canInput = true
    end)
end


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
    ACT = ActionManager()



end

function global_StartTalkiesTheme()
    Talkies.optionCharacter = '>'
    Talkies.backgroundColor = {0, 0, 0, 0.6}

end

function global_update(dt)
    Talkies.update(dt)
    ACT:update(dt)
end

function global_keypress(key)
    love.keyboard.keysPressed[key] = true
    if key == "return" then Talkies.onAction()
    elseif key == "up" then Talkies.prevOption()
    elseif key == "down" then Talkies.nextOption()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] == true
end

function global_keyup(key)
    love.keyboard.keysPressed[key] = false
end


function global_draw_overlay()

    Talkies.draw()
end
