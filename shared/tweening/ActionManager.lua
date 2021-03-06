ActionManager = Class("ActionManager")


function ActionManager:initialize()

    self.actions = {}
    self.currentActionIndex = 1
    self.isActive = true
end

function ActionManager:pushAction(act)
    table.insert(self.actions, act) 
end

function ActionManager:update(dt)

    local i = 1

    while i <= #self.actions do
        if self.actions[i].currentTime == 0 then
            self.actions[i]:onStart()
        end
        if self.actions[i]:update(dt) then
            self.actions[i]:onFinish()
            table.remove(self.actions, i)
            i = i - 1
        end
        i = i + 1
    end
end
