---This class must be part of the global overlay
Fader = Class("Fader") 

function Fader:initialize()

    self._color = {r = 0, g=0,b=0,a=0}
    self.opacity = 0
end

function Fader:setColor(r,g,b,a)
    self._color.r = r
    self._color.g = g
    self._color.b = b
    self.opacity = a
end

function Fader:fadeTo(dur, r,g,b,a)
    ACT:pushAction(ActionTintTo(dur, {r=r, g=g, b=b, a=a}, self))
end


function Fader:draw()
    local r,g,b,a = love.graphics.getColor()
    local c = self._color
    love.graphics.setColor(c.r, c.g, c.b, self.opacity)
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(r,g,b,a)
end