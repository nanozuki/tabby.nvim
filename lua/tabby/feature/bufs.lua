local M = {}
local api = require('tabby.module.api')

---@class TabbyBuf
---@field id number buffer id
---@field is_current fun():boolean return if buffer is a buffer of the current window
---@field is_changed fun():boolean return if buffer is changed
---@field file_icon fun():string file icon, require devicons
---@field name fun():string file name
---@field type fun():string return buffer type

---@param bufid number
---@return string
local function get_icon_by_mini(bufid)
  local path = vim.api.nvim_buf_get_name(bufid)
  local category = 'file'
  if vim.fn.isdirectory(path) == 1 then
    category = 'directory'
  end
  local ok, icon = pcall(require('mini.icons').get, category, path)
  if not ok then
    return ''
  end
  return icon
end

---@param bufid number
---@return string
local function get_icon_by_devicons(bufid)
  local path = vim.api.nvim_buf_get_name(bufid)
  local is_dir = vim.fn.isdirectory(path)
  if is_dir == 1 then
    return ''
  end
  local tail = vim.fn.fnamemodify(path, ':t')
  local ext = vim.fn.fnamemodify(path, ':e')
  local icon = require('nvim-web-devicons').get_icon_color(tail, ext)
  return icon or ''
end

---@type fun(bufid:number):string
M.buf_icon = (function()
  if pcall(require, 'mini.icons') then
    return get_icon_by_mini
  else
    return get_icon_by_devicons
  end
end)()

---new TabbyBuf
---@param bufid number
---@param opt TabbyLineOption
---@return TabbyBuf
function M.new_buf(bufid, opt)
  return {
    id = bufid,
    is_current = function()
      return vim.fn.bufnr('%') == bufid
    end,
    is_changed = function()
      return api.get_buf_is_changed(bufid)
    end,
    file_icon = function()
      return M.buf_icon(bufid)
    end,
    name = function()
      return require('tabby.feature.buf_name').get_by_bufid(bufid, opt.buf_name)
    end,
    type = function()
      return api.get_buf_type(bufid)
    end,
  }
end

---@alias TabbyBufFilter fun(buf:TabbyBuf):boolean
---@alias TabbyBufIterator fun(buf:TabbyBuf,i:number?,total:number?):TabbyNode
---@class TabbyBufs
---@field bufs TabbyBuf[] bufs
---@field filter fun(fn:TabbyBufFilter):TabbyBufs filter bufs, keep the truely value
---@field foreach fun(it:TabbyBufIterator,attrs:TabbyAttrs?):TabbyNode[] render bufs by given render function

---@param node TabbyNode
---@param buf TabbyBuf
---@return TabbyNode
local function wrap_buf_node(node, buf)
  if type(node) == 'string' then
    return { node, click = { 'to_buf', buf.id } }
  elseif type(node) == 'table' then
    node.click = { 'to_buf', buf.id }
    return node
  else
    return ''
  end
end

---new TabbyBufs
---@param bufs TabbyBuf[]
---@param opt TabbyLineOption
---@return TabbyBufs
function M.new_bufs(bufs, opt)
  local obj = { ---@type TabbyBufs
    bufs = bufs,
    filter = function(filter)
      local filtered = vim.tbl_filter(filter, bufs)
      return M.new_bufs(filtered, opt)
    end,
    foreach = function(fn, attrs)
      local nodes = {} ---@type TabbyNode[]
      for i, buf in ipairs(bufs) do
        local node = fn(buf, i, #bufs)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = wrap_buf_node(node, buf)
        end
      end
      if attrs ~= nil then
        nodes = vim.tbl_extend('keep', nodes, attrs)
      end
      return nodes
    end,
  }
  return obj
end

return M
