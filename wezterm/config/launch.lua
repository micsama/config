local platform = require('utils.platform')()

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'pwsh' }
   options.launch_menu = {
      { label = 'PowerShell Core', args = { 'pwsh' } },
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd' } },
      {
         label = 'Git Bash',
         args = { 'C:\\Users\\12466\\scoop\\apps\\git\\current\\bin\\bash.exe' },
      },
   }
elseif platform.is_mac then
   options.default_prog = { '/opt/homebrew/bin/nu' }
   options.launch_menu = {
      --{ label = 'Fish', args = { '/opt/homebrew/bin/fish' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash' } },
      { label = 'Fish', args = { 'fish' } },
   }
end

return options
