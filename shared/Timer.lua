Timer = Class("Timer")

Timer.static.ONE_SHOT = 1
Timer.static.LOOP = 2

--Loop has an optional parameter of current progress
function Timer:initialize(timerType, countdown, callback, endFunc)
    self.timerType = timerType
    self.countdown = countdown or 0

    self.currentTime = 0
    self.callback = callback
    self.isActive = (callback ~= nil) and true or false

    self.endFunc = nil
    self.isLooping = false
    if endFunc ~= nil then
        self:loopOneshot(countdown, callback, endFunc)
    end

end


function Timer:loopOneshot(countdown, callback, endFunc)
    self:restart(Timer.ONE_SHOT, countdown, callback)
    self.endFunc = endFunc
    self.isLooping = true
end

function Timer:restart(timerType, countdown, callback)
    self.timerType = timerType
    self.currentTime = 0
    self.countdown = countdown or 0
    self.callback = callback
    self.isLooping = false
    self.isActive = (callback ~= nil) and true or false
end

function Timer:pause()
    self.isActive = false
end

function Timer:setActive()
    self.isActive = true
end

function Timer:stop()
    self.isActive = false
    self.countdown = -1
    self.currentTime = 0
    self.callback = nil
end

function Timer:_execute()
    if self.timerType == Timer.LOOP then
        self.callback(self.currentTime / self.countdown, self)
    end

    if self.currentTime >= self.countdown then
        if self.timerType == Timer.ONE_SHOT then
            self.callback(self.currentTime / self.countdown, self)
        end
        if self.isLooping then
            if self.endFunc() then
                self.isLooping = false
            else
                self:loopOneshot(self.countdown, self.callback, self.endFunc)
            end
        else
            self:stop()
        end
    end
end

function Timer:update(dt)
    if self.isActive then
        self:_execute()
        self.currentTime = self.currentTime + dt
    end

end