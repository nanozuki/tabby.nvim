local lines = {}

local api = require('tabby.module.api')
local highlight = require('tabby.module.highlight')
local tabwins = require('tabby.feature.tabwins')

---TabbyLine gathering all you need in configure nvim lines
---@class TabbyLine
---@field tabs fun():TabbyTabs return all tabs
---@field wins fun():TabbyWins return all wins
---@field wins_in_tab fun(tabid:number):TabbyWins return all wins in that tab
---@field sep fun(symbol:string, cur_hl:TabbyHighlight, back_hl:TabbyHighlight):TabbyNode make a separator
---@field spacer fun():TabbyNode Separation point between alignment sections. Each section will be separated by an equal number of spaces.
---@field api TabbyAPI neovim apis wrapper

---@param hl TabbyHighlight
---@return TabbyHighlightObject
local function ensure_hl_obj(hl)
  if type(hl) == 'string' then
    return highlight.extract(hl)
  end
  return hl
end

---@type TabbyLine
local line = {
  tabs = tabwins.new_tabs,
  wins = function()
    return tabwins.new_wins(api.get_wins())
  end,
  wins_in_tab = function(tabid)
    return tabwins.new_wins(api.get_tab_wins(tabid))
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
  api = api,
}

---get line object
---@return TabbyLine
function lines.get_line()
  -- If we need some pre,post hooks, can be add here.
  -- So I wrap line object in a function
  return line
end

return lines
