---
-- The common module.
-- Some functions shared between the other modules.
---

local m = {}

--- Parse a string that doesn't handle escaping.
-- @function common.parse_string_no_escape
-- @tparam striter iter the iterator
-- @treturn string the string
function m.parse_string_no_escape(iter)
	local opening_char = iter:next()
	local output = {opening_char}
	local char = iter:next()
	while char ~= opening_char do
		output[#output+1] = char
		char=iter:next()
	end
	output[#output+1] = char
	return table.concat(output)
end

--- Parse a string that handles escaping.
-- @function common.parse_string
-- @tparam striter iter the iterator
-- @treturn string the string
function m.parse_string(iter)
	local opening_char = iter:next()
	local output = {opening_char}
	local ignore = false
	local prev_ignore = ignore
	local char = iter:next()
	while char and not (char == opening_char and not ignore) do
		prev_ignore = ignore
		ignore = false
		if char == "\\" and not prev_ignore then
			ignore = true
		end
		output[#output+1] = char
		char = iter:next()
	end
	output[#output+1] = char
	return table.concat(output)
end

return m

