
function moveByTiles(tilesX, tilesY, map, target, duration)
    local x = map.tileswidth*tilesX
    local y = map.tilesheight*tilesY
    return tween.new(duration, target, {x = target.x+x, y = target.y+y})
end

