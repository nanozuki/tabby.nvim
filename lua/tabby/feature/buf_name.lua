local FileNameResolver = require('tabby.module.file_name_resolver')
local api = require('tabby.module.api')

local buf_name = {}

---@class TabbyBufNameOption
---@field mode? TabbyFileNameMode @default unique
---@field name_fallback? fun(bufid:number):string
---@field override? fun(bufid:number):string?

---@type TabbyBufNameOption
local default_option = {
  mode = 'unique',
  name_fallback = function(_)
    return '[No Name]'
  end,
}

function buf_name.set_default_option(opt)
  default_option = vim.tbl_deep_extend('force', default_option, opt)
end

local resolver = FileNameResolver:new({
  get_name = function(bufid)
    return vim.api.nvim_buf_get_name(bufid)
  end,
  get_names = function()
    local buf = api.get_bufs()
    local names = {}
    for _, bufid in ipairs(buf) do
      names[bufid] = vim.api.nvim_buf_get_name(bufid)
    end
    return names
  end,
})

vim.api.nvim_create_autocmd({ 'WinNew', 'WinClosed', 'BufWinEnter', 'BufWinLeave', 'BufDelete' }, {
  pattern = '*',
  callback = function()
    resolver:flush()
  end,
})

function buf_name.flush_cache()
  resolver:flush()
end

---get buf name
---@param bufid number
---@param opt? TabbyBufNameOption
---@return string
function buf_name.get_by_bufid(bufid, opt)
  local o = vim.tbl_deep_extend('force', default_option, opt or {})
  if o.override then
    local name = o.override(bufid)
    if name then
      return name
    end
  end
  return resolver:get_name(bufid, o.mode, o.name_fallback)
end

---get buf name by winid, compatible with old version
---@param winid number
---@param opt? TabbyBufNameOption
function buf_name.get(winid, opt)
  local bufid = vim.api.nvim_win_get_buf(winid)
  return buf_name.get_by_bufid(bufid, opt)
end

return buf_name
