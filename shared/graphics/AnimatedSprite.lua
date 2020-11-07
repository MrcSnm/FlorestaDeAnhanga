AnimatedSprite = Class("AnimatedSprite", Sprite)


function AnimatedSprite:initialize(frames)
    Sprite.initialize(self)
    self.anim = Animation(frames)
end
--Sets the frame too
function AnimatedSprite:update(dt)
    self.anim:update(dt)

    self.currentQuad = self.anim:getCurrentFrame()
    self.currentTexture = self.anim.currentAnim.texture
end
function AnimatedSprite:stop(restart)
    self.anim:stop(restart)
end
function AnimatedSprite:stopAtFrame(frameNum)
    self.anim:stopAtFrame(frameNum)
end
function AnimatedSprite:pingPongPlay(animName, restart)
    self.anim:pingPongPlay(animName, restart)
end
function AnimatedSprite:loopPlay(animName, restart)
    self.anim:loopPlay(animName, restart)
end
function AnimatedSprite:play(animName, restart)
    self.anim:play(animName, restart)
end
function AnimatedSprite:addFrame(frame)
    self.anim:addFrame(frame)
end
