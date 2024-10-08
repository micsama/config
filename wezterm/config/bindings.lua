local wezterm = require('wezterm')
local platform = require('utils.platform')()
--local backdrops = require('utils.backdrops')
local nvim = require('utils.nvim')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.copysuper = 'SUPER'
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

local keys = {
   { key = 'q', mods = 'SUPER', action = act.QuitApplication },
   { key = 'h', mods = 'CMD', action = wezterm.action.HideApplication },
   nvim.bind_super_key_to_vim('s'),
   nvim.bind_super_key_to_vim('/'),
   nvim.bind_super_key_to_vim('j'),
   --
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowTabNavigator },
   { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },
   { key = 'f', mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },

   -- copy/paste --
   { key = 'c', mods = mod.copysuper, action = act.CopyTo('Clipboard') },
   { key = 'v', mods = mod.copysuper, action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't', mods = mod.SUPER, action = act.SpawnTab('DefaultDomain') },
   --这里应该修改,不要ubuntu
   { key = 't', mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'pc' }) },
   { key = 'w', mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = '[', mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
   { key = ']', mods = mod.SUPER, action = act.ActivateTabRelative(1) },
   { key = '[', mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']', mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   { key = 'n', mods = mod.SUPER, action = act.SpawnWindow },

   -- background picture controls --
   -- {
   --    key = [[/]],
   --    mods = mod.SUPER_REV,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:random(window)
   --    end),
   -- },
   -- {
   --    key = [[,]],
   --    mods = mod.SUPER_REV,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:cycle_back(window)
   --    end),
   -- },
   -- {
   --    key = [[.]],
   --    mods = mod.SUPER_REV,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:cycle_forward(window)
   --    end),
   -- },

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'z', mods = mod.SUPER_REV, action = act.TogglePaneZoomState },
   { key = 'w', mods = mod.SUPER, action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   { key = 'k', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

-- tabs: activate 1-9 tabs
for i = 1, 8 do
   table.insert(keys, {
      key = tostring(i),
      mods = mod.SUPER,
      action = act.ActivateTab(i - 1),
   })
end

local key_tables = {
   resize_font = {
      { key = 'k', action = act.IncreaseFontSize },
      { key = 'j', action = act.DecreaseFontSize },
      { key = 'r', action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q', action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q', action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = mod.SUPER,
      action = act.OpenLinkAtMouseCursor,
   },
}
local function is_vim(pane)
   local is_vim_env = pane:get_user_vars().IS_NVIM == 'true'
   if is_vim_env == true then
      return true
   end
   -- This gsub is equivalent to POSIX basename(3)
   -- Given "/foo/bar" returns "bar"
   -- Given "c:\\foo\\bar" returns "bar"
   local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
   return process_name == 'nvim' or process_name == 'vim'
end

local super_vim_keys_map = {
   s = utf8.char(0xAA),
   x = utf8.char(0xAB),
   b = utf8.char(0xAC),
   ['.'] = utf8.char(0xAD),
   o = utf8.char(0xAF),
}

local function bind_super_key_to_vim(key)
   return {
      key = key,
      mods = 'CMD',
      action = wezterm.action_callback(function(win, pane)
         local char = super_vim_keys_map[key]
         if char and is_vim(pane) then
            -- pass the keys through to vim/nvim
            win:perform_action({
               SendKey = { key = char, mods = nil },
            }, pane)
         else
            win:perform_action({
               SendKey = {
                  key = key,
                  mods = 'CMD',
               },
            }, pane)
         end
      end),
   }
end
return {
   disable_default_key_bindings = true,
   leader = { key = 'Space', mods = 'CTRL|SHIFT' },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
