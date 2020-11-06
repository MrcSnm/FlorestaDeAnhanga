Sprite = Class"Sprite"

function Sprite:initialize()
    self.currentTexture = nil
    self.currentQuad = nil
    self.x = 0
    self.y = 0
    self.rotation = 0
    self.scaleX = 1
    self.scaleY = 1
    self.originX = 0.5
    self.originY = 0.5
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


function Sprite:draw()
    if self.visible and self.opacity > 0 and self.currentTexture ~= nil then
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
end