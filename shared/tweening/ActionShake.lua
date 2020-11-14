ActionShake = Class("ActionShake", Action)

function ActionShake:initialize(dur, power, target)
    self.initialX = 0
    self.initialY = 0
    local this = self
    Action.initialize(self, dur, function (progress)
        target.x = this.initialX + math.random(-power, power)
        target.y = this.initialY + math.random(-power, power)
    end)

    self.onStart = function ()
        this.initialX = target.x
        this.initialY = target.y
    end

    self.onFinish = function()
        target.x = this.initialX
        target.y = this.initialY
    end
end