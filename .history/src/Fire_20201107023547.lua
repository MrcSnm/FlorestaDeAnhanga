Fire = Class("Fire", AnimatedSprite)


function Fire:initialize()
    AnimatedSprite.initialize(self, {})
    self.neighbors = {}
end


function Fire:spawnAdjacent()

    --DirX
    local left
    local right


    --DirY
    local up
    local down 

end