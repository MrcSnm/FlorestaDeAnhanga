Interface = Class("Interface", Sprite)

function Interface:initialize(timeContainer)

    Sprite.initialize(self)
    self.timeContainer = timeContainer
    self.currentTime = 0

    self.currentTexture = Assets.getSprite("clock.png")

    self.gameOverTime = 15
    self.secPerHour = 20
end


function Interface:updateClock(dt)
    self.currentTime = self.timeContainer.time
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

function Interface:setSecondsPerHour(secPerHour)

end

function Interface:draw()
    Sprite.draw(self)
    -- self:drawMin()
    self:drawHour()
end