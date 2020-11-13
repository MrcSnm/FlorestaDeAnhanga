MoveByAction = Class("MoveByAction", Action)

function MoveByAction:initialize(dur, x, y, sprite)
    self.initialX = sprite.x
    self.initialY = sprite.y
    
    local this = self
    Action.initialize(self, dur, function(progress)
        sprite.x = math.floor(this.initialX + x*progress)
        sprite.y = math.floor(this.initialY + y*progress)
    end)

end