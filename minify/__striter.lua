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
	self.__index = 1
	self.__string = string
	return self
end

function m:next()
	self.__index = self.__index + 1
	if self.__index > #self.__string then
		return nil
	end
	return self.__string:sub(self.__index)
end

return m

