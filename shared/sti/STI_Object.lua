STI_Object = Class"STI_Object"


function STI_Object:initialize(map, name)
    self.mapRef = map;
    self.objRef = findObject(map, name)
    self.name = name
end