DayNightShader = Class("DayNightShader")


function DayNightShader:initialize()
    
    self.time = 8
    self.firstColor = nil
    self.secondColor = nil




    self.midnightColor =        {0.05,0.2,0.5,1}
    self.earlyMorningColor =    {0.95,0.9,0.85,1}
    self.lateAfternoonColor =   {0.85,0.8,0.9,1}

    --Contrast, saturation and brightness

    self.midnightCBS =      {0.40,  0.6,    0.0}
    self.earlyMorningCBS =  {1.10,  0.9,    0.1}
    self.lateAfternoonCBS = {1.40,  1.1,   0.05}

    --Highlight strength and highlight threshold
    self.midnightHighlight =        {5.5, 0.5}
    self.earlyMorningHighlight =    {0.8,   1}
    self.lateAfternoonHighlight =   {0.0,   1}


    self.keyTimes = {}
    self.keyTimesCBS = {}
    self.keyHighlights = {}

    table.insert(self.keyTimes, self.midnightColor)
    table.insert(self.keyTimes, self.earlyMorningColor)
    table.insert(self.keyTimes, self.lateAfternoonColor)

    table.insert(self.keyTimesCBS, self.midnightCBS)
    table.insert(self.keyTimesCBS, self.earlyMorningCBS)
    table.insert(self.keyTimesCBS, self.lateAfternoonCBS)

    
    table.insert(self.keyHighlights, self.midnightHighlight)
    table.insert(self.keyHighlights, self.earlyMorningHighlight)
    table.insert(self.keyHighlights, self.lateAfternoonHighlight)


    self.framebuffer = love.graphics.newCanvas()
    self.shader = Assets.getShader("day_night.fs")
    self:setColors()
end

function DayNightShader:getColor(t)
    local thresholdForNext = 1/#self.keyTimes

    local ret =math.floor(t / thresholdForNext)
    return ret > 0 and ret or 1
end

function DayNightShader:setColors()

    --Base time
    local firstTimeToSend = (self.time%24) / 24

    local colorsThreshold = 1/#self.keyTimes
    --Next time is current + threshold
    local secondTimeToSend = (firstTimeToSend + colorsThreshold) % 1 --4 because we are using 4 colors, % 1 for clamp

    --Every 0.25 multiple will be = 1
    local ratio = (firstTimeToSend%colorsThreshold) / colorsThreshold


    --Sets colors based in ranges
    self.firstColor = self:getColor(firstTimeToSend)
    self.secondColor = self:getColor(secondTimeToSend)

    --Send premixed colors
    self.shader:send("COLOR_MIX", lerp4(self.keyTimes[self.firstColor], self.keyTimes[self.secondColor], ratio))
    self.shader:send("CONSTRAST_BRIGHTNESS_SATURATION", lerp3(self.keyTimesCBS[self.firstColor], self.keyTimesCBS[self.secondColor], ratio))
    self.shader:send("HIGHLIGHT", lerp2(self.keyHighlights[self.firstColor], self.keyHighlights[self.secondColor], ratio))
end


function DayNightShader:draw(drawFunc)
    
    self.time = self.time + 0.05
    self:setColors()
    love.graphics.setCanvas(self.framebuffer)
        drawFunc()
    love.graphics.setCanvas()

   love.graphics.setShader(self.shader)
        love.graphics.draw(self.framebuffer)
   love.graphics.setShader()

end