savedVars = {
	ScrollToSelect = { 
		name = "Scroll To Select",
		boxDescription = "Use mousewheel to select blocks on the hotbar.",
		default = false,
		current = nil,
		valueType = "bool",
		configurable = true,
	},
	
	NumbersToSelect = {
		name = "Numbers To Select",
		boxDescription = "Use number keys to select blocks on the hotbar.",
		default = true,
		current = nil,
		valueType = "bool",
		configurable = true,
	},
	
	BlockPlacementSpeed = {
		name = "Block placement speed.",
		boxDescription = "The delay between placing blocks when right click is held down.",
		default = 2,
		current = nil,
		valueType = "int",
		configurable = true,
	},
	
	InventoryUIScale = {
		name = "Inventory UI Scale.",
		boxDescription = "Size of the inventory UI.",
		default = 2,
		current = nil,
		valueType = "int",
		configurable = true,
	},
}

menuVarOrder = { "ScrollToSelect", "NumbersToSelect",}