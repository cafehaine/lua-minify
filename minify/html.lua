---
-- The internal html minifier module
--
local striter = require("minify.__striter")
local common = require("minify.common")

local m = {}

local patterns = {
	space = "[ \t\n]",
	element = "[%a%d%-_%.]"
}

--- Go through the striter until the next non-space character.
-- @tparam striter iter the iterator
local function skip_space(iter)
	while iter:peek():match(patterns.space) do
		iter:next()
	end
end

--- Parse an argument.
-- @tparam striter iter the iterator
-- @treturn string the argument's name
-- @treturn string|nil the argument's value
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
		value = common.parse_string_no_escape(iter)
	end

	-- If the attribute is a style attribute, pass it to the CSS minifier
	if attr:lower() == "style" then
		--TODO
	end

	return attr, value
end

--- Take all the data between two pre tags.
-- @tparam striter iter the iterator
-- @treturn string the data including the closing pre tag
local function handle_pre(iter)
	local output = {}
	local done = false
	local char = iter:next()
	while char and not done do
		if char == "<" then
			if iter:peek(4):lower() == "/pre" then
				while char and char ~= ">" do
					char = iter:next()
				end
				output[#output+1] = "</pre>"
				done = true
			else
				handle_tag(output, iter)
			end
		else
			output[#output+1] = char
			char = iter:next()
		end
	end
	return table.concat(output)
end

--- Handle a closing tag.
-- @tparam striter iter the iterator
-- @treturn string the closing tag
local function handle_closing(iter)
	iter:next() -- skip '/'
	local name = ""
	local char = iter:next()
	while char ~= nil and char:match(patterns.element) do
		name = name .. char
		char = iter:next()
	end
	-- skip spaces or invalid stuff
	while char and char ~= ">" do
		char = iter:next()
	end
	return "</"..name..">"
end

--- Parse a tag.
-- Deletes all comments, compacts spaces, and calls specific functions when
-- needed.
-- Outputs the minified tag.
-- @tparam striter iter the iterator
-- @treturn string the minified tag
local function handle_tag(iter)
	local output = {}
	local char
	-- Comment tag
	if iter:peek(3) == "!--" then
		while iter:peek() and iter:peek(3) ~= "-->" do
			iter:next()
		end
		iter:next()
		iter:next()
		iter:next()

	-- Doctype tag
	elseif iter:peek(8):lower() == "!doctype" then
		char = iter:next()
		while char and char ~= ">" do
			char = iter:next()
		end
		iter:next()
		output[#output+1] = "<!DOCTYPE html>"

	-- Closing tag
	elseif iter:peek() == "/" then
		output[#output+1] = handle_closing(iter)

	-- Other tags
	else
		local name = ""
		local attributes = {}
		char = iter:next()
		-- Get element name
		while char ~= nil and char:match(patterns.element) do
			name = name..char
			char = iter:next()
		end
		-- Get the attributes if any
		while char ~= nil and char ~= ">" do
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
			output[#output+1] = handle_pre(iter)

		-- If element is a style element, read the content and pass it
		-- to the CSS minifier
		elseif name:lower() == "style" then
			--TODO
		end
	end
	return table.concat(output)
end

--- Stitch the output table from minify.
-- @tparam table tab the output table
-- @treturn string the stitched output
local function stitch_output(tab)
	local output = {}
	for i,v in ipairs(tab) do
		if v[1] == "tag" then
			output[#output+1] = v[2]
		elseif v[1] == "char" then
			output[#output+1] = v[2]
		else
			if tab[i-1][1] == "char" and tab[i+1][1] == "char" then
				output[#output+1] = " "
			end
		end
	end
	return table.concat(output)
end

--- Minify an html string or file.
-- @function html.minify
-- @tparam string|file arg the data to minify
-- @treturn string the minified data
function m.minify(arg)
	local iter = striter.new(arg)
	local output = {}
	local char = iter:next()
	while char do
		if char == "<" then
			output[#output+1] = {"tag", handle_tag(iter)}
		elseif char:match(patterns.space) then
			output[#output+1] = {"space"}
			skip_space(iter)
		else
			output[#output+1] = {"char", char}
		end
		char = iter:next()
	end

	return stitch_output(output)
end

return m

