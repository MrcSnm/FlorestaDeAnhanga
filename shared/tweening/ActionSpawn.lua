ActionSpawn = Class("ActionSpawn", Action)

function ActionSpawn:initialize(actList)
    local dur = 0
    for i, v in ipairs(actList) do
        dur = math.max(dur, v.duration)
    end
    self.actions = actList
    self.totalFinished = 0
    Action.initialize(self, dur, function()end) --Ignore callback
end


function ActionSpawn:update(dt)

    for i, act in ipairs(self.actions) do
        if act.currentTime == 0 then
            act.onStart()
        end
        if not act.hasFinished then
            if act:update(dt) then
                act.onFinish()
                self.totalFinished = self.totalFinished + 1
            end
        end
    end

    return self.totalFinished > #self.actions
end