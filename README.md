# why.lua
## Overview
Completely unnecessary but interesting challenge of making Lua unreadable. \
Inspired by this video: \
[![JavaScript Is Weird (EXTREME EDITION)](https://img.youtube.com/vi/sRWE5tnaxlI/0.jpg)](https://www.youtube.com/watch?v=sRWE5tnaxlI)
## Quirks
While designing this library I've made some design choices which would produce pretty funny results when you tried to generate code for something.
### The generated code is huge
The code could've been made smaller with string indexing, but I decided that that is cheating, so I decided to use `:sub` instead. Another thing is that characters aren't cached, which requires a system to keep track of those. That does sound interesting, so that may or may not be added in the future.
### "C stack overflow"
When trying to generate code for scripts bigger than a "Hello, world!" example, if you run the script a C stack overflow might happen.
