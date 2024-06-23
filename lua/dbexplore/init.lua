local M = {}
local host ='127.0.0.1'
local user = 'root'
local password = 'dev'
local database = 'mysql'

-- Function to display MySQL database selection
function M.select_database()
    local handle = io.popen('mysql -h ' .. host .. ' -u ' .. user .. ' -p' .. password .. ' -e "SHOW DATABASES;"')
    local result = handle:read("*a")
    handle:close()
    print(result)
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