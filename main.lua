local sti = require "external.simple_tiled_implementation.sti"

Class = require "shared.class"
push = require "shared.push"
require "shared.slam"
require "globals"

GAME_MAP = nil

function love.load()

    GAME_MAP = sti(GAME_MAP_NAME)
end

function love.update(dt)

    GAME_MAP:update(dt)

end

function love.draw()

    GAME_MAP:draw()

end