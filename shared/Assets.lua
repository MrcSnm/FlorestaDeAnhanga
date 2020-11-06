Assets = 
{
    path = "assets",
    spritePath = "sprites",
    imagePath = "images",
    sfxPath = "sfx",
    musicPath = "musics",
    _sfxs={},_musics={},_images={},_sprites={},

    getSfx = function(sfxName)
        local str = Assets.path.."/"..Assets.sfxPath.."/"..sfxName
        if(Assets._sfxs[str] == nil) then
            Assets._sfxs[str] = love.audio.newSource(str, "static")
        end
        return  Assets._sfxs[str];
    end,

    getMusic = function(musicName)
        local str = Assets.path.."/"..Assets.musicPath.."/"..musicName
        if(Assets._musics[str] == nil) then
            Assets._musics[str] = love.audio.newSource(str, "stream")
        end
        return  Assets._musics[str];
    end,

    getImages = function(imageName)
        local str = Assets.path.."/"..Assets.imagePath.."/"..imageName
        if(Assets._images[str] == nil) then
            Assets._images[str] = love.graphics.newImage(str)
        end
        return  Assets._images[str];
    end,

    getSprite = function(spriteName)
        local str = Assets.path.."/"..Assets.spritePath.."/"..spriteName
        if(Assets._sprites[str] == nil) then
            Assets._sprites[str] = love.graphics.newImage(str)
        end
        return  Assets._sprites[str];
    end,

    _imgs = {}
}