local inventoryWidth = 9
local inventoryOpen = false
local inventoryBlockDataOnMouse = {0, 0}

local creativeInventoryItemsTabImagePath = "MOD/sprites/container/creative_tab_items.png"

local itemIconSize = 30

function inventory_init()

end

function inventory_tick()
	if not inventoryOpen then
		return
	end
end

function inventory_draw()
	if not inventoryOpen then
		return
	end
	
	UiPush()
		UiTranslate(-50, -50)
		UiColorFilter(0, 0, 0, 0.75)
		UiRect(UiWidth() + 50, UiHeight() + 50)
	UiPop()
	
	if creativeMode then
		UiPush()
			UiMakeInteractive()
			
			UiAlign("center middle")
			
			UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
			
			UiImageBox(creativeInventoryItemsTabImagePath, 410, 292, -5, -5)
			
			UiPush()
				UiTranslate(-410 / 2, -292 / 2)
				
				local itemIconOffsetX = 16 + itemIconSize * 0.7
				local itemIconOffsetY = 35 + itemIconSize * 0.7
				
				local itemInventoryOffset = itemIconSize + 7.2
				
				UiTranslate(itemIconOffsetX, itemIconOffsetY)
				
				UiPush()
					for i = 0, 4 do
						UiPush()
							for j = 1, 9 do
								if i * 9 + j > #blocks then
									drawCreativeBlockButton(0)
								else
									drawCreativeBlockButton(i * 9 + j)
								end
								UiTranslate(itemInventoryOffset, 0)
							end
						UiPop()
						
						UiTranslate(0, itemInventoryOffset)
					end
				UiPop()
				
				UiTranslate(0, 5 * itemInventoryOffset + 10)
				UiPush()
					for i = 0, 8 do
						drawSurvivalBlockButton(inventoryHotBarStartIndex + i)
						UiTranslate(itemInventoryOffset, 0)
					end
				UiPop()
			UiPop()
		UiPop()
	else
		-- TODO: Survival Inventory
	end
	
	drawItemOnMouse()
end

function drawCreativeBlockButton(blockId)
	if blockId > 0 then
		UiImageBox("MOD/sprites/blocks/" .. blocks[blockId][1] .. ".png", itemIconSize, itemIconSize, 0, 0)
	end
	
	if UiBlankButton(itemIconSize, itemIconSize) then
		if blockId <= 0 then
			setInventoryBlockDataOnMouse(0, 0)
		else
			if inventoryBlockDataOnMouse[1] ~= 0 then
				setInventoryBlockDataOnMouse(0, 0)
			else
				setInventoryBlockDataOnMouse(blockId, 1)
			end
		end
	end
end

function drawSurvivalBlockButton(invId)
	local inventoryData = inventory[invId]
	
	local blockId = inventoryData[1]
	local stackCount = inventoryData[2]
	
	if blockId > 0 then
		UiImageBox("MOD/sprites/blocks/" .. blocks[blockId][1] .. ".png", itemIconSize, itemIconSize, 0, 0)
	end
	
	if UiBlankButton(itemIconSize, itemIconSize) then
		if inventoryBlockDataOnMouse[1] ~= 0 and blockId > 0 then
			local mouseData1 = inventoryBlockDataOnMouse[1]
			local mouseData2 = inventoryBlockDataOnMouse[2]
			
			setInventoryBlockDataOnMouse(blockId, stackCount)
			
			inventoryData[1] = mouseData1
			inventoryData[2] = mouseData2
		elseif inventoryBlockDataOnMouse[1] ~= 0 and blockId <= 0 then
			inventoryData[1] = inventoryBlockDataOnMouse[1]
			inventoryData[2] = inventoryBlockDataOnMouse[2]
			setInventoryBlockDataOnMouse(0, 0)
		else
			setInventoryBlockDataOnMouse(blockId, stackCount)
			inventoryData[1] = 0
			inventoryData[2] = 0
		end
	end
end


function drawItemOnMouse()
	if inventoryBlockDataOnMouse[1] == 0 then
		return
	end
	
	UiPush()
		local mX, mY = UiGetMousePos()
		
		UiTranslate(mX, mY)
		
		UiAlign("center middle")
		
		local blockData = blocks[inventoryBlockDataOnMouse[1]]
		
		UiImageBox("MOD/sprites/blocks/" .. blockData[1] .. ".png", itemIconSize, itemIconSize, 0, 0)
	UiPop()
end

function setInventoryOpen(newValue)
	inventoryOpen = newValue
end

function getInventoryOpen()
	return inventoryOpen
end

function getInventoryBlockDataOnMouse()
	return inventoryBlockDataOnMouse[1], inventoryBlockDataOnMouse[2]
end

function setInventoryBlockDataOnMouse(a, b)
	inventoryBlockDataOnMouse[1] = a
	inventoryBlockDataOnMouse[2] = b
end