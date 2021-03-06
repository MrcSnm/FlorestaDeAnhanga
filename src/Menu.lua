Menu = Class("Menu")

local CHOICES =
{
    INICIAR = 1,
    SAIR = 2
}

function Menu:initialize(currentMusic)

    self.mainSprite = Sprite()
    self.mainSprite.currentTexture = Assets.getSprite("Titulor.png")

    self.mainSprite:setScale(love.graphics.getWidth()/800, love.graphics.getHeight()/600)

    self.options = {}
    self.currentSelected = CHOICES.INICIAR

    self.iniciar = Sprite()
    self.sair = Sprite()
    
    self.sair.currentTexture = Assets.getSprite("sair.png")
    self.sair.x = love.graphics.getWidth()-self.sair.currentTexture:getWidth() - 100
    self.sair.y = love.graphics.getHeight()- 150

    

    self.iniciar.currentTexture = Assets.getSprite("iniciar.png")
    self.iniciar.x = 100
    self.iniciar.y = love.graphics.getHeight()- 150
    self.currentMusic = currentMusic
    self:alternateChoice(self.currentSelected)

end


function Menu:alternateChoice(choice)
    if choice == CHOICES.INICIAR then
        self.iniciar.currentTexture = Assets.getSprite("iniciarselecionado.png")
        self.sair.currentTexture = Assets.getSprite("sair.png")
    else
        self.iniciar.currentTexture = Assets.getSprite("iniciar.png")
        self.sair.currentTexture = Assets.getSprite("sairselecionado.png")
    end
end

function Menu:checkSelected()
    if love.keyboard.wasJustPressed("left") or love.keyboard.wasJustPressed("right") then
        self.currentSelected = self.currentSelected % 2 + 1
        self:alternateChoice(self.currentSelected)
        Assets.getSfx("select.wav"):play()
    elseif love.keyboard.wasJustPressed("return") then
        Assets.getSfx("confirm.wav"):play()
        if self.currentSelected == CHOICES.INICIAR then
            self.currentMusic:stop()
            IS_ON_MENU = false
            gStateMachine:change("main")
        else
            ACT:pushAction(ActionSequence({
                ActionDelay(0.5),
                ActionCallback(love.event.quit)
            }))
        end
    end
end

function Menu:update(dt)
    self:checkSelected()
    
end


function Menu:draw()

    self.mainSprite:draw()
    self.sair:draw()
    self.iniciar:draw()
end