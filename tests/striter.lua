local striter = require("minify.__striter")

----------------------------------------------------------------------
-- Check that we can only create striters with strings or open fds. --
----------------------------------------------------------------------

local closed = io.open("striter.lua")
closed:close()

local invalidinputs = {
	[0] = nil, -- nil
	0, -- number
	{}, -- table
	true, -- boolean
	print, -- function
	closed -- closed file
}

for i=0, #invalidinputs do
	assert(
		striter.new(invalidinputs[i]) == nil,
		"Created a striter with an invalid input."
	)
end

assert(
	type(striter.new("string")) == "table",
	"Could not create a striter from a string."
)

assert(
	type(striter.new(io.open("striter.lua"))) == "table",
	"Could not create a striter from an open file."
)

------------------------------------------------
-- Check that data is iterated over correctly --
------------------------------------------------

local data = "striter is cool\n"
local iter = striter.new(io.open("resources/striter.txt"))
local index = 1
local char = iter:next()
while char do
	assert(data:sub(index,index) == char, "Next returned an invalid value.")
	index = index + 1
	char = iter:next()
end

for i=1, 100 do
	assert(iter:next() == nil, "Next returned a char after EOF.")
end

-------------------
-- Check peek(n) --
-------------------

data = "abcdef"
iter = striter.new(data)
assert(iter:peek(2) == "ab", "Peek returned an invalid value")
assert(iter:peek() == "a", "Peek returned an invalid value")
assert(iter:peek(7) == "abcdef", "Peek returned an invalid value")
iter:next()
assert(iter:peek(2) == "bc", "Peek returned an invalid value")
while iter:next() do end
assert(iter:peek() == nil, "Peek returned a value after EOF.")
assert(iter:peek(20) == nil, "Peek returned a value after EOF.")
