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


function hump_x_sti_showCamBounds(cam, map)
	
	local x = cam.x
	local y = cam.y
	local w = love.graphics.getWidth()/cam.scale
	local h = love.graphics.getHeight()/cam.scale

	x = x-w/2
	y = y-h/2

	local r,g,b,a =love.graphics.getColor()

	cam:attach()
		love.graphics.setColor(0,1,0,1)
		love.graphics.print("Camera Top: "..tostring(math.floor		(y)), 		x, y)
		love.graphics.print("Camera Left: "..tostring(math.floor	(x)), 		x, y+20)
		love.graphics.print("Camera Bottom: "..tostring(math.floor	(y)+h),		x, y+40)
		love.graphics.print("Camera Right: "..tostring(math.floor	(x)+w), 	x, y+60)

		love.graphics.setColor(1,0,0,1)

		love.graphics.setPointSize(10)
		love.graphics.points(x, y+h/2, --Left
							x+w/2,y, --Top
							x+w, y+h/2, --Right
							x+w/2, y+h) --Bottom

		love.graphics.setColor(r,g,b,a)
    cam:detach()

end