Player = Class("Player", STI_AnimatedSpriteObject)

function Player:initialize(map, camera)
    self.deerSpriteCommon = generateSpritesheetSized(Assets.getSprite("Anhangua.png"), 32, 32,
    32*3, 32*4, 0,0)

    self.deerSpriteIdle = generateSpritesheetSized(Assets.getSprite("Anhangua.png"), 32, 32,
    32, 32*4, 32*3,0)

    self.humanSprite = generateSpritesheet(Assets.getSprite("Anhangua_Human.png"), 4, 3)

    STI_AnimatedSpriteObject.initialize(self, map,  "Player",
    {
        spritesheetToFrames_RPGMaker(self.deerSpriteCommon, 3, {"deer_up", "deer_right", "deer_down", "deer_left"}, 12),
        spritesheetToFrames_RPGMaker(self.humanSprite, 3, {"human_down", "human_left", "human_right", "human_up"}, 12),
        spritesheetToFrames_RPGMaker(self.deerSpriteIdle, 1, {"deer_up_i", "deer_right_i", "deer_down_i", "deer_left_i"}, 12),
    })

    self.speed = 250
    self.isDeer = true
    self.isStill = true
    self.isCameraFollowing = true
    self:loopPlay("deer_down")

    self.transformCooldown = 1
    self.currentCooldown = 0

    self.currentMovement = "down"
    self.camera = camera


    camera.smoother = Camera.smooth.damped(5)
    camera:lookAt(self.x, self.y)

    self.lightSource = {
        position = {self.x, self.y},
        diffuse = {1,1,1, 1},
        power = 100,
        falloff = 1,
        minThreshold = 1, --If lesser, color = power
        maxThreshold = 3000 --If higher, color = 0
    }


end

function Player:input(dt)
    local moveX = 0
    local moveY = 0

    if love.keyboard.wasPressed("w") then
        moveY = -self.speed
        self.currentMovement = "up"
    elseif love.keyboard.wasPressed("s") then
        moveY = self.speed
        self.currentMovement = "down"
    elseif love.keyboard.wasPressed("a") then
        moveX = -self.speed
        self.currentMovement = "left"
    elseif love.keyboard.wasPressed("d") then
        moveX = self.speed
        self.currentMovement = "right"
    end

    if love.keyboard.wasPressed("up") then
        self.lightSource.power = self.lightSource.power + 0.01
    elseif love.keyboard.wasPressed("down") then
        self.lightSource.power = self.lightSource.power - 0.01
    end


    if(self.currentCooldown < self.transformCooldown) then
        self.currentCooldown = self.currentCooldown + dt
    end
    if self.currentCooldown >= self.transformCooldown and love.keyboard.wasPressed("h") then
        self:alternateForm()
    end

    if(moveX == 0 and moveY == 0) then
        self.isStill = true
    else
        self.isStill = false
    end
    self.x = self.x + moveX*dt
    self.y = self.y + moveY*dt

end

function Player:alternateForm()
    self.isDeer = not self.isDeer
    if self.isDeer then
        self.speed = 250
    else
        self.speed = 150
    end
    self.currentCooldown = 0
    self:reset()
    self:play("human_"..self.currentMovement, true)
end

function Player:update(dt)
    STI_AnimatedSpriteObject.update(self, dt)
    self:input(dt)
    if self.isCameraFollowing then
        --self.camera:move(self.x - self.camera.x, self.y - self.camera.y)
        self.camera:lockX(self.x)
        self.camera:lockY(self.y)
    end
    self.lightSource.position[1] = self.x + love.graphics.getWidth()/2 + 16 --Half screen + half size
    self.lightSource.position[2] = self.y + love.graphics.getHeight()/2 + 16 --Half screen + half size

end


function Player:draw()
    if self.isDeer then
        if self.isStill then
            self:play("deer_"..self.currentMovement.."_i")
        else
            self:loopPlay("deer_"..self.currentMovement)
        end
    else
        if self.isStill then
            self:stopAtFrame(2)
        else
            self:pingPongPlay("human_"..self.currentMovement)
        end
    end

    STI_AnimatedSpriteObject.draw(self)
end