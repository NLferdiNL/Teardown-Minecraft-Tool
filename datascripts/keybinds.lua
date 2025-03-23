#include "scripts/utils.lua"

binds = {
	Mine = "lmb",
	Pick_Block = "mmb",
	Place = "rmb",
	Interact = "interact",
	Open_Inventory = "i",
	Scroll = "mousewheel",
	Prev_Block = "z",
	Next_Block = "c",
	Toggle_Dynamic = "x",
	Drop_Item = "q",
	Quit_Tool = "n",
	Spawn_Portal = "f4",
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
	--"Drop_Item",
	"Quit_Tool",
	"Open_Menu",
}
		
bindNames = {
	Mine = "Mine",
	Pick_Block = "Pick Block",
	Place = "Place",
	Interact = "Interact",
	Open_Inventory = "Open Inventory",
	Scroll = "Scroll",
	Prev_Block = "Previous Block",
	Next_Block = "Next Block",
	Toggle_Dynamic = "Toggle Dynamic",
	Drop_Item = "Drop Item",
	Quit_Tool = "Quit Tool",
	--Set_Offset = "Set Offset",
	--Reset_Special_Blocks = "Reset special blocks",
	Open_Menu = "Open Menu",
}

function resetKeybinds()
	binds = deepcopy(bindBackup)
end

function getFromBackup(id)
	return bindBackup[id]
end