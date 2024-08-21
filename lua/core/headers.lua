-- NOTE: NvDash Headers
math.randomseed(os.time())
local headers = {
  mg = {
    "      +++++++       xxxxxxx      xxxxxxx",
    "      +:::::+        x:::::x    x:::::x ",
    "      +:::::+         x:::::x  x:::::x  ",
    "+++++++:::::+++++++    x:::::xx:::::x   ",
    "+:::::::::::::::::+     x::::::::::x    ",
    "+:::::::::::::::::+     x::::::::::x    ",
    "+++++++:::::+++++++    x:::::xx:::::x   ",
    "      +:::::+         x:::::x  x:::::x  ",
    "      +:::::+        x:::::x    x:::::x ",
    "      +++++++       xxxxxxx      xxxxxxx",
  },

  nvim = {
    "                                                    ",
    " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  },
  arch = {
    "                    ▄                   ",
    "                   ▟█▙                  ",
    "                  ▟███▙                 ",
    "                 ▟█████▙                ",
    "                ▟███████▙               ",
    "               ▂▔▀▜██████▙              ",
    "              ▟██▅▂▝▜█████▙             ",
    "             ▟█████████████▙            ",
    "            ▟███████████████▙           ",
    "           ▟█████████████████▙          ",
    "          ▟███████████████████▙         ",
    "         ▟█████████▛▀▀▜████████▙        ",
    "        ▟████████▛      ▜███████▙       ",
    "       ▟█████████        ████████▙      ",
    "      ▟██████████        █████▆▅▄▃      ",
    "     ▟██████████▛        ▜█████████▙    ",
    "    ▟██████▀▀▀              ▀▀██████▙   ",
    "   ▟███▀▘                       ▝▀███▙  ",
    "  ▟▛▀                               ▀▜▙ ",
  },
  pacman = {
    "                                    ",
    "               ██████               ",
    "           ████▒▒▒▒▒▒████           ",
    "         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██         ",
    "       ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██       ",
    "     ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒         ",
    "     ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓     ",
    "     ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓     ",
    "   ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██   ",
    "   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██   ",
    "   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██   ",
    "   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██   ",
    "   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██   ",
    "   ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██   ",
    "   ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██   ",
    "   ██      ██      ████      ████   ",
  },
}

return headers