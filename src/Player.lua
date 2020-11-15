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
    self.canInput = true
    self.isStill = true
    self.isCameraFollowing = true

    self.walkSounds = {Assets.getSfx("walk_1.wav"), Assets.getSfx("walk_2.wav"),
                        Assets.getSfx("walk_4.ogg"), Assets.getSfx("walk_5.ogg"), Assets.getSfx("walk_6.ogg")}
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
    self.moveHistory = {}
    self._currentMove = nil
    self.nextMoveHistory = 1

    self.stopWalkSound = false

    self:inputCollider(WORLD)

    local this = self
    self.walkTimer = Timer(Timer.ONE_SHOT, 0.2, function()
        this:getWalkSound(0.2, 0.5):play()
    end,
    function ()
        return this.stopWalkSound
    end)
end

function Player:getWalkSound(pitchRange, volumeRange)
    local pitch = randomNum(-pitchRange, pitchRange)+1
    local volume = randomNum(-volumeRange, volumeRange)+0.5
    local sound = self.walkSounds[math.random(#self.walkSounds)]
    sound:setPitch(pitch)
    sound:setVolume(volume)

    return sound
end

function Player:addToHistory()

    if #self.followingAnimals > 0 then
        local tileX = math.floor(self.x / self.map.tilewidth)
        local tileY = math.floor(self.y / self.map.tileheight)

        local toCheck = self.nextMoveHistory - 1
        if toCheck == 0 then toCheck = #self.moveHistory end

        if toCheck ~= 0 then
            if tileX == self.moveHistory[toCheck].tileX and tileY == self.moveHistory[toCheck].tileY then
                return
            end
        end
        
        
        self.moveHistory[self.nextMoveHistory] = {tileX = tileX, tileY = tileY}

        self.nextMoveHistory = self.nextMoveHistory + 1

        if self.nextMoveHistory > #self.followingAnimals then
            self.nextMoveHistory = 1
        end


    end
    
end

function Player:think(text)
    Talkies.say("Anhanga", "\n"..text, {
        image = Assets.getSprite("Anhanguarosto.png"),
        talkSound = Assets.getSfx("talk_sound.mp3"),
        talkSpeed = "medium",
        padding = 20,
        typedNotTalked = false
    })
end
function Player:say(text, onComplete)
    Talkies.say("Anhanga", "\n"..text, {
        image = Assets.getSprite("Anhanguarostoaberto.png"),
        oncomplete = onComplete,
        talkSound = Assets.getSfx("talk_sound.mp3"),
        padding = 20,
        typedNotTalked = false
    })
end


function Player:manageFollowingAnimal()
    self._currentMove = {tileX = math.floor(self.x / self.map.tilewidth), tileY =math.floor(self.y / self.map.tileheight)}
    self:addToHistory()
    self:sendMovements()
end

function Player:inputCollider(world)
    world:add(self.collider, self.x, self.y, self.map.tilewidth, self.map.tileheight)
end

function Player:disableInput()
    self.canInput = false
    self.isStill = true
end

function Player:input(dt)
    if not self.canInput or Talkies.isOpen() then
        return
    end
    local moveX = 0
    local moveY = 0

    self.walkTimer:setActive()

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
        self.walkTimer:pause()
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
    if #self.followingAnimals == 0 then
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

    local rec = {x=CAVE.x-lg.quarterWidth, y=CAVE.y-lg.quarterHeight, width=32, height=32}
    if rectIntersectsRect(next, rec) or rectIntersectsRect(current, rec) then
        if(#self.followingAnimals > 0) then
            local this = self
            self:disableInput()
            ACT:pushAction(ActionSequence({
                self.followingAnimals[1]:enterCave(),
                ActionCallback(function ()
                    this.canInput = true
                    this.followingAnimals[1] = nil
                end)
            }))
        end
    end
end

function Player:alternateForm()
    
    local this = self
    self.currentCooldown = 0
    ACT:pushAction(ActionSequence({
        ActionTintTo(0.4, {r=0,g=0,b=0,a=0}, self),
        ActionCallback(function()
            this.isDeer = not this.isDeer
            if this.isDeer then
                this.speed = 250
            else
                this.speed = 150
            end
        end), 
        ActionTintTo(0.4, {r=1,g=1,b=1,a=1}, self),
    }))
    self:reset()
end

function Player:sendMovements()
    for i, v in ipairs(self.followingAnimals) do
        local next = self.nextMoveHistory + (i-1)

        if next > #self.followingAnimals then
            next = (next % #self.followingAnimals)
        end

        v:putMovement(self.moveHistory[next])
    end
end

function Player:update(dt)
    STI_AnimatedSpriteObject.update(self, dt)

    if not self.canInput then
        self.walkTimer:pause()
    end
    self.walkTimer:update(dt)
    self:input(dt)
    if self.isCameraFollowing then
        --self.camera:move(self.x - self.camera.x, self.y - self.camera.y)
        cam_lockX(self.camera, math.min(math.max(self.x, 0), self.mapWidth - love.graphics.halfWidth))
        cam_lockY(self.camera, math.min(math.max(self.y, 0), self.mapHeight - love.graphics.halfHeight))
    end
    self.lightSource.position[1] = self.x + lg.quarterWidth --Half screen + half size
    self.lightSource.position[2] = self.y + lg.quarterHeight --Half screen + half size

    self:manageFollowingAnimal()
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