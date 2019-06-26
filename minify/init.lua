local m = {}
local metatable = {}
local loadable = {html=true, common=true, __striter=true}
local loaded = {}

setmetatable(m, metatable)

function metatable.__index(table, key)
	if loadable[key] then
		if loaded[key] then
			return loaded[key]
		end
		loaded[key] = require("minify."..key)
		return loaded[key]
	else
		return nil
	end
end

return m

