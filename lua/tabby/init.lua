local component = require('tabby.component')
local config = require('tabby.config')
local util = require('tabby.util')

---@class TabbyModule
---@field tabline_renderer fun():Node
local tabby = {
  -- lines
  tabline = require('tabby.tabline'),
  -- modules
  tab = require('tabby.tab'),
  win = require('tabby.win'),
}

-- [[
--
-- Deprecated Area
--
-- ]

---@type nil|TabbyConfig
local tabby_opt = nil

---@deprecated this function is deprecated, please use tabby.tabline.set
---@param cfg? TabbyConfig
function tabby.setup(cfg)
  tabby_opt = vim.tbl_extend('force', config.defaults, cfg or {})
  vim.cmd([[
  augroup tabby_show_control
    autocmd!
    autocmd TabNew,TabClosed * lua require("tabby.tabline").show_control()
  augroup end
  ]])
  if vim.api.nvim_get_vvar('vim_did_enter') then
    tabby.init()
  else
    vim.cmd("au VimEnter * lua require'tabby'.init()")
  end
end

function tabby.init()
  require('tabby.tabline').show_control()
  vim.o.tabline = '%!TabbyTabline()'
end

function tabby.update()
  tabby_opt = tabby_opt or config.defaults
  if tabby_opt.components ~= nil then
    local components = tabby_opt.components()
    return table.concat(vim.tbl_map(component.render, components), '')
  elseif tabby_opt.tabline ~= nil then
    return tabby.tabline.legacy_render(tabby_opt.tabline)
  else
    return tabby.tabline.legacy_render(config.defaults)
  end
end

function tabby.tab_rename(name)
  local tabid = vim.api.nvim_get_current_tabpage()
  util.set_tab_name(tabid, name)
end
vim.cmd([[command! -nargs=1 TabRename lua require('tabby').tab_rename(<f-args>)]])

function tabby.handle_buf_click()
  -- do nothing at now, only recording the sign for function
  -- function tabby.handle_buf_click(minwid, clicks, button, modifier)
  -- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
