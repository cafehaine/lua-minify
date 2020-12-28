# ARCHIVED PROJECT, I won't be updating this (though I might revisit the idea in the future)

# lua-minify

lua-minify is a Lua library to minify html5 and css3. It's written in pure Lua
5.3, and it's written using test-driven development.

The project's name isn't definitive, and might/will change, as there are already
a few projects named lua-minify.

# Warning

Before you start using lua-minify, you need to know a few assumptions that it
makes:

- You don't mess with the `white-space` CSS property. Only `<pre>` tags will
  keep the data as it is in the source file.
- You don't put code in comments (IE's conditional comments are stupid, why are
  you even trying to support IE?)
- It doesn't optimize inline javascript. You probably shouldn't be using inline
  javascript anyway.
- It doesn't support non-standard tags: if you use a framework like vue, and you
  create a tag starting with `pre` (for exemple), it will break the parser.
- It doesn't support twig/jinja/django and other templating engines. you should
  only use lua-minify on *pure* HTML5 and CSS3.

# Current status

## HTML

Everything should pretty much work as-is. CSS isn't optimized, since the CSS
minifier isn't written yet.

