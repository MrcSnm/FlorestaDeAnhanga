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

function setColor(r,g,b,a)
    if a == nil then a = 255 end
    love.graphics.setColor(r / 255,g / 255,b / 255, a / 255)
end

function generateSpritesheetTiles(texture, tileWidth, tileHeight, offsetX, offsetY)

    local height = texture:getHeight()
    local width = texture:getWidth()
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

    local frame = 0
    for y = 0, height - frameHei, frameHei do
        for x = 0, width - frameWid, frameWid do
            spriteSheet.frames[frame] = love.graphics.newQuad(x + offsetX, y + offsetY, frameWid, frameHei, texture:getDimensions())
            frame = frame + 1
        end
    end
    return spriteSheet
end

function getQuadSize(quad)
    local tempX, tempY, tempW, tempH = quad:getViewport()
    return {width = tempW, height = tempH}
end

function generateSpritesheet(texture, lines, columns)
    return generateSpritesheetTiles(texture, texture:getWidth() / lines, texture:getHeight() / columns, 0, 0)
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
        local cCount = 0
        local start = columns*i -1 --Spritesheets starts on 0

        while cCount < columns do
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

function table.swap(table, first, second)
    local buf = table[first]
    table[first] = table[second]
    table[second] = buf
end