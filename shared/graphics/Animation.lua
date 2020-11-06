AnimatedSprite = Class("AnimatedSprite")

AnimatedSprite.static.frame_config =
{
    name = "",
    speed = -1, -- -1 = defaultValue
    frames = {}
}



--Uses frame objects
function AnimatedSprite:initialize(frames)
    --Privates
    self._time = 0
    self._pingPongDir = 1 -- It can be -1 for the current anim dir

    --Publics 
    self.anims = {}
    self.currentAnim = nil
    self.defaultSpeed = 12
    self.frameNumber = 1

    self.isRunning = true
    self.isLooping = true
    self.isPingPong = false


    for _, v in ipairs(frames) do
        self:addFrame(v)
    end
end

function AnimatedSprite:addFrame(frame)
    assert(frame.name and frame.name ~= "", "Frame name must be different than null")
    assert(self.animes[frame.name] == nil, "Frame called '"..frame.name.."' already exists!")
    if frame.speed == nil or frame.speed == -1 then
        frame.speed = self.defaultSpeed
    end
    self.anims[frame.name] = frame
end


function AnimatedSprite:play(animName, restart)
    self.currentAnim = animName
    self.isLooping = false
    self.isPingPong = false

    if restart then
        self._time = 0
        self.frameNumber = 1
    end
end

function AnimatedSprite:loopPlay(animName, restart)
    self:play(animName, restart)
    self.isLooping = true
end
function AnimatedSprite:pingPongPlay(animName, restart)
    self:play(animName, restart)
    self.isPingPong = true
    if restart then
        self._pingPongDir = 1
    end
end

function AnimatedSprite:stop(restart)
    self.isRunning = false
    if(restart) then
        self._time = 0
    end
end

function AnimatedSprite:update(dt)
    if(not self.isRunning) then
        return
    end

    self._time = self._time + dt
    local addThreshold = 1/self.currentAnim[self.frameNumber].speed

    if self._time >= addThreshold then
        local newFrameNum = self._pingPongDir + self.frame

        if self.isPingPong then
            if newFrameNum< 1 or newFrameNum > #self.currentAnim[self.frameNumber].frames then
                self._pingPongDir = self._pingPongDir * -1
                newFrameNum = newFrameNum + self._pingPongDir
            end
        elseif newFrameNum > #self.currentAnim[self.frameNumber].frames then
            if self.isLooping then
                newFrameNum = 1
            else
                self.isRunning = false
                newFrameNum = self.frameNumber
            end
        end
        self.frameNumber = newFrameNum
        self._time = 0
    end
     
end