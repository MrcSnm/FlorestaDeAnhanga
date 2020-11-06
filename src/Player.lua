Player = Class("Player", STI_Object)

function Player:initialize(map)
    STI_Object.initialize(self, map,  "Player")
    self.isDeer = true

    self.deerSprite = generateSpritesheet(Assets.getSprite("Anhangua.png"), 4, 3)
    self.humanSprite = generateSpritesheet(Assets.getSprite("Anhangua_Human.png"), 4, 3)
end


function Player:draw()
    love.graphics.draw()
end