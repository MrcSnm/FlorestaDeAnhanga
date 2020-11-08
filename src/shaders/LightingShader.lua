LightingShader = Class("LightingShader")

LightingShader.static.Light =
{
    position = {},
    diffuse = {},
    power = 0
}

function LightingShader:initialize()

    self.shader = love.graphics.newShader(Assets.getShader("lighting.fs"))
    self.framebuffer = love.graphics.newCanvas()


    self.shader:send("SCREEN", {love.graphics.getWidth(), love.graphics.getHeight()})
    
    self.lightSources = {}
end


function LightingShader:addLightSource(lightSource)

    assert(lightSource.position[1] and lightSource.position[2], "Could not find lightSource.position")
    assert(lightSource.diffuse[1] and lightSource.diffuse[2] and lightSource.diffuse[3], "Could not find lightSource.diffuse")
    assert(lightSource.power ~= nil, "Could not find lightSource.power")
    
    table.insert(lightSources, lightSource)
end

function LightingShader:sendLight(l, pos)
    self.shader:send("LIGHTS["..pos.."].position", l.position)
    self.shader:send("LIGHTS["..pos.."].diffuse", l.diffuse)
    self.shader:send("LIGHTS["..pos.."].power", l.power)
end

function LightingShader:setupVariables()

    self.shader:send("LIGHTS_COUNT", #self.lightSources)
    self.shader:send("SCREEN", {love.graphics.getWidth(), love.graphics.getHeight()})
    for i, v in ipairs(self.lightSources) do
        self:sendLight(v, i-1) --Starts at 0 on C
    end
end


function LightingShader:draw(drawFunction)
    love.graphics.setCanvas(self.framebuffer)
        drawFunction()
    love.graphics.setCanvas()

    love.graphics.setShader(self.shader)
        love.graphics.draw(self.canvas)
    love.graphics.setShader()
end