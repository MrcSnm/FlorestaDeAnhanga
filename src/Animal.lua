Animal = Class("Animal", AnimatedSprite)
local lg = love.graphics

local function createAnimalType(animalType, columns_anim,  rows_anim, columns_types, rows_types, width, height, movespeed, scale)
    local ret = {}
    ret.animalType = animalType
    ret.texture = Assets.getSprite(animalType..".png")
    width = width or 32 --Default size
    height = height or width

    ret.spritesheet = generateSpritesheetMultiple(ret.texture,
        rows_anim, columns_anim, rows_types, columns_types
    )

    ret.movespeed = movespeed
    ret.frames = {}



    for i, v in ipairs(ret.spritesheet) do 
        table.insert(ret.frames ,spritesheetToFrames_RPGMaker(v, columns_anim, {"down", "left", "right", "up"}, 12))
    end

    ret.palleteSize = columns_types*rows_types
    ret.scale = scale or 1
    
    return ret
end

DIRECTIONS = 
{
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    RIGHT = 4
}
ANIMAL_TYPES = 
{
    --                                Name     Col, Row, Col, Row, TileW, TileH,  Movespeed
    ["passaro"] = createAnimalType  ("passaro",   3, 4, 4, 2, 48, 48, 125),
    ["pintinho"] = createAnimalType ("pintinho",  3, 4, 4, 2, 32, 32, 100),
    ["rato"] = createAnimalType     ("rato",      3, 4, 4, 2, 48, 48, 150),
    ["sapo"] = createAnimalType     ("sapo",      3, 4, 4, 2, 48, 48, 75),
    ["tartaruga"] = createAnimalType("tartaruga", 3, 4, 4, 2, 48, 48, 50, 1)
}


function Animal:initialize(animalType, x, y, colliderName, interface)

    self.animalType = animalType
    self.palleteChoice = math.random(animalType.palleteSize)
    AnimatedSprite.initialize(self, animalType.frames[self.palleteChoice])
    self.currentDir = -1
    self.currentMovement = "down"
    self.x = x
    self.y = y

    
    --Just need to finish fastly
    self.map = GAME_MAP 
    self.world = WORLD
    self.interface = interface
    self.collider = {name = colliderName}
    self:inputCollider()

    
    self.movespeed = animalType.movespeed
    self.isMoving = true
    self.isStill = false
    self.stopChangingDir = false
    self.followTarget = nil
    self.isEnteringCave = false

    self:changeDir()
    self:setScale(animalType.scale)

    local this = self

    self.changeDirTimer = Timer(Timer.ONE_SHOT, math.max(math.random()*4,0.25),
    function(progress, timer)
        this:changeDir()
        timer.countdown = math.max(math.random()*4, 0.25)
    end,
    function() return this.stopChangingDir end)

    self.lightSource=
    {
        position = {self.x, self.y},
        diffuse = {1,1,1, 1},
        power = 2000,
        falloff = 1,
        minThreshold = 20, --If lesser, color = power
        maxThreshold = 500 --If higher, color = 0
    }

    self.movementsSequence = {}
end


function Animal:enterCave()
    local this = self
    self.isEnteringCave = true
    return ActionSequence({
        ActionDelay(0.1),
        ActionCallback(function()
            this.isStill = false
            this:reset()
            if CAVE.x-lg.quarterWidth*1.125 > self.x then
                self.currentMovement = "right"
            else
                self.currentMovement = "left"
            end
        end),
        MoveToAction(1, CAVE.x-lg.quarterWidth*1.125, self.y, self),
        ActionCallback(function()
            this.isStill = false
            self.currentMovement = "up"
        end),
        ActionSpawn({
            MoveToAction(1, CAVE.x-lg.quarterWidth*1.125, CAVE.y-lg.quarterHeight*1.4, self),
            ActionSequence({
                ActionDelay(0.75),
                ActionTintTo(0.25, {r=1, g=1,b=1,a=0}, self)
            })
        }),
        ActionCallback(function ()
            LIGHTING_SHADER:removeLightSource(this.lightSource)
            this.interface:addAnimal(this.animalType)
        end)
    })
end

function Animal:inputCollider()
    self.world:add(self.collider, self.x, self.y, self.map.tilewidth/1.25, self.map.tileheight/1.25)
end

function Animal:startFollowing(target)
    assert(target.x ~=nil and target.y~=nil, "Target does not have any position")

    self.followTarget = target
    self.stopChangingDir = true
    LIGHTING_SHADER:addLightSource(self.lightSource)
    self:onRemove()
