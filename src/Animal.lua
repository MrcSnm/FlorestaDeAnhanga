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
    ["passaro"] = createAnimalType  ("passaro",   3, 4, 4, 2, 48, 48, 200),
    ["pintinho"] = createAnimalType ("pintinho",  3, 4, 4, 2, 48, 48, 250),
    ["rato"] = createAnimalType     ("rato",      3, 4, 4, 2, 48, 48, 300),
    ["sapo"] = createAnimalType     ("sapo",      3, 4, 4, 2, 48, 48, 150),
    ["tartaruga"] = createAnimalType("tartaruga", 3, 4, 4, 2, 48, 48, 100, 1)
}


function Animal:initialize(animalType, x, y, colliderName)

    self.animalType = animalType
    self.palleteChoice = math.random(animalType.palleteSize)
    AnimatedSprite.initialize(self, animalType.frames[self.palleteChoice])
    self.currentDir = -1
    self.x = x
    self.y = y

    
    --Just need to finish fastly
    self.map = GAME_MAP 
    self.world = WORLD
    self.collider = {name = colliderName}
    self:inputCollider()

    
    self.movespeed = animalType.movespeed
    self.isMoving = false

    self:changeDir()
    self:setScale(animalType.scale)

    local this = self

    self.changeDirTimer = Timer(Timer.ONE_SHOT, 4,
    function()this:changeDir()end,
    function() return this.isMoving end)

end

function Animal:inputCollider()
    self.world:add(self.collider, self.x, self.y, self.map.tilewidth/1.25, self.map.tileheight/1.25)
end

function Animal:onRemove()
    self.world:remove(self.collider)
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
    elseif dir == DIRECTIONS.DOWN then
        dy = self.movespeed
    elseif dir == DIRECTIONS.LEFT then
        dx = -self.movespeed
    else
        dx = self.movespeed
    end

    if dx > 0 then
        self:loopPlay("right")
    elseif dx < 0 then
        self:loopPlay("left")
    elseif dy > 0 then
        self:loopPlay("down")
    else
        self:loopPlay("up")
    end

    local tempX = self.x + dx*dt
    local tempY = self.y + dy*dt
    local nX, nY = self.world:move(self.collider, tempX+lg.quarterWidth,  tempY+lg.quarterHeight)

    if nX > 0 and nX < self.map.width*self.map.tilewidth then
        self.x = nX-lg.quarterWidth
    end
    if nY > 0 and nY < self.map.height*self.map.tileheight then
        self.y = nY-lg.quarterHeight
    end

end

function Animal:update(dt)
    AnimatedSprite.update(self, dt)
    self:walk(dt)
    self.changeDirTimer:update(dt)
end

function Animal:draw()
    AnimatedSprite.draw(self)
end

function Animal:follow(target)

    local dx = target.x - self.x
    local dy = target.y - self.y

    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then --Move
        else
        end
    else
        if dx > 0 then
        else
        end
    end
end