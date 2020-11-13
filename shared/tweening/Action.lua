Action = Class"Action"

function Action:initialize(duration, callback)

    self.currentTime = 0
    self.duration = duration
    self.hasFinished = false
    local this = self
    self.callback = function(progress)
        callback(progress)
        this.hasFinished = progress >= 1
        return this.hasFinished
    end

    self.onStart = function()end
    self.onFinish = function()end
end

function Action:update(dt)
    self.currentTime = self.currentTime + dt
    return self.callback(self.currentTime/self.duration)
end