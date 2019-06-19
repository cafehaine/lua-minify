local m = {}

local function continue_string(char, opening, no_escaping, ignore)
	if not char then
		return false
	end
	if char == opening then
		if no_escaping then
			return false
		elseif ignore then
			return true
		end
		return false
	end
	return true
end

function m.parse_string(iter, no_escaping)
	local opening_char = iter:next()
	local output = {opening_char}
	local ignore_next = false
	local char = iter:next()
	while continue_string(char, opening_char, no_escaping, ignore_next) do
		ignore_next = false
		if char == "\\" and not no_escaping then
			ignore_next = true
		end
		output[#output+1] = char
		char = iter:next()
	end
	output[#output+1] = char
	return table.concat(output)
end

return m

