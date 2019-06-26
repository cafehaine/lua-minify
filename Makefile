
test:
	cd tests && lua main.lua

doc:
	ldoc minify

clean:
	rm -rf doc
