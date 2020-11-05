STI_Object = Class{}


function STI_Object:init(map, name)
    self.mapRef = map;
    self.objRef = findObject(map, name)
    self.name = name
end