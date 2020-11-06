Player = Class("Player", STI_AnimatedSpriteObject)

function Player:initialize(map)
    self.deerSprite = generateSpritesheet(Assets.getSprite("Anhangua.png"), 4, 3)
    self.humanSprite = generateSpritesheet(Assets.getSprite("Anhangua_Human.png"), 4, 3)
    STI_AnimatedSpriteObject.initialize(self, map,  "Player",
    {
        spritesheetToFrames_RPGMaker(self.deerSprite, 3, {"deer_up", "deer_right", "deer_down", "deer_left"}, 12),
        spritesheetToFrames_RPGMaker(self.humanSprite, 3, {"human_down", "human_left", "human_right", "human_up"}, 12)
    })
    self.isDeer = true  

end


function Player:draw()

    if self.isDeer then
        self.currentTexture = self.humanSprite
    else
        self.currentTexture = self.humanSprite
    end

    Sprite.draw(self)
end