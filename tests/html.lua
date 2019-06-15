local html = require("minify.html")

------------------------------------------------------------
-- Check that we can at least run minify on basic strings --
------------------------------------------------------------

assert(html.minify("") == "", "html.minify didn't return an empty string.")

assert(
	html.minify("<!DOCTYPE html>") == "<!DOCTYPE html>",
	"html.minify stripped the doctype."
)

assert(
	html.minify("<!-- This is a comment -->") == "",
	"html.minify didn't strip a comment."
)

assert(
	html.minify("<html> <head> </head> </html>") == "<html><head></head></html>",
	"html.minify left some useless spaces."
)

assert(
	html.minify("<pre>  spaces ! </pre>") == "<pre>  spaces ! </pre>",
	"html.minify stripped some spaces from a <pre> tag."
)

assert(
	html.minify("<p> spaces  ?</p>") == "<p>spaces ?</p>",
	"html.minify left some useless spaces."
)

assert(
	html.minify("<html  lang='fr'   >") == "<html lang='fr'>",
	"html.minify left some spaces between attributes."
)

assert(
	html.minify("<img src='' alt=''/>") == "<img src='' alt=''>",
	"html.minify left the closing / on an empty element."
)
