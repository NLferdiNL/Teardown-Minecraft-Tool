#include "scripts/items/enderpearl.lua"
#include "scripts/items/flintandsteel.lua"
#include "scripts/items/firecharge.lua"

itemData = {}
itemSprites = {}

--		  Name		    = {init,		   update			 finish
itemData["Ender Pearl"] = {enderPearlInit, enderPearlUpdate}
itemData["Flint And Steel"] = {flintAndSteelInit, flintAndSteelUpdate}
itemData["Fire Charge"] = {fireChargeInit, fireChargeUpdate}

itemSprites["Fire Charge"] = "MOD/sprites/blocks/Fire Charge.png"

function itemSprites_init()
	for name, path in pairs(itemSprites) do
		itemSprites[name] = LoadSprite(path)
	end
end