end

function Animal:onRemove()
    self.world:remove(self.collider)
end


function Animal:putMovement(mov)
    if mov == nil then
        return
    end
    
    if(#self.movementsSequence == 0) then
        table.insert(self.movementsSequence, mov)
        return
    end
    local currMov = self.movementsSequence[#self.movementsSequence]
    if(mov.tileX ~= currMov.tileX or mov.tileY ~= currMov.tileY) then
        table.insert(self.movementsSequence, mov)
    end
end

function Animal:changeDir()
    self.currentDir = math.random(4)
end

function Animal:walk(dt)
    local dx = 0
    local dy = 0
    local dir = self.currentDir
    if dir == DIRECTIONS.UP then
        dy = -self.movespeed
        self.currentMovement = "up"
    elseif dir == DIRECTIONS.DOWN then
        dy = self.movespeed
        self.currentMovement = "down"
    elseif dir == DIRECTIONS.LEFT then
        dx = -self.movespeed
        self.currentMovement = "left"
    elseif dir == DIRECTIONS.RIGHT then
        dx = self.movespeed
        self.currentMovement = "right"
    end

    if self.currentDir ~= -1 then
        self:loopPlay(self.currentMovement, self.isRunning)
    else
        self:stopAtFrame(2)
    end


    local tempX = self.x + dx*dt
    local tempY = self.y + dy*dt

    
    if self.followTarget == nil then
        local len = 0
        local nX, nY, col, len = self.world:move(self.collider, tempX+lg.quarterWidth+16,  tempY+lg.quarterHeight+30)
        self.isStill = len > 0
        if nX > 0 and nX < self.map.width*self.map.tilewidth then
            self.x = nX-lg.quarterWidth-16
        end
        if nY > 0 and nY < self.map.height*self.map.tileheight then
            self.y = nY-lg.quarterHeight-30
        end
    else
        self.x = tempX
        self.y = tempY
    end

end

function Animal:update(dt)
    AnimatedSprite.update(self, dt)
    if self.followTarget == nil then
        self:walk(dt) --Random walk
    elseif not self.isEnteringCave then
        self:followSequence()
    end
    self.changeDirTimer:update(dt)
    self.lightSource.position[1] = self.x+lg.quarterWidth
    self.lightSource.position[2] = self.y+lg.quarterHeight
end

function Animal:draw()
    if self.isStill then
        self:stopAtFrame(2)
    else
        self:loopPlay(self.currentMovement, not self.isRunning)
    end
    AnimatedSprite.draw(self)
end


function Animal:moveTo(tileX, tileY)

    if self.isMovementLocked then
        return
    end
    self.isMovementLocked = true
    local willMove = true

    local x = self.map.tilewidth*tileX
    local y = self.map.tileheight*tileY

    local diffX = math.floor(x - self.x)
    local diffY = math.floor(y - self.y)
    local offset = 32

    local act
    local movements = {}
    local this = self
    local speed = 0.1


    if(math.abs(diffX) + math.abs(diffY) == offset) then
        willMove = false;
        self.isStill = true
    elseif(math.abs(diffX) > math.abs(diffY)) then
        if diffX > 0 then
            x = x - offset
            self.currentMovement = "right"
            table.insert(movements, ActionCallback(function()
                this:loopPlay("right")
            end))
        else
            x = x + offset
            self.currentMovement = "left"
            table.insert(movements, ActionCallback(function()
                this:loopPlay("left")
            end))
        end
    elseif(math.abs(diffX) < math.abs(diffY)) then
        if diffY > 0 then
            y = y - offset
            self.currentMovement = "down"
            table.insert(movements, ActionCallback(function()
                this:loopPlay("down")
            end))
        else
            y = y + offset
            self.currentMovement = "up"
            table.insert(movements, ActionCallback(function()
                this:loopPlay("up")
            end))
        end
    end

    if willMove then
        self.isStill = true
        table.insert(movements, MoveToAction(speed, x, y, self))
    end

    table.insert(movements, ActionCallback(function()
        this.isMovementLocked = false
        table.remove(this.movementsSequence, 1)
    end))

    act = ActionSequence(movements)
    ACT:pushAction(act)
end


function Animal:followSequence()
    if #self.movementsSequence > 0 then
        self:moveTo(self.movementsSequence[1].tileX, self.movementsSequence[1].tileY)
    end

end