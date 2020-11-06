STI_AnimatedSpriteObject = Class("STI_AnimatedSpriteObject", AnimatedSprite)


function STI_AnimatedSpriteObject:initialize(map, name, frames)

    AnimatedSprite.initialize(self, frames)
    STI_Object.initialize(self, map, name)

end