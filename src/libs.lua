-- Externals
sti = require "external.simple_tiled_implementation.sti"
Talkies = require "external.Talkies.talkies"
Class = require "external.middleclass.middleclass"



-- Shareds
--The 'Class' will be ignored for now, testing new class library
-- Class = require "shared.class" --Global dependency for every implementation

--Sti
require "shared.sti.sti_help" --Provides sti help for finding objs
require "shared.sti.STI_Object" --Provides sti base class for objects

--Graphics
require "shared.graphics.AnimatedSprite" --Provides base implementation for playing with sprites

--Others
require "shared.default"
require "shared.Assets"
push = require "shared.push"
require "shared.slam"



--Sources
require "src.globals"
require "src.Player"