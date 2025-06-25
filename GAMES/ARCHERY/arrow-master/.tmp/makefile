LUAC = luac

all: .tmp/main.lua.bin .tmp/fire.lua.bin .tmp/tntvpad32.lua.bin .tmp/tntvpad64.lua.bin .tmp/tntanimator32.lua.bin .tmp/tntanimator64.lua.bin .tmp/FrioArcher.lua.bin .tmp/archer.lua.bin .tmp/scene.lua.bin

.tmp/main.lua.bin: main.lua
	$(LUAC) -o ".tmp/main.lua.bin" "main.lua"

.tmp/fire.lua.bin: fire.lua
	$(LUAC) -o ".tmp/fire.lua.bin" "fire.lua"

.tmp/tntvpad32.lua.bin: ../libs/tntvpad32.lua
	$(LUAC) -o ".tmp/tntvpad32.lua.bin" "../libs/tntvpad32.lua"

.tmp/tntvpad64.lua.bin: ../libs/tntvpad64.lua
	$(LUAC) -o ".tmp/tntvpad64.lua.bin" "../libs/tntvpad64.lua"

.tmp/tntanimator32.lua.bin: ../libs/tntanimator32.lua
	$(LUAC) -o ".tmp/tntanimator32.lua.bin" "../libs/tntanimator32.lua"

.tmp/tntanimator64.lua.bin: ../libs/tntanimator64.lua
	$(LUAC) -o ".tmp/tntanimator64.lua.bin" "../libs/tntanimator64.lua"

.tmp/FrioArcher.lua.bin: FrioArcher.lua
	$(LUAC) -o ".tmp/FrioArcher.lua.bin" "FrioArcher.lua"

.tmp/archer.lua.bin: archer.lua
	$(LUAC) -o ".tmp/archer.lua.bin" "archer.lua"

.tmp/scene.lua.bin: scene.lua
	$(LUAC) -o ".tmp/scene.lua.bin" "scene.lua"

