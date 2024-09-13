local api = {}

---Tabby API is some useful neovim api's wrapper
---@class TabbyAPI
---@field get_tabs fun():number[] return all tab ids
---@field get_tab_wins fun(tabid:number):number[] get windows in the tab
---@field get_current_tab fun():number get current tab
---@field get_tab_current_win fun(tabid):number get tab's current win
---@field get_tab_number fun(tabid):number get tab's number
---@field get_wins fun():number[] get all windows, except floating window
---@field get_win_tab fun(winid):number get tab of this win
---@field is_float_win fun(winid:number):boolean return true if this window is floating
---@field is_not_float_win fun(winid:number):boolean return true if this window is not floating
---@field get_bufs fun():number[] get all listed buffers
---@field get_win_buf fun(winid:number):number get buffer of this window
---@field get_buf_type fun(bufid:number):string get buffer type
---@field get_buf_is_changed fun(bufid:number):boolean get buffer is changed

function api.get_tabs()
  return vim.api.nvim_list_tabpages()
end

function api.get_tab_wins(tabid)
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  return vim.tbl_filter(api.is_not_float_win, wins)
end

function api.get_current_tab()
  return vim.api.nvim_get_current_tabpage()
end

function api.get_tab_current_win(tabid)
  return vim.api.nvim_tabpage_get_win(tabid)
end

function api.get_tab_number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

function api.get_wins()
  local wins = vim.api.nvim_list_wins()
  return vim.tbl_filter(api.is_not_float_win, wins)
end

function api.get_win_tab(winid)
  return vim.api.nvim_win_get_tabpage(winid)
end

function api.is_float_win(winid)
  return vim.api.nvim_win_get_config(winid).relative ~= ''
end

function api.is_not_float_win(winid)
  return vim.api.nvim_win_get_config(winid).relative == ''
end

function api.get_bufs()
  local bufinfo = vim.fn.getbufinfo()
  local bufs = {}
  for _, buf in ipairs(bufinfo) do
    if vim.api.nvim_buf_is_valid(buf.bufnr) and buf.listed == 1 then
      bufs[#bufs + 1] = buf.bufnr
    end
  end
  return bufs
end

function api.get_win_buf(winid)
  return vim.api.nvim_win_get_buf(winid)
end

function api.get_buf_type(bufid)
  if vim.fn.has('nvim-0.10') == 1 then
    local buf_number = vim.fn.bufnr(bufid)
    return vim.api.nvim_get_option_value('buftype', { buf = buf_number })
  else
    ---@diagnostic disable-next-line: deprecated
    return vim.api.nvim_buf_get_option(bufid, 'buftype')
  end
end

function api.get_buf_is_changed(bufid)
  return vim.fn.getbufinfo(bufid)[1].changed == 1
end

---@type TabbyAPI
return api
