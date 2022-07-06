---get terminal color
---@param index number color index
---@param fallback string neovim native color value
---@return string
local function get_color(index, fallback)
  return vim.g['terminal_color_' .. index] or fallback
end

local colors = {
  black = get_color(0, 'Black'),
  red = get_color(1, 'Red'),
  green = get_color(2, 'Green'),
  yellow = get_color(3, 'Yellow'),
  blue = get_color(4, 'Blue'),
  magenta = get_color(5, 'Magenta'),
  cyan = get_color(6, 'Cyan'),
  white = get_color(7, 'White'),
  bright_black = get_color(8, 'DarkGrey'),
  bright_red = get_color(9, 'LightRed'),
  bright_green = get_color(10, 'LightGreen'),
  bright_yellow = get_color(11, 'LightYellow'),
  bright_blue = get_color(12, 'LightBlue'),
  bright_magenta = get_color(13, 'LightMagenta'),
  bright_cyan = get_color(14, 'LightCyan'),
  bright_white = get_color(15, 'LightGray'),
}

return colors
