local util = require("tabby.util")

local hl_tabline = {
    color_01 = "#252A34",
    color_02 = "#90c1a3",
    color_03 = "#79a88b"
}

local get_tab_label = function(tab_number)
    local s, v =
        pcall(
        function()
            return vim.api.nvim_eval("ctrlspace#util#Gettabvar(" .. tab_number .. ", 'CtrlSpaceLabel')")
        end
    )
    if s then
        if v == "" then
            return tab_number
        else
            return tab_number .. ": " .. v
        end
    else
        return tab_number .. ": " .. v
    end
end

local components = function()
    local coms = {
        {
            type = "text",
            text = {
                "    ",
                hl = {
                    fg = hl_tabline.color_01,
                    bg = hl_tabline.color_03
                }
            }
        }
    }
    local tabs = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local name_of_buf
    for _, tabid in ipairs(tabs) do
        local tab_number = vim.api.nvim_tabpage_get_number(tabid)
        name_of_buf = get_tab_label(tab_number)
        if tabid == current_tab then
            table.insert(
                coms,
                {
                    type = "tab",
                    tabid = tabid,
                    label = {
                        "  " .. name_of_buf .. "  ",
                        hl = {fg = hl_tabline.color_02, bg = hl_tabline.color_01}
                    }
                }
            )
            local wins = util.tabpage_list_wins(current_tab)
            local top_win = vim.api.nvim_tabpage_get_win(current_tab)
            for _, winid in ipairs(wins) do
                local icon = " "
                if winid == top_win then
                    icon = " "
                end
                local bufid = vim.api.nvim_win_get_buf(winid)
                local buf_name = vim.api.nvim_buf_get_name(bufid)
                table.insert(
                    coms,
                    {
                        type = "win",
                        winid = winid,
                        label = icon .. vim.fn.fnamemodify(buf_name, ":~:.") .. "  "
                    }
                )
            end
        else
            table.insert(
                coms,
                {
                    type = "tab",
                    tabid = tabid,
                    label = {
                        "  " .. name_of_buf .. "  ",
                        hl = {fg = hl_tabline.color_01, bg = hl_tabline.color_02}
                    }
                }
            )
        end
    end
    table.insert(coms, {type = "text", text = {" ", hl = {bg = hl_tabline.color_01}}})

    return coms
end

require("tabby").setup(
    {
        components = components
    }
)
