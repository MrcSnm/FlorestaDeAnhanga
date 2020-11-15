MenuState = Class("MenuState", State)

local menu 
local mainMusic
local isFading = false
function MenuState:enter()
    IS_ON_MENU = true
    mainMusic = Assets.getMusic("ice_wastes.mp3")
    mainMusic:setLooping(true)
    mainMusic:play()
    menu = Menu(mainMusic)
    FADER:setColor(0,0,0,1)
    Assets.getSfx("thunder1.ogg"):play()

    isFading = true
    ACT:pushAction(ActionSequence({
        ActionTintTo(0.1, {r=1, g=0, b=0, a=1}, FADER),
        ActionTintTo(1, {r=0, g=0, b=0, a=0}, FADER),
        ActionCallback(function ()
            isFading = false
        end)
    }))
    -- FADER:fadeTo(1, 0, 0, 0, 0)
end

function MenuState:update(dt)
    if not isFading then
        menu:update(dt)
    end
end

function MenuState:render()
    menu:draw()
end