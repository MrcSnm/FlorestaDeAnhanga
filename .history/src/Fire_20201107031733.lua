Fire = Class("Fire", AnimatedSprite)


function Fire:initialize(parent)
    AnimatedSprite.initialize(self, {})
    self.neighbors = {}
    self.parent = parent
end


function Fire:spawnAdjacent()

    --DirX
    local left
    local right


    --DirY
    local up
    local down

end