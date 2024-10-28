local component = require('tabby.legacy.component')
local config = require('tabby.legacy.config')
local tabline = require('tabby.legacy.tabline')
local tab_name = require('tabby.feature.tab_name')

local tabby = {}

---@type TabbyLegacyConfig
local tabby_opt = config.defaults

---@class TabbyConfig
---@field line? fun(line:TabbyLine):TabbyNode
---@field preset? 'active_wins_at_tail'|'active_wins_at_end'|'tab_with_top_win'|'active_tab_with_wins'|'tab_only'
---@field option? TabbyLineOption|TabbyTablinePresetOption

---@param cfg? table
local function is_legacy_config(cfg)
  return cfg ~= nil and (cfg.tabline ~= nil or cfg.components ~= nil or cfg.opt ~= nil)
end

---@param cfg? TabbyConfig|TabbyLegacyConfig
function tabby.setup(cfg)
  if is_legacy_config(cfg) then
    ---@cast cfg TabbyLegacyConfig
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
  else
    ---@cast cfg TabbyConfig
    local tbl = require('tabby.tabline')
    if cfg == nil or cfg.line == nil then
      cfg = vim.tbl_extend('force', { preset = 'active_wins_at_tail' }, cfg or {}) ---@type TabbyConfig
      ---@diagnostic disable-next-line: param-type-mismatch
      tbl.use_preset(cfg.preset, cfg.option)
    else
      tbl.set(cfg.line, cfg.option)
    end
  end
end

function tabby.init()
  tabby.show_tabline()
  vim.o.tabline = '%!TabbyTabline()'
  vim.cmd([[command! -nargs=1 TabRename lua require('tabby.feature.tab_name').set(0,<f-args>)]])
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
  if tabby_opt.components ~= nil then
    local components = tabby_opt.components()
    return table.concat(vim.tbl_map(component.render, components), '')
  elseif tabby_opt.tabline ~= nil then
    return tabline.render(tabby_opt.tabline)
  else
    return tabline.render(config.defaults.tabline)
  end
end

function tabby.tab_rename(name)
  tab_name.set(0, name)
end

function tabby.handle_buf_click()
  -- do nothing at now, only recording the sign for function
  -- function tabby.handle_buf_click(minwid, clicks, button, modifier)
  -- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
