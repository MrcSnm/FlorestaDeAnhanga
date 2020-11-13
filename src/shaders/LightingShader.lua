LightingShader = Class("LightingShader")

LightingShader.static.Light =
{
    position = {},
    diffuse = {},
    power = 0,
    falloff = 1,
    minThreshold = 1,
    maxThreshold = 100
}

function LightingShader:initialize(camera, map)

    self.shader = Assets.getShader("lighting.fs")
    self.framebuffer = love.graphics.newCanvas()

    self.lightSources = {}

    self.camera = camera
    self.map = map
end

function LightingShader:removeLightSource(lightSource)
    local ind = -1
    for i, v in ipairs(self.lightSources) do
        if v == lightSource then ind = i end
    end

    if ind ~= -1 then
        table.remove(self.lightSources,  ind)
    end
end


function LightingShader:addLightSource(lightSource)

    assert(lightSource.position[1] and lightSource.position[2], "Could not find lightSource.position")
    assert(lightSource.diffuse[1] and lightSource.diffuse[2] and lightSource.diffuse[3], "Could not find lightSource.diffuse")
    assert(lightSource.power ~= nil, "Could not find lightSource.power")
    assert(lightSource.falloff ~= nil, "Could not find lightSource.falloff")
    assert(lightSource.maxThreshold ~= nil, "Could not find lightSource.maxThreshold")
    
    table.insert(self.lightSources, lightSource)
end

function LightingShader:sendLight(l, pos)
    self.shader:send("LIGHTS["..pos.."].position", l.position)
    self.shader:send("LIGHTS["..pos.."].diffuse", l.diffuse)
    self.shader:send("LIGHTS["..pos.."].power", l.power)
    self.shader:send("LIGHTS["..pos.."].falloff", l.falloff)
    self.shader:send("LIGHTS["..pos.."].maxThreshold", l.maxThreshold)
    self.shader:send("LIGHTS["..pos.."].minThreshold", l.minThreshold)
end

--Will firstly check if it is on the camera bounds
function LightingShader:setupVariables()
    self.shader:send("CAM_POSITION", {self.camera.x, self.camera.y})
    self.shader:send("CAM_SCALE", {self.camera.scale, self.camera.scale})
    self.shader:send("LIGHTS_COUNT", #self.lightSources)
    for i, v in ipairs(self.lightSources) do
        self:sendLight(v, i-1) --Starts at 0 on C
    end
end


function LightingShader:draw(drawFunction)
   -- love.graphics.setCanvas(self.framebuffer)
   love.graphics.setShader(self.shader)
    drawFunction()
    --love.graphics.setCanvas()

       love.graphics.draw(self.framebuffer)
   love.graphics.setShader()
end