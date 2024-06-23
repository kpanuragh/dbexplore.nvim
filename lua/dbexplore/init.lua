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
                M.selected_database = selection.value -- Store selected database name in global variable
                M.select_table()
            end

            map('i', '<CR>', select_database)
            map('n', '<CR>', select_database)

            return true
        end,
    }):find()
end
-- Function to display MySQL table selection
function M.select_table()
local database = M.selected_database
local handle = io.popen('mariadb -h ' .. host .. ' -u ' .. user .. ' -p' .. password .. ' -e "USE ' .. database .. '; SHOW TABLES;"')
local result = handle:read("*a")
result = result:gsub("[^\n]*\n", "", 1)
handle:close()
local table_list = {}
for table in result:gmatch('(%S+)') do
    table.insert(table_list, table)
end

pickers.new({}, {
    prompt_title = 'Tables',
    finder = finders.new_table({
        results = table_list,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.cat.new({}),
    attach_mappings = function(prompt_bufnr, map)
        local select_table = function()
            local selection = actions.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)
            M.selected_table = selection.value -- Store selected table name in global variable
            M.display_table_content(M.selected_database, selection.value)
        end
        map('i', '<CR>', select_table)
        map('n', '<CR>', select_table)
        return true
    end,
}):find()

end

return M