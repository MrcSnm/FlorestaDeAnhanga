Event = Class("Event")

function Event:initialize(name, condition, onTrue)
    self.name = name
    self.elapsed = 0
    self.condition = condition
    self.onTrue = onTrue
end