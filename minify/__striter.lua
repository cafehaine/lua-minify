local m = {}
m.__index = m

function m.new(arg)
	if io.type(arg) == "file" then
		local file = arg
		arg = file:read("a*")
		file:close()
	end

	if type(arg) ~= "string" then
		return nil, "Input must be an open file or a string."
	end

	local self = setmetatable({}, m)
	self.__index = 0
	self.__string = arg
	return self
end

function m:next()
	self.__index = self.__index + 1
	local value = self.__string:sub(self.__index, self.__index)
	return #value ~= 0 and value or nil
end

function m:peek(n)
	if n == nil then
		n = 1
	end

	local value = self.__string:sub(self.__index+1, self.__index+n)
	return #value ~= 0 and value or nil
end

return m

