local striter = require("minify.__striter")

local m = {}

local patterns = {
	space = "[ \t]"
}

local function skip_space(iter)
	while iter:peek():match(patterns.space) do
		iter:next()
	end
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

	-- Preformated text tag
	elseif iter:peek(3) == "pre" then
		--TODO

	-- Other tags
	else
		--TODO
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

