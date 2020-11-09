-- Externals
sti = require "external.simple_tiled_implementation.sti"
Talkies = require "external.Talkies.talkies"
Camera = require "external.hump.camera"
Class = require "external.middleclass.middleclass"



-- Shareds
--The 'Class' will be ignored for now, testing new class library
-- Class = require "shared.class" --Global dependency for every implementation

--Graphics
require "shared.graphics.Animation" --Provides base implementation for playing with sprites
require "shared.graphics.Sprite"
require "shared.graphics.AnimatedSprite" --Provides base implementation for playing with sprites

--Sti
require "shared.sti.sti_help" --Provides sti help for finding objs
require "shared.sti.STI_Object" --Provides sti base class for objects
require "shared.sti.STI_SpriteObject" --Provides sti class for sprites
require "shared.sti.STI_AnimatedSpriteObject" --Provides sti class for sprites

--Hump
require "shared.hump.camera_extra"

--Others
require "shared.default"
require "shared.Assets"
push = require "shared.push"
require "shared.slam"



--Sources
require "src.globals"
require "src.Player"

require "src.shaders.DayNightShader"
require "src.shaders.LightingShader"