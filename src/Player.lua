Player = Class("Player", STI_AnimatedSpriteObject)

function Player:initialize(map)
    self.deerSprite = generateSpritesheet(Assets.getSprite("Anhangua.png"), 4, 3)
    self.humanSprite = generateSpritesheet(Assets.getSprite("Anhangua_Human.png"), 4, 3)
    STI_AnimatedSpriteObject.initialize(self, map,  "Player",
    {
        spritesheetToFrames_RPGMaker(self.deerSprite, 3, {"deer_up", "deer_right", "deer_down", "deer_left"}, 12),
        spritesheetToFrames_RPGMaker(self.humanSprite, 3, {"human_down", "human_left", "human_right", "human_up"}, 12)
    })

    self.speed = 100
    self.isDeer = true
    self:loopPlay("deer_down")

    self.transformCooldown = 1
    self.currentCooldown = 0

    self.currentMovement = "down"

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
    else
       -- self:goToIdle(false)
    end


    if(self.currentCooldown < self.transformCooldown) then
        self.currentCooldown = self.currentCooldown + dt
    end
    if self.currentCooldown >= self.transformCooldown and love.keyboard.wasPressed("h") then
        self.isDeer = not self.isDeer
        self.currentCooldown = 0
    end

    self.x = self.x + moveX*dt
    self.y = self.y + moveY*dt

end

function Player:update(dt)

    STI_AnimatedSpriteObject.update(self, dt)
    self:input(dt)
end


function Player:draw()

    if self.isDeer then
        self.currentTexture = self.deerSprite.texture
        self:pingPongPlay("deer_"..self.currentMovement)
    else
        self.currentTexture = self.humanSprite.texture
        self:pingPongPlay("human_"..self.currentMovement)
    end
    STI_AnimatedSpriteObject.draw(self)
end