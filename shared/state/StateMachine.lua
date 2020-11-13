StateMachine = Class"StateMachine"


function StateMachine:initialize(states)
    self.empty =
    {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.currentState = self.empty
    self.scheduledState = nil
end

function StateMachine:change(state, enterParams)
    assert(self.states[state] ~= nil, "State '" .. state .. "' must exist")
    self.currentState:exit()
    love.keyboard.keysPressed = {}
    self.currentState = self.states[state]()
    self.currentState:enter(enterParams)
end

function StateMachine:prepareChange(state, enterParams)
    assert(self.states[state] ~= nil, "State '" .. state .. "' must exist")

    self.scheduledState = self.states[state]()
    self.scheduledState:enter(enterParams)
end

function StateMachine:enterScheduled()
    self.currentState = self.scheduledState
    self.scheduledState = nil
end

function StateMachine:update(dt)
    self.currentState:update(dt)
end

function StateMachine:render()
    self.currentState:render()
end