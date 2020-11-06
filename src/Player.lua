Player = Class("Player", STI_AnimatedSpriteObject)

function Player:initialize(map)
    STI_AnimatedSpriteObject.initialize(self, map,  "Player",
    {
        {""}
    })
    self.isDeer = true  

    self.deerSprite = generateSpritesheet(Assets.getSprite("Anhangua.png"), 4, 3)
    self.humanSprite = generateSpritesheet(Assets.getSprite("Anhangua_Human.png"), 4, 3)
end


function Player:draw()

    if self.isDeer then
        self.currentTexture = self.humanSprite
    else
        self.currentTexture = self.humanSprite
    end

    Sprite.draw(self)
end