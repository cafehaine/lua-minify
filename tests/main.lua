package.path = "../?.lua;../?/init.lua"

local tests = {"striter","html"}

for i=1, #tests do
	local test = tests[i]
	print(string.format("%d/%d\t- %s", i, #tests, test))
	dofile(test..".lua")
end

