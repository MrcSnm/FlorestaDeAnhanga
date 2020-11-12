AnimalSpawner = Class("AnimalSpawner")

SPAWN_AREAS_NAME = "spawns"
INITIAL_ANIMAL_COUNT = 20

function AnimalSpawner:initialize(map)
    
    --Spawn areas array
    self.spawnAreas = {}
    --Animals array
    self.animals = {}
    --Options Array
    self.options = {}
    self.activeAnimals = 0

    self.isSpawning = true


    local this = self
    self.spawnTimer = Timer(Timer.ONE_SHOT, 5, function ()
        this:randSpawn()
    end, function ()
        return this.isSpawning
    end)


    for i, v in pairs(map.layers[SPAWN_AREAS_NAME].objects) do
        table.insert(self.spawnAreas, {x = v.x, y = v.y, width = v.width, height = v.height})
    end


    for k, v in pairs(ANIMAL_TYPES) do
        table.insert(self.options, k)
    end


    self:spawn(player.x, player.y, ANIMAL_TYPES.tartaruga)
    -- for i = 1, INITIAL_ANIMAL_COUNT do
    --     self:randSpawn()
    -- end
end

function AnimalSpawner:spawn(x, y, animalType)
    table.insert(self.animals, Animal(animalType, x, y))
    self.activeAnimals = self.activeAnimals + 1
end

function AnimalSpawner:randSpawn()

    local area = self.spawnAreas[math.random(#self.spawnAreas)]
    local sX = math.random(area.x, area.x+area.width)
    local sY = math.random(area.y, area.y+area.height)

    local randAnimal = self.options[math.random(#self.options)]
    self:spawn(sX, sY, ANIMAL_TYPES[randAnimal])
end

function AnimalSpawner:update(dt)

    for i = 1, self.activeAnimals do
        self.animals[i]:update(dt)
    end
    -- self.spawnTimer:update(dt)
end

function AnimalSpawner:draw()
    for i = 1, self.activeAnimals do
        self.animals[i]:draw()
    end
end