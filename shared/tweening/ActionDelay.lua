ActionDelay = Class("ActionDelay", Action)

function ActionDelay:initialize(dur)
    Action.initialize(self, dur, function()end)
end