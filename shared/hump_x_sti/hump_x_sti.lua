local lg = love.graphics
function hump_x_sti_renderTopLayers(topLayers, originalMap, camera)
    local current_canvas = lg.getCanvas()
    lg.setCanvas(originalMap.canvas)
	lg.clear()

	-- Scale map to 1.0 to draw onto canvas, this fixes tearing issues
	-- Map is translated to correct position so the right section is drawn
	lg.push()
	lg.origin()
	lg.translate(math.floor(-camera.x or 0), math.floor(-camera.y or 0))

    for i, v in ipairs(topLayers) do
        if(v.opacity > 0) then
            v:draw()
        end
    end

	lg.pop()

	-- Draw canvas at 0,0; this fixes scissoring issues
	-- Map is scaled to correct scale so the right section is shown
	lg.push()
	lg.origin()
	lg.scale(camera.scale or 1, camera.scale or 1)

	lg.setCanvas(current_canvas)
	lg.draw(originalMap.canvas)
	lg.pop()
end