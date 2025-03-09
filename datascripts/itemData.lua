#include "scripts/items/enderpearl.lua"
#include "scripts/items/flintandsteel.lua"
#include "scripts/items/firecharge.lua"
#include "scripts/items/droppeditem.lua"

itemData = {}
itemSprites = {}

--		  Name		    = {init,		   update			 finish
itemData["Ender Pearl"] = {enderPearlInit, enderPearlUpdate}
itemData["Flint And Steel"] = {flintAndSteelInit, flintAndSteelUpdate}
itemData["Fire Charge"] = {fireChargeInit, fireChargeUpdate}
itemData["Dropped Item"] = {droppedInit, droppedUpdate}

itemSprites["Fire Charge"] = "MOD/sprites/blocks/Fire Charge.png"
itemSprites["Ender Pearl"] = "MOD/sprites/blocks/Ender Pearl.png"

function itemSprites_init()
	for name, path in pairs(itemSprites) do
		itemSprites[name] = LoadSprite(path)
	end
end