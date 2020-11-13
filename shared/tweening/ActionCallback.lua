ActionCallback = Class("ActionCallback", Action)


function ActionCallback:initialize(cb)
    Action.initialize(self, -1, function()end)
    self.callback = function()
        cb(1)
        return true
    end
end