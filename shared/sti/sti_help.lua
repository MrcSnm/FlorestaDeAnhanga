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