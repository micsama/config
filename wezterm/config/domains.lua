local platform = require('utils.platform')()
local domains = {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {
      {
         name = 'pc1',
         multiplexing = 'WezTerm',
         remote_address = '192.168.31.110',
         username = 'dzmfg',
         ssh_option = {
            identityfile = '~/.ssh/id_rsa',
         },
      },
      {
         name = 'pc',
         multiplexing = 'WezTerm',
         remote_address = '101.43.77.85:6000',
         username = 'dzmfg',
         ssh_option = {
            identityfile = '~/.ssh/id_rsa',
         },
      },
   },

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {},
}
if platform.is_win then
   table.insert(domains.wsl_domains, {
      {
         name = 'WSL:Ubuntu',
         distribution = 'Ubuntu',
         username = 'dzmfg',
         default_cwd = '/home/dzmfg',
         default_prog = { 'fish' },
      },
   })
end
return domains
