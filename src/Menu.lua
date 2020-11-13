Menu = Class("Menu")

local CHOICES =
{
    INICIAR = 1,
    SAIR = 2
}

function Menu:initialize()

    self.mainSprite = Sprite()
    self.mainSprite.currentTexture = Assets.getSprite("Titulor.png")

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