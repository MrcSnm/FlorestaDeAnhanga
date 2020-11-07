Fire = Class("Fire", AnimatedSprite)


function Fire:initialize(parent, x, y)
    AnimatedSprite.initialize(self, {})
    self.neighbors = {}
    self.parent = parent
end


function Fire:spawnAdjacent()

    --DirX
    local left = Fire(self)
    local right = Fire(self)


    --DirY
    local up = Fire(self)
    local down = Fire(self)

end