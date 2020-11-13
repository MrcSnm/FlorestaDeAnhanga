Sprite = Class"Sprite"

function Sprite:initialize()
    self.currentTexture = nil
    self.currentQuad = nil
    self.x = 0
    self.y = 0
    self.rotation = 0
    self.opacity = 1
    self.visible = true
    self.scaleX = 1
    self.scaleY = 1
    self.originX = 0.5
    self.originY = 0.5

    self._color = {r=1,g=1,b=1,a=self.opacity}
end

function Sprite:setColor(r,g,b,a)
    self._color = {r=r,g=g,b=b,a=a}
    self.opacity = a
end

function Sprite:setQuad(quad)
    self.currentQuad = quad
end

function Sprite:setRotationDegrees(degree)
    self.rotation = degree / 180 * math.pi
end

function Sprite:setOrigin(x, y)
    self.originX = x
    if(not y) then
        self.originY = x
    else
        self.originY = y
    end
end

function Sprite:setPosition(x, y)
    self.x = x
    self.y = y
end

function Sprite:setScale(x, y)
    self.scaleX = x
    if(not y) then
        self.scaleY = x
    else
        self.scaleY = y
    end
end


function Sprite:setOpacity(opacity)
    self.opacity = opacity
end
function Sprite:getOpacity() return self.opacity end

function Sprite:setVisible(visible)
    self.visible = visible
end
function Sprite:isVisible() return self.visible end


local function manageOpacity(sprite)
    local r, g, b, a = love.graphics.getColor()

    local hasChange = false
    if(a ~= sprite.opacity or r ~= sprite._color.r or g ~= sprite._color.g or b ~= sprite._color.b) then
        love.graphics.setColor(r,g,b, sprite.opacity)
        hasChange = true
    end

    return hasChange, sprite._color.r, sprite._color.g, sprite._color.b, sprite.opacity
end

function Sprite:draw()
    if self.visible and self.opacity > 0 then
        local hasChange, r, g, b, a = manageOpacity(self)
        if self.currentTexture == nil then
            drawTextureless(self.x, self.y)
        else
            if self.currentQuad ~= nil then
                love.graphics.draw(
                    self.currentTexture,
                    self.currentQuad,
                    self.x, self.y,
                    self.rotation,
                    self.scaleX, self.scaleY,
                    self.originX, self.originY
                )
            else
                love.graphics.draw(
                    self.currentTexture,
                    self.x, self.y,
                    self.rotation,
                    self.scaleX, self.scaleY,
                    self.originX, self.originY
                )
            end
        end
        if hasChange then
            love.graphics.setColor(r,g,b,a)
        end
    end
end