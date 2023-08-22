--
-- require the `mods` module to gain access to hooks, menu, and other utility
-- functions.
--

local mod = require 'core/mods'

-- This mod rotates the grid.

local rotation = 0
local rotation_name = {"0", "90", "180", "270"}
local device_id = 2

local m = {}

local m.grid_connect = grid.connect
function grid.connect(d)
  if d == nil then
    d = 1
  end
  m.grid_connect(d)
  device_id = d + 1
  grid.rotation(grid.device[device_id], rotation)
end


m.key = function(n, z)
  if n == 2 and z == 1 then
    -- return to the mod selection menu
    mod.menu.exit()
  end
end

m.enc = function(n, d)
  if n == 3 then
    rotation = util.clamp(rotation + d, 0, 3)
  end
  m.redraw()
end

m.redraw = function()
  screen.clear()
  screen.move(64,40)
  screen.text_center("rotation: " .. rotation_name[rotation+1])
  screen.update()
end

m.init = function() end -- on menu entry, ie, if you wanted to start timers
m.deinit = function() 
  screen.clear()
end -- on menu exit

-- register the mod menu
--
-- NOTE: `mod.this_name` is a convienence variable which will be set to the name
-- of the mod which is being loaded. in order for the menu to work it must be
-- registered with a name which matches the name of the mod in the dust folder.
--
mod.menu.register(mod.g_rotate, m)


--
-- [optional] returning a value from the module allows the mod to provide
-- library functionality to scripts via the normal lua `require` function.
--
-- NOTE: it is important for scripts to use `require` to load mod functionality
-- instead of the norns specific `include` function. using `require` ensures
-- that only one copy of the mod is loaded. if a script were to use `include`
-- new copies of the menu, hook functions, and state would be loaded replacing
-- the previous registered functions/menu each time a script was run.
--
-- here we provide a single function which allows a script to get the mod's
-- state table. using this in a script would look like:
--
-- local mod = require 'name_of_mod/lib/mod'
-- local the_state = mod.get_state()
--
local api = {}

api.get_rotation = function()
  return rotation
end

api.set_rotation = function(r)
  rotation = r
end

return api