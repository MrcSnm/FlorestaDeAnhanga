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

    for i = 1, #self.actions do
        if self.actions[i]:update(dt) then
            table.remove(self.actions, i)
            i = i - 1
        end
    end
end
