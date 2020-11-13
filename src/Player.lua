Player = Class("Player", STI_AnimatedSpriteObject)


local lg = love.graphics

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

    self.map = map
    self.mapWidth = self.map.width * self.map.tilewidth
    self.mapHeight = self.map.height * self.map.tileheight

    camera.smoother = Camera.smooth.damped(5)
    camera:lookAt(self.x, self.y)

    self.lightSource = {
        position = {self.x, self.y},
        diffuse = {1,1,1, 1},
        power = 4000,
        falloff = 1,
        minThreshold = 20, --If lesser, color = power
        maxThreshold = 500 --If higher, color = 0
    }

    self.collider = 
    {
        name="Player"
    }
    self.world = WORLD

    self.followingAnimals = {}
    self:inputCollider(WORLD)

end

function Player:inputCollider(world)
    world:add(self.collider, self.x, self.y, self.map.tilewidth, self.map.tileheight)
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



    if(self.currentCooldown < self.transformCooldown) then
        self.currentCooldown = self.currentCooldown + dt
    end
    if self.currentCooldown >= self.transformCooldown and love.keyboard.wasPressed("h") then
        self:alternateForm()
    end

    self.isStill = (moveX == 0 and moveY == 0)


    
    local tempX = self.x + moveX*dt
    local tempY = self.y + moveY*dt

    
    local _x, _y, cols, len = WORLD:move(self.collider, tempX+lg.quarterWidth, tempY+lg.quarterHeight+30)
    
    if _x > 32 and _x < self.mapWidth then
        self.x = _x-lg.quarterWidth
    end
    if _y > 32 and _y < self.mapHeight then
        self.y = _y-lg.quarterHeight-30
    end

end


function Player:getNextToFollow(animal)
    table.insert(self.followingAnimals, animal)
    if #self.followingAnimals == 1 then
        return self
    else
        return self.followingAnimals[#self.followingAnimals-1]
    end
end

function Player:interaction(spawner)
    local x = self.x
    local y = self.y

    local nX = x
    local nY = y
    if self.currentMovement == "up" then
        nY = y - 32
    elseif self.currentMovement == "down" then
        nY = y + 32
    elseif self.currentMovement == "left" then
        nX = x - 32
    else
        nX = x + 32
    end

    local current = {x = x, y = y, width = 32, height = 32}
    local next = {x = nX, y = nY, width = 32, height = 32}
    for i, v in ipairs(spawner.animals) do
        local rec = {x = v.x, y = v.y,  width = 32, height = 32}
        if rectIntersectsRect(current,  rec) or rectIntersectsRect(next, rec) then
            if(v.followTarget == nil) then
                v:startFollowing(self:getNextToFollow(v))
                return
            end
        end
    end
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
end

function Player:update(dt)
    STI_AnimatedSpriteObject.update(self, dt)
    self:input(dt)
    if self.isCameraFollowing then
        --self.camera:move(self.x - self.camera.x, self.y - self.camera.y)
        cam_lockX(self.camera, math.min(math.max(self.x, 0), self.mapWidth - love.graphics.halfWidth))
        cam_lockY(self.camera, math.min(math.max(self.y, 0), self.mapHeight - love.graphics.halfHeight))
    end
    self.lightSource.position[1] = self.x + love.graphics.getWidth()/2 --Half screen + half size
    self.lightSource.position[2] = self.y + love.graphics.getHeight()/2 --Half screen + half size

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
            self:reset()
            self:play("human_"..self.currentMovement)
            self:stopAtFrame(2)
        else
            self:pingPongPlay("human_"..self.currentMovement)
        end
    end

    STI_AnimatedSpriteObject.draw(self)
end