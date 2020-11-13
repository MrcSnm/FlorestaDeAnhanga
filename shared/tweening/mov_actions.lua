MoveByAction = Class("MoveByAction", Action)

function MoveByAction:initialize(dur, x, y, sprite)
    self.lastX = 0
    self.lastY = 0
    
    local this = self
    Action.initialize(self, dur, function(progress)
        sprite.x = sprite.x - this.lastX
        sprite.y = sprite.y - this.lastY

        this.lastX = math.floor(progress*x)
        this.lastY = math.floor(progress*y)

        sprite.x = sprite.x + this.lastX
        sprite.y = sprite.y + this.lastY
    end)
end

function MoveToAction(dur, x, y, sprite)
    return MoveByAction(dur, x-sprite.x, y-sprite.y, sprite)
end