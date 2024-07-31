local tab_jumper = {
  line = nil,
  char_to_tabid = {}, ---@type table<string,number>
  tabid_to_char = {}, ---@type table<number,string>
  is_start = false,
}

local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

---@param line TabbyLine
function tab_jumper.pre_render(line)
  tab_jumper.line = line
end

function tab_jumper.reset()
  tab_jumper.char_to_tabid = {}
  tab_jumper.tabid_to_char = {}
end

function tab_jumper.build_indexes()
  if tab_jumper.line == nil then
    return
  end
  local tabs = tab_jumper.line.tabs().tabs

  -- use the first, not used char of tab's name
  for _, tab in ipairs(tabs) do
    local name = tab.name()
    for i = 1, #name do
      local char = name:sub(i, i):upper()
      if tab_jumper.char_to_tabid[char] == nil then
        tab_jumper.char_to_tabid[char] = tab.id
        tab_jumper.tabid_to_char[tostring(tab.id)] = char
        break
      end
    end
  end

  -- then, for the remain tabs, use the first, not used char of alphabet
  for _, tab in ipairs(tabs) do
    if tab_jumper.tabid_to_char[tostring(tab.id)] == nil then
      for i = 1, #alphabet do
        local char = alphabet:sub(i, i)
        if tab_jumper.char_to_tabid[char] == nil then
          tab_jumper.char_to_tabid[char] = tab.id
          tab_jumper.tabid_to_char[tostring(tab.id)] = char
          break
        end
      end
    end
  end
end

function tab_jumper.get_char(tabid)
  local char = tab_jumper.tabid_to_char[tostring(tabid)] or '??'
  return char
end

function tab_jumper.start()
  tab_jumper.build_indexes()
  tab_jumper.is_start = true

  vim.cmd.redrawtabline()
  local c = vim.fn.getcharstr():upper()
  tab_jumper.is_start = false
  if tab_jumper.char_to_tabid[c] ~= nil then
    vim.api.nvim_set_current_tabpage(tab_jumper.char_to_tabid[c])
  else
    tab_jumper.reset()
    vim.cmd.redrawtabline()
  end
end

return tab_jumper
