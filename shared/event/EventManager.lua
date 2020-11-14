EventManager = Class("EventManager")

function EventManager:initialize()
    self.events = {}
end

function EventManager:pushEvent(ev)
    table.insert(self.events, ev)
end

function EventManager:poll(dt)
    local i = 1

    while i <= #self.events do
        self.events[i].elapsed = self.events[i].elapsed+dt
        if self.events[i].condition(self.events[i].elapsed) then
            self.events[i].onTrue(self.events[i].elapsed)
            table.remove(self.events, i)
            i = i - 1
        end
        i = i + 1
    end
end