LUAC = luac

all: .tmp/main.lua.bin .tmp/textwrap2.lua.bin

.tmp/main.lua.bin: main.lua
	$(LUAC) -o ".tmp/main.lua.bin" "main.lua"

.tmp/textwrap2.lua.bin: textwrap2.lua
	$(LUAC) -o ".tmp/textwrap2.lua.bin" "textwrap2.lua"

