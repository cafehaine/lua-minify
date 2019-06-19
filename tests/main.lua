package.path = "../?.lua;../?/init.lua"

local function run_test(to_test)
	local failed = 0
	local test_count = 0
	function test(arg, err)
		test_count = test_count + 1
		if not arg then
			print(err)
			failed = failed + 1
		end
	end

	function compare(value, expected, err)
		test_count = test_count + 1
		if value ~= expected then
			if err then
				print(err)
			end
			print(("Expected %q, got %q"):format(expected, value))
			failed = failed + 1
		end
	end

	dofile(to_test..".lua")
	if failed > 0 then
		print(("%d failed tests out of %d (%.1f%%)"):format(failed, test_count, failed/test_count*100))
	else
		print(("Passed %d tests successfully"):format(test_count))
	end
	return failed
end

local tests = {"striter","common","html"}
local total_failed = 0

for i=1, #tests do
	local test = tests[i]
	print(string.format("\n%d/%d\t- %s", i, #tests, test))
	total_failed = total_failed + run_test(test)
end

if total_failed > 0 then
	print("\nFailed "..total_failed.." tests.")
	os.exit(1)
end

