function findObject(map, objName)
    local obj = nil
    for k, object in pairs(map.objects) do
        if object.name == objName then
            obj = object
            break
        end
    end

    return obj
end

function separateLayer(map, layerName)
    local ret = map.layers[layerName]
    assert(ret ~= nil, "Layer named '"..layerName.." does not exists!")
    ret.visible = false --Don't render at STI
    return ret
end

function getCollisionLayers(map, collisionArray)
    local col = {}
    for _, v in ipairs(collisionArray) do
        table.insert(col, map.layers[v])
    end
    return col
end