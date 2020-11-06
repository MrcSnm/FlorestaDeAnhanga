STI_Object = Class"STI_Object"


function STI_Object:initialize(map, name)
    self.mapRef = map;
    self.objRef = findObject(map, name)
    assert(self.objRef ~= nil, "Tiled Object named '"..name.."' not found on map")
    self.name = name

    self.x = self.objRef.y
    self.y = self.objRef.y
end