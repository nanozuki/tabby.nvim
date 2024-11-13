local lines = {}

local api = require('tabby.module.api')
local highlight = require('tabby.module.highlight')
local tabs = require('tabby.feature.tabs')
local wins = require('tabby.feature.wins')
local bufs = require('tabby.feature.bufs')

---TabbyLine gathering all you need in configure nvim lines
---@class TabbyLine
---@field tabs fun():TabbyTabs return all tabs
---@field wins fun():TabbyWins return all wins
---@field wins_in_tab fun(tabid:number):TabbyWins return all wins in that tab
---@field bufs fun():TabbyBufs return all bufs
---@field sep fun(symbol:string,cur_hl:TabbyHighlight,back_hl:TabbyHighlight):TabbyNode make a separator
---@field spacer fun():TabbyNode Separation point between alignment sections. Each section will be separated by an equal number of spaces.
---@field truncate_point fun():TabbyNode Where to truncate line if too long. Default is at the start. Only first point will be active.
---@field api TabbyAPI neovim apis wrapper

---@param hl TabbyHighlight
---@return TabbyHighlightObject
local function ensure_hl_obj(hl)
  if type(hl) == 'string' then
    return highlight.extract(hl)
  end
  return hl
end

---@class TabbyLineOption
---@field tab_name? TabbyTabNameOption
---@field buf_name? TabbyBufNameOption

---get line object
---@param opt? TabbyLineOption
---@return TabbyLine
function lines.get_line(opt)
  opt = opt or {}
  ---@type TabbyLine
  local line = {
    tabs = function()
      local ts = vim.tbl_map(function(tabid)
        return tabs.new_tab(tabid, opt)
      end, api.get_tabs())
      return tabs.new_tabs(ts, opt)
    end,
    wins = function()
      local ws = vim.tbl_map(function(winid)
        return wins.new_win(winid, opt)
      end, api.get_wins())
      return wins.new_wins(ws, opt)
    end,
    wins_in_tab = function(tabid)
      local ws = vim.tbl_map(function(winid)
        return wins.new_win(winid, opt)
      end, api.get_tab_wins(tabid))
      return wins.new_wins(ws, opt)
    end,
    bufs = function()
      local bs = vim.tbl_map(function(bufid)
        return bufs.new_buf(bufid, opt)
      end, api.get_bufs())
      return bufs.new_bufs(bs, opt)
    end,
    sep = function(symbol, cur_hl, back_hl)
      local cur_hl_obj = ensure_hl_obj(cur_hl)
      local back_hl_obj = ensure_hl_obj(back_hl)
      return {
        symbol,
        hl = {
          fg = cur_hl_obj.bg,
          bg = back_hl_obj.bg,
        },
      }
    end,
    spacer = function()
      return '%='
    end,
    truncate_point = function()
      return '%<'
    end,
    api = api,
  }
  return line
end

return lines
