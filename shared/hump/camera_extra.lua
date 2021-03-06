-- Provides functionalities for hump camera

function cam_lockX(cam, x)
    cam.targetX = math.floor(x)
    cam:lockX(cam.targetX)
end

function cam_lockY(cam, y)
    cam.targetY = math.floor(y)
    cam:lockY(cam.targetY)
end

function cam_getTop(cam, h)
    h = h or love.graphics.getHeight()
    return cam.y - h/(2*cam.scale)
end

function cam_getBottom(cam, h)
    h = h or love.graphics.getHeight()
    return cam.y + h/(2*cam.scale)
end

function cam_getLeft(cam, w)
    w = w or love.graphics.getWidth()
    return cam.x - w/(2*cam.scale)
end

function cam_getRight(cam, w)
    w = w or love.graphics.getWidth()
    return cam.x + w/(2*cam.scale)
end