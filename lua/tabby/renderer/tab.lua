local tab = {}

function tab.label(tabid, text)
  --                     % 3T-- %T
  return string.format('%%%dT%s%%T', tabid, text)
end

function tab.close(tabid, text) end

return tab
