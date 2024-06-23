local M = {}
local host ='127.0.0.1'
local user = 'root'
local password = 'dev'
local database = 'mysql'


local telescope = require('telescope')
    local actions = require('telescope.actions')
    local finders = require('telescope.finders')
    local pickers = require('telescope.pickers')
    local previewers = require('telescope.previewers')
    local conf = require('telescope.config').values
-- Function to display MySQL database selection
    function M.select_database()
        local handle = io.popen('mariadb -h ' .. host .. ' -u ' .. user .. ' -p' .. password .. ' -e "SHOW DATABASES;"')
        local result = handle:read("*a")
        result = result:gsub("[^\n]*\n", "", 1)
        handle:close()

        local database_list = {}
        for database in result:gmatch('(%S+)') do
            table.insert(database_list, database)
        end

        pickers.new({}, {
            prompt_title = 'Databases',
            finder = finders.new_table({
                results = database_list,
            }),
            sorter = conf.generic_sorter({}),
            previewer = previewers.cat.new({}),
            attach_mappings = function(prompt_bufnr, map)
                local select_database = function()
                    local selection = actions.get_selected_entry(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    M.select_table(selection.value)
                end

                map('i', '<CR>', select_database)
                map('n', '<CR>', select_database)

                return true
            end,
        }):find()
    end
-- Function to display MySQL table selection
function M.select_table(database)
    -- Your code here
end

-- Function to display table content in table format
function M.display_table_content(database, table)
    -- Your code here
end

return M