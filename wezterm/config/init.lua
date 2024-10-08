local wezterm = require('wezterm')

---@class Config
---@field options table
local Config = {}

---Initialize Config
---@return Config
function Config:init()
   self.__index = self
   local config = setmetatable({ options = {} }, self)
   return config
end

---Append to `Config.options`
---@param new_options table new options to append
---@return Config
function Config:append(new_options)
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         wezterm.log_warn(
            'Duplicate config option detected: ',
            { old = self.options[k], new = new_options[k] }
         )
         goto continue
      end
      self.options[k] = v
      ::continue::
   end
   return self
end
local platform = require('utils.platform')()
if platform.is_linux then
  Config.enable_wayland = true
end

return Config