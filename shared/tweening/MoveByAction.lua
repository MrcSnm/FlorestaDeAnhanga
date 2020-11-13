MoveByAction = Class("MoveByAction", Action)

function MoveByAction:initialize(dur, x, y, sprite)
    self.initialX = 0
    self.initialY = 0
    
    local this = self
    Action.initialize(self, dur, function(progress)
        sprite.x = math.floor(this.initialX + x*progress)                        
        sprite.y = math.floor(this.initialY + y*progress)
    end)

    self.onStart = function()
        this.initialX = sprite.x
        this.initialY = sprite.y
    end

end