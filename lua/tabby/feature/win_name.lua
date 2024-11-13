local FileNameResolver = require('tabby.module.file_name_resolver')
local api = require('tabby.module.api')

local win_name = {}

---@type TabbyBufNameOption
local default_option = {
  mode = 'unique',
  name_fallback = function(_)
    return '[No Name]'
  end,
}

function win_name.set_default_option(opt)
  default_option = vim.tbl_deep_extend('force', default_option, opt)
end

local resolver = FileNameResolver:new({
  get_name = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    return vim.api.nvim_buf_get_name(bufid)
  end,
  get_names = function()
    local wins = api.get_wins()
    local names = {}
    for _, winid in ipairs(wins) do
      local bufid = vim.api.nvim_win_get_buf(winid)
      names[winid] = vim.api.nvim_buf_get_name(bufid)
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

---get buf name
---@param winid number
---@param opt? TabbyBufNameOption
---@return string
function win_name.get(winid, opt)
  local o = vim.tbl_deep_extend('force', default_option, opt or {})
  if o.override then
    local bufid = vim.api.nvim_win_get_buf(winid)
    local name = o.override(bufid)
    if name then
      return name
    end
  end
  return resolver:get_name(winid, o.mode, o.name_fallback)
end

return win_name
