system = 'Unix'
Color = 
{
    WHITE = {r = 1, g = 1, b = 1, a = 1},
    RED = {r = 1, g = 0, b = 0, a = 1},
    GREEN = {r = 0, g = 1, b = 0, a = 1},
    BLUE = {r = 1, g = 0, b = 1, a = 1},
    CYAN = {r = 0, g = 1, b = 1, a = 1},
    YELLOW = {r = 1, g = 1, b = 0, a = 1},
    PURPLE = {r = 1, g = 0, b = 1, a = 1},
    BLACK = {r = 0, g = 0, b = 0, a = 1}
}

function setOs()
    system = love.system.getOS()
end

function drawTextureless(x, y)
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle("fill", x, y, 32, 32)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", x-2, y-2, 36, 36)
    love.graphics.setColor(0,1,0,1)
    love.graphics.line(x-2, y-2, x+34, y+34)
    love.graphics.line(x+34, y-2, x-2, y+34)
    love.graphics.setColor(r,g,b,a)

end
function generateSpritesheetSized(texture, tileWidth, tileHeight, maxWidth, maxHeight, offsetX, offsetY)

    local width = maxWidth
    local height = maxHeight
    local frameWid = tileWidth
    local frameHei =tileHeight

    local spriteSheet = 
    {
        texture = texture,
        frameWidth = frameWid,
        frameHeight = frameHei,
        width = width,
        height = height,
        offsetX = offsetX,
        offsetY = offsetY,
        frames = {}        
    }

    
    local frame = 1
    for y = 0, height - frameHei, frameHei do
        for x = 0, width - frameWid, frameWid do
            spriteSheet.frames[frame] = love.graphics.newQuad(x+offsetX, y+offsetY, frameWid, frameHei, texture:getDimensions())
            frame = frame + 1
        end
    end
    return spriteSheet
end


function generateSpritesheetTiles(texture, tileWidth, tileHeight, offsetX, offsetY)
    return generateSpritesheetSized(
        texture, 
        tileWidth, tileHeight,
        texture:getWidth(), texture:getHeight(),
        offsetX, offsetY
    )
end

function getQuadSize(quad)
    local tempX, tempY, tempW, tempH = quad:getViewport()
    return {width = tempW, height = tempH}
end

function lerp(val1, val2, ratio)
    return val1*(1-ratio)+val2*ratio
end

function lerp2(c1, c2, ratio)
    return {lerp(c1[1], c2[1], ratio), lerp(c1[2], c2[2], ratio)}
end

function lerp3(c1, c2, ratio)
    return {lerp(c1[1], c2[1], ratio), lerp(c1[2], c2[2], ratio), lerp(c1[3], c2[3], ratio)}
end

function lerp4(c1, c2, ratio)
    return {lerp(c1[1], c2[1], ratio), lerp(c1[2], c2[2], ratio), lerp(c1[3], c2[3], ratio), lerp(c1[4], c2[4], ratio)}
end

function generateSpritesheet(texture, lines, columns)
    return generateSpritesheetTiles(texture, texture:getWidth() / columns, texture:getHeight() / lines, 0, 0)
end

function generateSpritesheetMultiple(texture, lines_anim, columns_anim, lines_types, columns_types)
    local ret = {}
    local w = texture:getWidth()
    local h = texture:getHeight()

    local tw = w/columns_types/columns_anim
    local th = h/lines_types/lines_anim


    for i = 1, columns_types do
        for j = 1, lines_types do
            table.insert(ret, generateSpritesheetSized(texture, 
            tw, th, tw * columns_anim, th * lines_anim, (i-1)*tw*columns_anim, (j-1)*th*lines_anim))
        end
    end
    return ret
end


--Names array
function spritesheetToFrames_RPGMaker(spritesheet, columns, frameNamesList, speed)
    local rpg = {}
    for i = 1, #frameNamesList do

        local currFrame = 
        {
            name = frameNamesList[i],
            speed = speed,
            frames = {},
            texture = spritesheet.texture
        }
        local cCount = 1
        local start = columns*(i-1) --Spritesheets starts on 0

        while cCount <= columns do
            table.insert(currFrame.frames, spritesheet.frames[start+cCount])
            cCount = cCount + 1
        end
        table.insert(rpg, currFrame)
    end

    return rpg
end


function string.split(string, pattern)
    local ret = {}
    for g in string.gmatch(string, pattern) do
        table.insert(ret, g)
    end
    return ret;
end



function table.slice(table, first, last, step)
    local sliced = {}

    for i = first or 1, last or #table, step or 1 do
        sliced[#sliced+1] = table[i]
    end
    return sliced
end

function table.pack(...)
    return {...}
end

function printKeys(tb)
    for k, v in pairs(tb) do
        print(k.." =",v)
    end
end

function table.swap(table, first, second)
    local buf = table[first]
    table[first] = table[second]
    table[second] = buf
end

function isInRange(left, right, n)
    return n>= left and n <= right
end




love.graphics.halfWidth = love.graphics.getWidth()/2
love.graphics.halfHeight = love.graphics.getHeight()/2
love.graphics.quarterWidth = love.graphics.getWidth()/4
love.graphics.quarterHeight = love.graphics.getHeight()/4