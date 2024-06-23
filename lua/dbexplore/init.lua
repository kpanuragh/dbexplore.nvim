local M = {}
local host ='127.0.0.1'
local user = 'root'
local password = 'dev'
local database = 'mysql'
local mysql = require("mysql")

-- Function to establish a connection to the MySQL database
function M.connect_database()
    local conn = mysql.connect{
        host = host,
        user = user,
        password = password,
        database = database
    }
    return conn
end
local conn = M.connect_database()

-- Function to close the database connection
function M.close_connection(conn)
    conn:close()
end
-- Function to display MySQL database selection
function M.select_database()
    local conn = M.connect_database()
    local query = "SHOW DATABASES"
    local cursor = conn:execute(query)
    local databases = {}
    for row in cursor:fetch({}, "a") do
        table.insert(databases, row.Database)
    end
    M.close_connection(conn)
    
    -- Display databases using telescope.nvim
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local previewers = require("telescope.previewers")
    local sorters = require("telescope.sorters")
    
    pickers.new({}, {
        prompt_title = "Databases",
        finder = finders.new_table({
            results = databases,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end,
        }),
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
            local select_database = function()
                local selection = actions.get_selected_entry(prompt_bufnr)
                if selection then
                    M.select_table(selection.value)
                end
                actions.close(prompt_bufnr)
            end

            map("i", "<CR>", select_database)
            map("n", "<CR>", select_database)

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