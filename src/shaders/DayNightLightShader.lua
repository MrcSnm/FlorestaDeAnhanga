DayNightLightShader = Class("DayNightLightShader", LightingShader)


function DayNightLightShader:initialize(cam, map)
    LightingShader.initialize(self, cam, map)
    self.daynight = DayNightShader()

    self.shader = Assets.getShader("day_night_light.fs")
    self.daynight.shader = self.shader
end


function DayNightLightShader:sendVars()
    self:setupVariables()
    self.daynight:setColors()
end


function DayNightLightShader:draw(drawFunc)
    self.daynight.time = self.daynight.time + 0.05
    self:sendVars()
    love.graphics.setCanvas(self.daynight.framebuffer)
    love.graphics.clear()
        drawFunc()
    love.graphics.setCanvas()
    love.graphics.setShader(self.shader)
        love.graphics.draw(self.daynight.framebuffer)
    love.graphics.setShader()

end