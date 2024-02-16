local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"

local M = {}

-- Telescope commonly used paths picker
M.common_paths = function ()
    local function enter(prompt_bufnr)
        local selected = action_state.get_selected_entry()
        vim.api.nvim_set_current_dir(selected[1])
        --How to run general vim commans
        --local cmd = 'cd ' .. selected[1]
        --vim.cmd(cmd)
        actions.close(prompt_bufnr)
    end

    local path_opts = {
        finder = finders.new_table {
            "/home/joakim",
            "/home/joakim/code",
            "/home/joakim/accounting",
            "/home/joakim/scripts",
        },
        sorter = sorters.get_generic_fuzzy_sorter({}),

        attach_mappings = function(prompt_bufnr, map)
            map("n", "<CR>", enter)
            map( "i", "<CR>", enter)
            return true
        end,
    }

    pickers.new(path_opts):find()

end

return M
