local striter = require("minify.__striter")

local m = {}

local function handle_tag(output, iter)
	-- Comment tag
	if iter:peek(3) == "!--" then
		while not iter:peek(3) == "-->" and iter:peek() ~= nil do
			iter:next()
		end

	-- Doctype tag
	elseif iter:peek(8) == "!DOCTYPE" then
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
		end
		char = iter:next()
	end

	return table.concat(output)
end

return m

