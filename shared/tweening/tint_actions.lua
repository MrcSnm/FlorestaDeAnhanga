ActionTintBy = Class("ActionTintBy", Action)

function ActionTintBy:initialize(dur, targetColor, target)
    self.lastR = 0
    self.lastG = 0
    self.lastB = 0
    self.lastA = 0

    local this = self
    Action.initialize(self, dur, function(progress)

        target:setColor(target._color.r-this.lastR,
                        target._color.g-this.lastG,
                        target._color.b-this.lastB,
                        target.opacity - this.lastA)
        
        this.lastR = progress*targetColor.r
        this.lastG = progress*targetColor.g
        this.lastB = progress*targetColor.b
        this.lastA = progress*targetColor.a

        target:setColor(target._color.r+this.lastR,
                        target._color.g+this.lastG,
                        target._color.b+this.lastB,
                        target.opacity + this.lastA)
    end)
end

--- Target must implement function setColor, and it must have _color which must have the parameters r,g,b
-- And .opacity
ActionTintTo = Class("ActionTintTo", Action)


function ActionTintTo:initialize(dur, targetColor, target)

    self.initialR = 0
    self.initialG = 0
    self.initialB = 0
    self.initialA = 0

    local this = self
    Action.initialize(self, dur, function(progress)

        target:setColor((1-progress)*self.initialR+(targetColor.r*progress),
                        (1-progress)*self.initialG+(targetColor.g*progress),
                        (1-progress)*self.initialB+(targetColor.b*progress),
                        (1-progress)*self.initialA+(targetColor.a*progress))
    end)

    self.onStart = function()
        this.initialR = target._color.r
        this.initialG = target._color.g
        this.initialB = target._color.b
        this.initialA = target.opacity
    end

end