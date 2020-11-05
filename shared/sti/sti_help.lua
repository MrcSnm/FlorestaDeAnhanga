function findObject(map, objName)
    local obj = nil
    for k, _obj in pairs(map.objects) do
        if (_obj.name == objName) then
            obj = _obj;
            break;
        end
    end
    return obj
end