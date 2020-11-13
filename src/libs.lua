-- Externals
sti = require "external.simple_tiled_implementation.sti"
bump = require "external.bump.bump"
tween = require "external.tween.tween"

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

--Tweening

require "shared.tweening.Action"
require "shared.tweening.ActionManager"
require "shared.tweening.ActionSequence"
require "shared.tweening.ActionSpawn"
require "shared.tweening.mov_actions"
require "shared.tweening.tint_actions"
require "shared.tweening.ActionCallback"
require "shared.tweening.ActionDelay"

--Hump
require "shared.hump.camera_extra"

--Hump X Sti

require "shared.hump_x_sti.hump_x_sti"


--Others
require "shared.default"
require "shared.Assets"
require "shared.Timer"
require "shared.collision"
push = require "shared.push"

require "shared.state.State"
require "shared.state.StateMachine"
--  require "shared.slam"



--Sources
require "src.globals"
require "src.Player"
require "src.Animal"
require "src.AnimalSpawner"

require "src.shaders.DayNightShader"
require "src.shaders.LightingShader"
require "src.shaders.DayNightLightShader"


require "src.Interface"
require "src.Menu"

require "src.states.MainState"
require "src.states.MenuState"