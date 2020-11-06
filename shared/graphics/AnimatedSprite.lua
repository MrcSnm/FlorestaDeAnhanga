AnimatedSprite = Class("AnimatedSprite", Sprite)


function AnimatedSprite:initialize(frames)
    Sprite.initialize()
    self.anim = Animation(frames)
end
--Sets the frame too
function AnimatedSprite:update(dt)
    self.anim:update(dt) 

    local frame = self:getCurrentFrame()
    self.currentTexture = self.currentAnim.texture
end
function AnimatedSprite:stop(restart)
    self.anim:stop(restart)
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
