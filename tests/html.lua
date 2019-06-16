local html = require("minify.html")

------------------------------------------------------------
-- Check that we can at least run minify on basic strings --
------------------------------------------------------------

test(html.minify("") == "", "html.minify didn't return an empty string.")

test(
	html.minify("<!DOCTYPE html>") == "<!DOCTYPE html>",
	"html.minify stripped the doctype."
)

test(
	html.minify("<!-- This is a comment -->") == "",
	"html.minify didn't strip a comment."
)

test(
	html.minify("<html> <head> </head> </html>") == "<html><head></head></html>",
	"html.minify left some useless spaces."
)

test(
	html.minify("<pre>  spaces ! </pre>") == "<pre>  spaces ! </pre>",
	"html.minify stripped some spaces from a <pre> tag."
)

test(
	html.minify("<p> spaces  ?</p>") == "<p>spaces ?</p>",
	"html.minify left some useless spaces."
)

test(
	html.minify("<html  lang='fr'   >") == "<html lang='fr'>",
	"html.minify left some spaces between attributes."
)

test(
	html.minify("<img src='' alt=''/>") == "<img src='' alt=''>",
	"html.minify left the closing / on an empty element."
)
