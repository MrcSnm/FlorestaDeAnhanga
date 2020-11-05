
function rectContainsPoint(pX, pY, rX, rY, rW, rH)
    if(type(rX) == 'table') then
        return rectContainsPoint(pX, pY, rX.x, rX.y, rX.width, rX.height)
    else
        -- print("PX: " .. pX .. ' PY:' .. pY .. " RX: " .. rX .. " RY: " .. rY .. " RW: " .. rW .. " RH:" .. rH)
        return pX >= rX and pX <= rX + rW and pY >= rY and pY <= rY + rH
    end
end


function rectIntersectsRect(rec1, rec2)

    local overlapsX = rec1.x + rec1.width >= rec2.x and rec2.x + rec2.width >= rec1.x
    local overlapsY = rec1.y + rec1.height >= rec2.y and rec2.y + rec2.height >= rec1.y

    return (overlapsX and overlapsY)
end

--Fast ignores the sqrt, useful only for comparison, not real distance
function getDistanceFastPoint(x1, y1, x2, y2)
    local xD = x1 - x2
    local yD = y1 - y2
    return xD*xD + yD * yD
end

function getDistanceFast(obj1, obj2)
    return getDistanceFastPoint(obj1.x,obj1.y, obj2.x, obj2.y) 
end