#include "scripts/items/enderpearl.lua"
#include "scripts/items/flintandsteel.lua"
#include "scripts/items/firecharge.lua"
#include "scripts/items/droppeditem.lua"
#include "scripts/world/portal.lua"

itemData = {
--	Name		    = {init,		   update			 finish
	["Ender Pearl"] = {enderPearlInit, enderPearlUpdate},
	["Flint And Steel"] = {flintAndSteelInit, flintAndSteelUpdate},
	["Fire Charge"] = {fireChargeInit, fireChargeUpdate},
	["Dropped Item"] = {droppedInit, droppedUpdate},	["Portal"] = {nil, portalUpdate},
}

itemSprites = {
--	Name		    = spritePath.png
	["Fire Charge"] = "MOD/sprites/blocks/Fire Charge.png",
	["Ender Pearl"] = "MOD/sprites/blocks/Ender Pearl.png",
}

function itemSprites_init()
	for name, path in pairs(itemSprites) do
		itemSprites[name] = LoadSprite(path)
	end
end