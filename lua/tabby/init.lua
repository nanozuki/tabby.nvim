local component = require('tabby.component')
local filename = require('tabby.filename')
local config = require('tabby.config')
local tabline = require('tabby.tabline')
local util = require('tabby.util')

local tabby = {}

---@type nil|TabbyConfig
local tabby_opt = nil

---@param cfg? TabbyConfig
function tabby.setup(cfg)
  tabby_opt = vim.tbl_extend('force', config.defaults, cfg or {})

  vim.cmd([[
  augroup tabby_show_control
    autocmd!
    autocmd TabNew,TabClosed * lua require("tabby").show_tabline()
  augroup end
  ]])

  if vim.api.nvim_get_vvar('vim_did_enter') then
    tabby.init()
  else
    vim.cmd("au VimEnter * lua require'tabby'.init()")
  end
end

function tabby.init()
  tabby.show_tabline()
  vim.o.tabline = '%!TabbyTabline()'
end

function tabby.show_tabline()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs >= tabby_opt.opt.show_at_least then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end

function tabby.update()
  filename.flush_unique_name_cache()
  if tabby_opt.components ~= nil then
    local components = tabby_opt.components()
    return table.concat(vim.tbl_map(component.render, components), '')
  elseif tabby_opt.tabline ~= nil then
    return tabline.render(tabby_opt.tabline)
  else
    return tabline.render(config.defaults)
  end
end

function tabby.tab_rename(name)
  local tabid = vim.api.nvim_get_current_tabpage()
  util.set_tab_name(tabid, name)
  vim.o.tabline = '%!TabbyTabline()'
end
vim.cmd([[command! -nargs=1 TabRename lua require('tabby').tab_rename(<f-args>)]])

function tabby.handle_buf_click()
  -- do nothing at now, only recording the sign for function
  -- function tabby.handle_buf_click(minwid, clicks, button, modifier)
  -- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
