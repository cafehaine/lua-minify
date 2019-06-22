local striter = require("minify.__striter")
local common = require("minify.common")
local parse_str_esc = common.parse_string
local parse_str = common.parse_string_no_escape
local iter = striter.new

compare(parse_str(iter([["hello"]])), [["hello"]])
compare(parse_str(iter([['hello']])), [['hello']])
compare(parse_str_esc(iter([["hello"]])), [["hello"]])
compare(parse_str_esc(iter([['hello']])), [['hello']])

compare(parse_str(iter([["\\""]])), [["\\"]])
compare(parse_str(iter([["\\\""]])), [["\\\"]])
compare(parse_str_esc(iter([["\\""]])), [["\\"]])
compare(parse_str_esc(iter([["\\\""]])), [["\\\""]])

compare(parse_str(iter([["hello\"a"]])), [["hello\"]],
	"failed with no escaping")
compare(parse_str(iter([['hello\'a']])), [['hello\']],
	"failed with no escaping")

compare(parse_str_esc(iter([["hello\"a"]])), [["hello\"a"]],
	"failed with escaping")
compare(parse_str_esc(iter([['hello\'a']])), [['hello\'a']],
	"failed with escaping")

compare(parse_str(iter([["'"]])), [["'"]])
