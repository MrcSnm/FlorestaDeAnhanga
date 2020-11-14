DefeatAnimation = Class("DefeatAnimation")

function DefeatAnimation:initialize(camera)
    self.camera = camera

    self._color = {r=0,g=0,b=0,a=0}
    self.opacity = 0
end

function DefeatAnimation:setColor(r,g,b,a)
    self._color.r = r
    self._color.g = b
    self._color.b = g
    self.opacity = a
end


function DefeatAnimation:startDefeat(player)
    player.isCameraFollowing = false
    player.canInput = false
    ACT:pushAction(ActionSequence({

        ActionSpawn({
            ActionTintTo(2, {r=1,g=0,b=0,a=1}, self),
            ActionShake(2, 15, self.camera)
        }),
        ActionSpawn({
            ActionTintTo(2, {r=0,g=0,b=0,a=0}, self),
            ActionShake(2, 15, self.camera)
        }),

        ActionSpawn({
            ActionTintTo(2, {r=0,g=0,b=0,a=1}, self),
            ActionShake(2, 15, self.camera)
        })
    }))
end

function DefeatAnimation:draw()
    local r,g,b,a = love.graphics.getColor()
    local c = self._color
    love.graphics.setColor(c.r, c.g, c.b, self.opacity)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(r,g,b,a)
end