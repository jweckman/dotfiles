-- Diff of "+" register and "a" regitser contents in new tab
local M = {}

local function split_str(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local function get_reg(char)
    local reg = vim.api.nvim_exec([[echo getreg(']]..char..[[')]], true):gsub("[\n\r]", "^J")
    return split_str(reg, "^J")
end

M.compare_clipboard = function()
    vim.cmd('tabnew')
    local r_plus = get_reg("+")
    local r_a = get_reg("a")
    local bp = vim.api.nvim_create_buf(true,false)
    vim.api.nvim_buf_set_name(bp, "plus_register")
    local bs = vim.api.nvim_create_buf(true,false)
    vim.api.nvim_buf_set_name(bs, "a_register")
    local ws = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(ws, bs)
    vim.api.nvim_set_current_buf(bp)
    vim.cmd('diffthis')
    vim.cmd('vsplit')
    local wp = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(wp, bp)
    vim.api.nvim_buf_set_lines(bp, 0, -1, false, r_plus)
    vim.api.nvim_set_current_buf(bs)
    vim.api.nvim_buf_set_lines(bs, 0, -1, false, r_a)
    vim.cmd('diffthis')
end

return M
