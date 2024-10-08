local wezterm = require('wezterm')
local platform = require('utils.platform')

-- Set my font config
local fonts = {
   'FantasqueSansM Nerd Font',
   'FiraCode Nerd Font',
   'STBaoliSC',
   'MLingWaiMedium-SC',
   'PingFang',
}
local font_size = platform().is_mac and 17 or 10

return {
   font = wezterm.font_with_fallback(fonts),
   font_size = font_size,
   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Light', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Light', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
