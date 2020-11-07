Fire = Class("Fire", AnimatedSprite)


function Fire:initialize(parent, x, y)
    AnimatedSprite.initialize(self, {})
    self.neighbors = {}
    self.parent = parent
end


function Fire:spawnAdjacent()

    --DirX
    local left = Fire(self, self.x-1, self.y)
    local right = Fire(self, self.x+1, self.y)


    --DirY
    local up = Fire(self, self.x, self.y-1)
    local down = Fire(self, self.x, self.y+1)

end