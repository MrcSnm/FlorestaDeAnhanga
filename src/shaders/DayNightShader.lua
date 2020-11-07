DayNightShader = Class("DayNightShader")


function DayNightShader:initialize()
    
    self.time = 8
    self.firstColor = nil
    self.secondColor = nil




    self.midnightColor = {0.05,0.3,0.8,1}
    self.earlyMorningColor = {0.95,0.9,0.8,1}
    self.lateAfternoonColor = {0.85,0.8,0.9,1}


    self.framebuffer = love.graphics.newCanvas()
    self.shader = Assets.getShader("day_night.fs")
    self:setColors()
end

function DayNightShader:getColor(t)
    if isInRange(0, 0.25, t) then
        return self.midnightColor
    elseif isInRange(0.25, 0.50, t) then
        return self.earlyMorningColor
    elseif isInRange(0.50, 0.75, t) then
        return self.lateAfternoonColor
    else
        return self.midnightColor
    end
end

function DayNightShader:setColors()

    local firstTimeToSend = (self.time%24) / 24

    local colorsThreshold = 1/4
    local secondTimeToSend = (firstTimeToSend + 1 / 4) % 1 --4 because we are using 4 colors, % 1 for clamp

    --Every 0.25 multiple will be = 1
    local ratio = (firstTimeToSend%colorsThreshold) / colorsThreshold


    --Sets colors based in ranges
    self.firstColor = self:getColor(firstTimeToSend)
    self.secondColor = self:getColor(secondTimeToSend)


    --Shader will mix those colors
    self.shader:send("FIRST_COLOR", self.firstColor)
    self.shader:send("SECOND_COLOR", self.secondColor)
    self.shader:send("RATIO", ratio)

end


function DayNightShader:draw(drawFunc)
    
    --love.graphics.setCanvas(self.canvas)
    --self.time = self.time + 0.1
    self:setColors()
    love.graphics.setShader(self.shader)
    drawFunc()
    --love.graphics.setCanvas()
    --love.graphics.draw(self.canvas)
    love.graphics.setShader()

end