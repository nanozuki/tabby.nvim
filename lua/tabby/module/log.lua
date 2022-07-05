local log = {
  level = vim.log.levels.WARN,
}
--  vim.log.levels.TRACE, -- 0
--  vim.log.levels.DEBUG, -- 1
--  vim.log.levels.INFO,  -- 2
--  vim.log.levels.WARN   -- 3
--  vim.log.levels.ERROR  -- 4

---@class TabbyLogger
---@field message function(message:string) send string notify
---@field format function(format:string, ...:[]any) send string notify

---new logger
---@param level number
---@return TabbyLogger
local function logger(level)
  local lg = {}
  lg.message = function(message)
    if level >= log.level then
      vim.notify(message, level)
    end
  end
  lg.format = function(format, ...)
    if level >= log.level then
      vim.notify(string.format(format, ...), level)
    end
  end
  return lg
end

log.trace = logger(vim.log.levels.TRACE)
log.debug = logger(vim.log.levels.DEBUG)
log.info = logger(vim.log.levels.INFO)
log.warn = logger(vim.log.levels.WARN)
log.error = logger(vim.log.levels.ERROR)

return log
