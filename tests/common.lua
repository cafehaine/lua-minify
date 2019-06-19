local striter = require("minify.__striter")
local common = require("minify.common")
local parse_str = common.parse_string
local iter = striter.new

compare(parse_str(iter([["hello"]])), [["hello"]])
compare(parse_str(iter([['hello']])), [['hello']])

compare(parse_str(iter([["hello\"a"]]), true), [["hello\"]],
	"failed with no_escaping = true")
compare(parse_str(iter([['hello\'a']]), true), [['hello\']],
	"failed with no_escaping = true")

compare(parse_str(iter([["hello\"a"]]), false), [["hello\"a"]],
	"failed with no_escaping = false")
compare(parse_str(iter([['hello\'a']]), false), [['hello\'a']],
	"failed with no_escaping = false")

compare(parse_str(iter([["'"]])), [["'"]])
