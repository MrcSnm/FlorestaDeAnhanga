Interface = Class("Interface", Sprite)

function Interface:initialize(timeContainer)

    Sprite.initialize(self)
    self.timeContainer = timeContainer
    self.currentTime = 0

    self.currentTexture = Assets.getSprite("clock.png")
    self.setScale(0.5)
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

    love.graphics.line(x, y, self.currentTime*)
end
function Interface:drawHour()
    local hourSize = self.currentTexture:getWidth()/3

end

function Interface:draw()
    Sprite.draw(self)
    self:drawMin()
    self:drawHour()
end