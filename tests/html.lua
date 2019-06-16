local html = require("minify.html")

------------------------------------------------------------
-- Check that we can at least run minify on basic strings --
------------------------------------------------------------

test(html.minify("") == "", "html.minify didn't return an empty string.")

compare(
	html.minify("<!DOCTYPE html>"), "<!DOCTYPE html>",
	"html.minify stripped the doctype."
)

compare(
	html.minify("<!-- This is a comment -->"),
	"", "html.minify didn't strip a comment."
)

compare(
	html.minify("<html> <head> </head> </html>"),
	"<html><head></head></html>",
	"html.minify left some spaces between tags."
)

compare(
	html.minify("<pre>  spaces ! </pre>"), "<pre>  spaces ! </pre>",
	"html.minify stripped some spaces from a <pre> tag."
)

compare(
	html.minify("<p> spaces  ?</p>"), "<p>spaces ?</p>",
	"html.minify left some useless spaces."
)

compare(
	html.minify("<html  lang='fr'   >"), "<html lang='fr'>",
	"html.minify left some spaces between attributes."
)

compare(
	html.minify("<img src='' alt=''/>"), "<img src='' alt=''>",
	"html.minify left the closing / on an empty element."
)
