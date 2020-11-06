STI_SpriteObject = Class("STI_SpriteObject", Sprite)


function STI_SpriteObject:initialize(map, name)
    Sprite.initialize(self)
    STI_Object.initialize(self, map, name)
end