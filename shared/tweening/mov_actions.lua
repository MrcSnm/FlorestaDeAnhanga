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


MoveToAction = Class("MoveToAction", Action)

function MoveToAction:initialize(dur, x, y, target)

    self.initialX = 0
    self.initialY = 0

    local this = self
    Action.initialize(self, dur, function(progress)

        target.x = (1-progress)*this.initialX   +(x*progress)
        target.y = (1-progress)*this.initialY +(y*progress)
    end)

    self.onStart = function()
        this.initialX = target.x
        this.initialY = target.y
    end

end