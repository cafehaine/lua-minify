local striter = require("minify.__striter")
local common = require("minify.common")

local m = {}

local patterns = {
	space = "[ \t]",
	element = "[%a%d%-_%.]"
}

local function skip_space(iter)
	while iter:peek():match(patterns.space) do
		iter:next()
	end
end

local function parse_argument(iter)
	local char
	local attr = ""
	-- Read attribute
	repeat
		char = iter:next()
		attr = attr..char
	until(not iter:peek():match(patterns.element))
	-- attribute might be boolean, check if there is an '='
	local value
	if iter:peek() == "=" then
		iter:next()
		value = common.parse_string(iter, true)
	end
	return attr, value
end

local function handle_tag(output, iter)
	-- Comment tag
	if iter:peek(3) == "!--" then
		while not iter:peek(3) == "-->" and iter:peek() ~= nil do
			iter:next()
		end

	-- Doctype tag
	elseif iter:peek(8):lower() == "!doctype" then
		while not iter:peek() == ">" and iter:peek() ~= nil do
			iter:next()
		end
		output[#output+1] = "<!DOCTYPE html>"

	-- Closing tag
	elseif iter:peek() == "/" then
		iter:next() -- skip '/'
		local name = ""
		local char = iter:next()
		while char ~= nil and char:match(patterns.element) do
			name = name .. char
			char = iter:next()
		end
		-- skip spaces or invalid stuff
		while char ~= nil and char ~= ">" do
			char = iter:next()
		end
		output[#output+1] = "</"..name..">"

	-- Other tags
	else
		local name = ""
		local attributes = {}
		local char = iter:next()
		-- Get element name
		while char ~= nil and char:match(patterns.element) do
			name = name..char
			char = iter:next()
		end
		-- Get the attributes if any
		while char ~= nil and char ~= ">" and char ~= "/" do
			if char:match(patterns.space) then
				skip_space(iter)
			end
			if iter:peek():match(patterns.element) then
				local attr, val = parse_argument(iter)
				attributes[#attributes+1] = {attr, val}
			end
			char = iter:next()
		end
		if #attributes == 0 then
			output[#output+1] = "<"..name..">"
		else
			output[#output+1] = "<"..name
			for _,kvp in ipairs(attributes) do
				if kvp[2] then
					output[#output+1] = " "..kvp[1].."="..kvp[2]
				else
					output[#output+1] = " "..kvp[1]
				end
			end
			output[#output+1] = ">"
		end
		-- If element is pre, read all data until closing pre tag.
		if name:lower() == "pre" then
			--TODO
		end
	end
end

function m.minify(arg)
	local iter = striter.new(arg)
	local output = {}
	local char = iter:next()
	while char do
		if char == "<" then
			handle_tag(output, iter)
		elseif char:match(patterns.space) then
			skip_space(iter)
		else
			--TODO handle text
		end
		char = iter:next()
	end

	return table.concat(output)
end

return m

