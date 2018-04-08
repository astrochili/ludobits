--- Save and load tables using the io.* functions
-- Tables will be json encoded before written to disk.
--
-- @usage
-- local savetable = require "ludobits.m.io.savetable"
--
-- local file = savetable.open("foobar")
-- file.save({ foo = "bar" })
-- local data = file.load()
-- print(data.foo) -- "bar"

local savefile = require "ludobits.m.io.savefile"
local json = require "ludobits.m.json"

local M = {}

--- Open a file for reading and writing a Lua table.
-- @param filename
-- @return file instance
function M.open(filename)
	local file = savefile.open(filename)

	local instance = {}

	--- Load the table stored in the file
	-- @return table The loaded table or nil
	-- @return error_message
	function instance.load()
		local ok, t_or_err = pcall(function()
			local s, err = file.load()
			if err then
				return nil
			end
			return json.decode(s)
		end)
		return ok and t_or_err, not ok and t_or_err
	end

	--- Save table to the file
	-- @param t The table to save
	-- @return success
	-- @return error_message
	function instance.save(t)
		assert(t and type(t) == "table", "You must provide a table to save")
		return pcall(function()
			local s = json.encode(t)
			return file.save(s)
		end)
	end

	return instance
end



return M
