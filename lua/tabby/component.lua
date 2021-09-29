-- tabn define the spec for tab's render
local component = {}
local element = require("tabby.element")

---@class TabbyComTab
---@field type "tab"
---@field tabid number
---@field label string|TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText

---@class TabbyComWin
---@field type "win"
---@field bufid number
---@field label TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText

---@class TabbyComText
---@field type "text"
---@field label TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText

---@class TabbyComSpring
---@field type "spring"

---@alias TabbyComponent TabbyComTab|TabbyComWin|TabbyComText|TabbyComSpring

---@param tab TabbyComTab
---@return string statusline-format string
local function render_tab(tab)
	return table.concat({
		"%",
		tab.tabid,
		"T",
		element.render_text(tab.left_sep),
		element.render_text(tab.label),
		element.render_text(tab.right_sep),
		"%T",
	})
end

---@param win TabbyComWin
---@return string statusline-format string
local function render_win(win)
	return table.concat({
		"%",
		win.bufid,
		"@TabbyBufClickHandler@",
		element.render_text(win.left_sep),
		element.render_text(win.label),
		element.render_text(win.right_sep),
		"%T",
	})
end

---@param text TabbyComText
---@return string statusline-format string
local function render_text(text)
	return table.concat({
		element.render_text(text.left_sep),
		element.render_text(text.label),
		element.render_text(text.right_sep),
	})
end

---@param spring TabbyComSpring
---@return string statusline-format string
local function render_spring(spring)
	return element.render_spring()
end

---@param com TabbyComponent
---@return string statusline-format string
function component.render(com)
	if com.type == "tab" then
		return render_tab(com)
	elseif com.type == "win" then
		return render_win(com)
	elseif com.type == "text" then
		return render_text(com)
	elseif com.type == "spring" then
		return render_spring(com)
	else
		error("invalid component type")
	end
end

return component
