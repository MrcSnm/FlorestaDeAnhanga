Animation = Class("Animation")

Animation.static.frame_config =
{
    name = "",
    speed = -1, -- -1 = defaultValue
    frames = {},
    texture = nil,
    --Callbacks
    onStart = nil,
    onFinish = nil
}



--Uses frame objects
function Animation:initialize(frames)
    --Privates
    self._time = 0
    self._pingPongDir = 1 -- It can be -1 for the current anim dir

    --Publics 
    self.anims = {}
    self.currentAnim = nil
    self.referenceTexture = nil
    self.defaultSpeed = 12
    self.frameNumber = 1

    self.isRunning = true
    self.isLooping = true
    self.isPingPong = false

    local isFramesList = frames[1][1] ~= nil

    if isFramesList then
        for _, v in ipairs(frames) do
            for __, v2 in ipairs(v) do
                self:addFrame(v2)
            end
        end
    else
        for _, v in ipairs(frames) do
            self:addFrame(v)
        end
    end
    
end

function Animation:setReferenceTexture(refTex)
    self.referenceTexture = refTex
end

function Animation:getCurrentFrame()
    return self.currentAnim.frames[self.frameNumber]
end

function Animation:addFrame(frame)
    assert(frame.name and frame.name ~= "", "Frame name must be different than null")
    assert(self.anims[frame.name] == nil, "Frame called '"..frame.name.."' already exists!")
    if frame.speed == nil or frame.speed == -1 then
        frame.speed = self.defaultSpeed
    end
    if self.currentAnim == nil then
        self.currentAnim = frame
    end
    self.anims[frame.name] = frame
end


--Ignore if same is defaullt
function Animation:play(animName, ignoreIfSame)
    if ignoreIfSame == nil then ignoreIfSame = true end
    if ignoreIfSame and self.currentAnim.name == animName then
        return
    end

    self:reset()
    self.currentAnim = self.anims[animName]
    self.isLooping = false
    self.isPingPong = false
    self.isRunning = true
end


function Animation:reset()
    self.isLooping = false
    self.isPingPong = false
    self.isRunning = false
    self._time = 0
    self.frameNumber = 1
    self._pingPongDir = 1
end

function Animation:loopPlay(animName, ignoreIfSame)
    self:play(animName, ignoreIfSame)
    self.isLooping = true
end
function Animation:pingPongPlay(animName, ignoreIfSame)
    self:play(animName, ignoreIfSame)
    self.isPingPong = true
    if restart then
        self._pingPongDir = 1
    end
end

function Animation:stop(restart)
    self.isRunning = false
    if(restart) then
        self:reset()
    end
end

function Animation:stringifyInfo()
    return "\nPingPongDir= "..tostring(self._pingPongDir).."\n"..
            "FrameNumber= "..tostring(self.frameNumber).."\n"..
            "IsLooping= "..tostring(self.isLooping).."\n"..
            "IsPingPong="..tostring(self.isPingPong).."\n"..
            "IsRunning="..tostring(self.isRunning).."\n"..
            "Time="..tostring(self._time).."\n"
end

function Animation:stopAtFrame(frameNumber)
    self:stop(true)
    assert(frameNumber >= 1, "Frame number is too small for animation '"..self.currentAnim.name.."'"..self:stringifyInfo())
    assert(frameNumber <= #self.currentAnim.frames, "Frame number is too great for animation '"..self.currentAnim.name.."'"..self:stringifyInfo())
    self.frameNumber = frameNumber
end

function Animation:update(dt)
    if(not self.isRunning) then
        return
    end

    self._time = self._time + dt
    local addThreshold = 1/self.currentAnim.speed

    if self._time >= addThreshold then
        local newFrameNum = self._pingPongDir + self.frameNumber

        if self.isPingPong then 
            if newFrameNum< 1 or newFrameNum > #self.currentAnim.frames then
                self._pingPongDir = self._pingPongDir * -1
                --Must add for not repeating the last frame 
                newFrameNum = newFrameNum + self._pingPongDir+self._pingPongDir
            end
        elseif newFrameNum > #self.currentAnim.frames then
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