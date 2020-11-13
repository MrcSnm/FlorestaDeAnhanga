ActionTintBy = Class("ActionTintBy", Action)

function ActionTintBy:initialize(dur, targetColor, target)
    self.lastR = 0
    self.lastG = 0
    self.lastB = 0
    self.lastA = 0

    local this = self
    Action.initialize(self, dur, function(progress)

        target.setColor(target._color.r-this.lastR,
                        target._color.g-this.lastG,
                        target._color.b-this.lastB,
                        target.opacity - this.lastA)
        
        this.lastR = progress*targetColor.r
        this.lastG = progress*targetColor.g
        this.lastB = progress*targetColor.b
        this.lastA = progress*targetColor.a

        target.setColor(target._color.r+this.lastR,
                        target._color.g+this.lastG,
                        target._color.b+this.lastB,
                        target.opacity + this.lastA)
    end)
end

function ActionTintTo(dur, targetColor, target)
    local nColor = 
    {
        r = targetColor.r - target._color.r,
        g = targetColor.g - target._color.g,
        b = targetColor.b - target._color.b,
        a = targetColor.a - target._color.a
    }
    return ActionTintBy(dur, nColor, target)
end