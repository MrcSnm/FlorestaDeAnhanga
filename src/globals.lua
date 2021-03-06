--Map Related
GAME_MAP = nil
GAME_MAP_NAME = "assets/maps/main_map.lua"
IS_ON_MENU = false

CAVE =  nil
player = nil

FADER = nil
ANIMALS_SAVED = 0
GAME_INTERFACE_FONT = Assets.getFont("manaspc.ttf", 32)
TALKIES_FONT = Assets.getFont("manaspc.ttf", 24)


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

TIMED_SPEECH =
{
    {5, "Boa parte desta noite esgotou, devo me apressar..."},
    {10, "A abertura da madrugada...-- A pressa se instaura..."},
    {14, "Sinto que o fim se aproxima, o que eu deveria fazer?"},
    {15, "Este foi o melhor que pude fazer de verdade? Talvez, este seja o limite, o amanhecer do fim..."}
}

SAVE_SPEECH =
{
    {5, "Aos poucos, sinto que minha ajuda se torna importante..."},
    {15, "Estes poucos se tornam nosso futuro."},
    {25, "Nossa sorte se encontra na profundidade da caverna."},
    {50, "Um grande feito para o melhor da natureza."},
    {75, "O que? Mas como? Isto deveria ser irreal."},
    {100, "Todos os animais foram salvos... Mas a que custo? Agora apenas me resta apenas esperar o fim de tudo."}
}

function global_pushTimedSpeech(clock, player)

    for i,  v in ipairs(TIMED_SPEECH) do
        gEventManager:pushEvent(Event("Aviso"..tostring(i), function ()
            return clock.currentTime >= TIMED_SPEECH[i][1]
        end, function ()
            player:think(TIMED_SPEECH[i][2])
        end))
    end
end
function global_pushAchievements(animals)
    for i,  v in ipairs(SAVE_SPEECH) do
        gEventManager:pushEvent(Event("Conquista"..tostring(i), function ()
            return animals:getAnimalsSavedCount() >= v[1]
        end, function ()
            player:think(v[2])
        end))
    end
end

function global_Tutorial()
    Talkies.say("", [[
        Teclas:
        W > Mover para cima
        A > Mover para esquerda
        S > Mover para baixo
        D > Mover para direita
        Enter > Interagir com animais e com a caverna
        ESC > Pausar/sair
    ]])
    Talkies.say("", [[
        Traga a maior quantia de animais para a caverna enquanto o amanhecer for o futuro
    ]], {oncomplete = function ()
        ACT:pushAction(ActionSequence({
            ActionTintTo(0.5, {r=0,g=0,b=0,a=0}, FADER),
            ActionCallback(function ()
                global_InitialSpeech(player)
            end)
        }))
    end})
end

function global_InitialSpeech(anhanga)

    anhanga:disableInput()
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
    love.keyboard.keysJustPressed = {} 
    love.mouse.hasBeenPressed = false
    math.randomseed(os.time())
    ACT = ActionManager()

    FADER = Fader()

end

function global_StartTalkiesTheme()
    Talkies.optionCharacter = '>'
    Talkies.backgroundColor = {0, 0, 0, 0.6}
    Talkies.font = TALKIES_FONT
    Talkies.padding = 40

end

function global_update(dt)
    Talkies.update(dt)
    ACT:update(dt)

    love.keyboard.keysJustPressed = {}
end

function global_keypress(key)
    love.keyboard.keysPressed[key] = true
    love.keyboard.keysJustPressed[key] = true
    if key == "return" then Talkies.onAction()
    elseif key == "up" then Talkies.prevOption()
    elseif key == "down" then Talkies.nextOption()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] == true
end

function love.keyboard.wasJustPressed(key)
    if love.keyboard.keysJustPressed[key] then
        return true
    else
        return false
    end
end


function global_keyup(key)
    love.keyboard.keysPressed[key] = false
end


function global_draw_overlay()
    FADER:draw()
    Talkies.draw()
end
