Interface = Class("Interface")

function Interface:initialize(character)

    self.character = character
    self.currentAnimal = nil
end


function Interface:setCurrentAnimal(animal)
    self.currentAnimal = animal
end


function Interface:draw()
    if self.currentAnimal ~= nil then
        -- love.graphics.
    end
end