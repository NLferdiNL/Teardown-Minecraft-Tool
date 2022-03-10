#include "scripts/utils.lua"

binds = {
	Mine = "lmb",
	Pick_Block = "mmb",
	Place = "rmb",
	Open_Inventory = "i",
	Scroll = "mousewheel",
	Prev_Block = "z",
	Next_Block = "c",
	Toggle_Dynamic = "x",
	Quit_Tool = "n",
	--Set_Offset = "l",
	--Reset_Special_Blocks = "o",
	Open_Menu = "m",
}

local bindBackup = deepcopy(binds)

bindOrder = {
	"Prev_Block",
	"Next_Block",
	"Toggle_Dynamic",
	"Open_Inventory",
	--"Reset_Special_Blocks",
	--"Set_Offset",
	"Quit_Tool",
	"Open_Menu",
}
		
bindNames = {
	Mine = "Mine",
	Place = "Place",
	Open_Inventory = "Open Inventory",
	Open_Menu = "Open Menu",
	Scroll = "Scroll",
	Prev_Block = "Previous Block",
	Next_Block = "Next Block",
	Toggle_Dynamic = "Toggle Dynamic",
	Quit_Tool = "Quit Tool",
	--Set_Offset = "Set Offset",
	--Reset_Special_Blocks = "Reset special blocks",
}

function resetKeybinds()
	binds = deepcopy(bindBackup)
end

function getFromBackup(id)
	return bindBackup[id]
end