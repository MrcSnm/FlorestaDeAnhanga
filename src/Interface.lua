Interface = Class("Interface", Sprite)

function Interface:initialize(timeContainer, defeatAnimation, player)

    Sprite.initialize(self)
    self.timeContainer = timeContainer
    self.currentTime = 0
    self.animalsSaved = {}

    self.currentTexture = Assets.getSprite("clock.png")

    self.animalSprite = Sprite()
    local texture = Assets.getSprite("pintinho.png")
    self.animalSprite.currentTexture = texture
    self.animalSprite:setQuad(love.graphics.newQuad(texture:getWidth()-32*2, 0,32,32, texture:getDimensions())) --Pintinho branco parado
    self.animalSprite:setScale(2)

    self.animalSprite:setPosition(love.graphics.getWidth() - 250, -20)

    self.gameOverTime = 15
    self.secPerHour = 20
    self.maxAnimals = 0
    self.defeatAnimation = defeatAnimation
    self.player = player
    self.hasStartedDefeat = false
end


function Interface:addAnimal(animalType)
    if self.animalsSaved[animalType.animalType] == nil then
        self.animalsSaved[animalType.animalType] = 0
    end
    self.animalsSaved[animalType.animalType] = self.animalsSaved[animalType.animalType]+1
end


function Interface:updateClock(dt)
    if self.hasStartedDefeat then
        return
    end
    self.currentTime = self.timeContainer.time
    -- self.currentTime = 15

    if self.currentTime >= 15 then
        self.defeatAnimation:startDefeat(self.player)
        self.hasStartedDefeat = true
    end
end


function Interface:update(dt)
    self:updateClock()
end


function Interface:drawMin()
    local minSize = self.currentTexture:getWidth()/2
    local x = self.currentTexture:getWidth()/2
    local y = self.currentTexture:getHeight()/2
    
    --time = 0, -math.pi/2
    --time = 3, 0
    --time = 6, math.pi/2
    --time = 9, math.pi
    local normalTime = ((self.currentTime*60)%12)

    --If 0, point up
    local angle = -math.pi/2 + ((normalTime/3)*math.pi/2)
    
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0.6, 0, 1)
    love.graphics.line(x, y, x+minSize*math.cos(angle), y+minSize*math.sin(angle))
    love.graphics.setColor(r,g,b,a)
end

function Interface:drawHour()
    local hourSize = self.currentTexture:getWidth()/3

    local x = self.currentTexture:getWidth()/2
    local y = self.currentTexture:getHeight()/2


    --time = 0, -math.pi/2
    --time = 3, 0
    --time = 6, math.pi/2
    --time = 9, math.pi
    local normalTime = (self.currentTime%12)

    --If 0, point up
    local angle = -math.pi/2 + ((normalTime/3)*math.pi/2)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.line(x, y, x+hourSize *math.cos(angle), y+hourSize*math.sin(angle))

    love.graphics.setColor(r,g,b,a)

end

function Interface:setGameOverTime(gameOverTime)
    self.gameOverTime = gameOverTime
end

function Interface:setMaxAnimals(maxAnimals)
    self.maxAnimals = maxAnimals
end

function Interface:getAnimalsSavedCount()
    local ret = 0
    for k, v in pairs(self.animalsSaved) do
        ret = ret + v
    end
    return ret
end

function Interface:setSecondsPerHour(secPerHour)

end

function Interface:draw()
    Sprite.draw(self)
    -- self:drawMin()
    self:drawHour()
    self.animalSprite:draw()
    love.graphics.setFont(GAME_INTERFACE_FONT)
    love.graphics.print(tostring(self:getAnimalsSavedCount()).."/"..tostring(self.maxAnimals),
                        self.animalSprite.x + self.animalSprite:getWidth()*1.5, 15)
    self.defeatAnimation:draw()
end