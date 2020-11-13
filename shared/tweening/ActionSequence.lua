ActionSequence = Class("ActionSequence", Action)

function ActionSequence:initialize(actList)
    local dur = 0
    for i, v in ipairs(actList) do
        dur = dur + v.duration
    end
    self.actions = actList
    self.currentActionIndex = 1
    Action.initialize(self, dur, function()end) --Ignore callback
end


function ActionSequence:update(dt)

    if self.currentActionIndex > #self.actions then
        return true
    end
    if self.actions[self.currentActionIndex].currentTime == 0 then
        self.actions[self.currentActionIndex].onStart()
    end
    if self.actions[self.currentActionIndex]:update(dt) then
        self.actions[self.currentActionIndex].onFinish()
        self.currentActionIndex = self.currentActionIndex + 1
    end

    return self.currentActionIndex > #self.actions
end