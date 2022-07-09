local inventoryWidth = 9
local inventoryOpen = false
local inventoryBlockDataOnMouse = {0, 0}
local inventoryIdMouseOver = {0, 0}

local creativeInventoryItemsTabImagePath = "MOD/sprites/container/creative_tab_items.png"
local creativeInventoryScrollBarImagePath = "MOD/sprites/container/scrollbar.png"
local creativeInventoryScrollBarDownImagePath = "MOD/sprites/container/scrollbar_down.png"

local scaling = 1
local itemIconSize = 30 * scaling
local creativeInventoryScroll = 0
local maxCreativeInventoryScroll = 0
local scrollbarHeld = false
local scrollbarMouseOffset = {0, 0}
local mouseInInventory = false

local font = "MOD/fonts/MinecraftRegular.ttf"
local fontSize = 26
local descriptionBoxBg = "MOD/sprites/square.png"
local descriptionBoxMargin = 20

function inventory_init(uiScale)
	setInventoryScaling(uiScale)
	maxCreativeInventoryScroll = math.ceil(#blocks / 9) - 5
end

function inventory_tick(dt)
	if not inventoryOpen then
		return
	end
	
	--DebugWatch("scroll", creativeInventoryScroll)
	--DebugWatch("max", maxCreativeInventoryScroll)
	
	if mouseInInventory then
		if creativeMode then
			creativeInventoryScroll = creativeInventoryScroll - InputValue(binds["Scroll"])
			
			if creativeInventoryScroll < 0 then
				creativeInventoryScroll = 0
			elseif creativeInventoryScroll > maxCreativeInventoryScroll then
				creativeInventoryScroll = maxCreativeInventoryScroll
			end
			
			if inventoryBlockDataOnMouse[1] == 0 and inventoryIdMouseOver[2] ~= 0 then 
				for i = 1, 9 do
					if InputPressed(i) then
						local currSlot = inventoryHotBarStartIndex + i - 1
						
						local inventoryData = inventory[currSlot]
	
						inventoryData[1] = inventoryIdMouseOver[2]
						inventoryData[2] = 1
					end
				end
			end
		else
			-- Survival inventory
		end
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
			
			local bgImageWidth = 410 * scaling
			local bgImageHeight = 292 * scaling
			local marginX = 16 * scaling
			local marginY = 35 * scaling
			
			local scrollbarWidth = 120 * scaling / 4.5
			local scrollbarHeight = 150 * scaling / 4.5
			
			local creatveInvScrolBarPositionOne = (bgImageHeight - marginY * 2.7) / maxCreativeInventoryScroll
			
			UiImageBox(creativeInventoryItemsTabImagePath, bgImageWidth, bgImageHeight, -5, -5)
			
			UiPush()
				local itemIconOffsetX = marginX + itemIconSize * 0.7
				local itemIconOffsetY = marginY + itemIconSize * 0.7
				
				mouseInInventory = UiIsMouseInRect(bgImageWidth - marginX * 2, bgImageHeight - marginY * 2 - itemIconOffsetY)
				
				local itemInventoryOffset = itemIconSize + 7.2 * scaling
				
				UiTranslate(-bgImageWidth / 2, -bgImageHeight / 2)
				
				UiTranslate(itemIconOffsetX, itemIconOffsetY)
				
				inventoryIdMouseOver = {0, 0}
				
				UiPush() -- Creative inv
					for i = 0, 4 do
						UiPush()
							for j = 1, 9 do
								local currItemId = (i + creativeInventoryScroll) * 9 + j
								if (currItemId > #blocks) then
									drawCreativeBlockButton(0, false)
								else
									local mouseOver = false
									
									if UiIsMouseInRect(itemIconSize, itemIconSize) then
										inventoryIdMouseOver = {i * 9 + j, currItemId}
										mouseOver = true
									end
									
									drawCreativeBlockButton(currItemId, mouseOver)
									
								end
								UiTranslate(itemInventoryOffset, 0)
							end
						UiPop()
						
						UiTranslate(0, itemInventoryOffset)
					end
				UiPop()
				
				UiPush() --Creative scroll bar
					UiTranslate(bgImageWidth - itemIconOffsetX * 1.95, creatveInvScrolBarPositionOne * creativeInventoryScroll)
					local mouseInScrollBar = UiIsMouseInRect(scrollbarWidth, scrollbarHeight)
					if (mouseInScrollBar or scrollbarHeld) and InputDown("lmb") then
						UiImageBox(creativeInventoryScrollBarDownImagePath, scrollbarWidth, scrollbarHeight, 0, 0)
						
						UiTranslate(0, -creatveInvScrolBarPositionOne * creativeInventoryScroll)
						local mX, mY = UiGetMousePos()
						
						scrollbarHeld = true
						
						
						local mousePosToScrollBar = math.ceil((mY - creatveInvScrolBarPositionOne / 2) / creatveInvScrolBarPositionOne)
						--DebugWatch("pos", mousePosToScrollBar)
						
						if mousePosToScrollBar < 0 then
							mousePosToScrollBar = 0
						elseif mousePosToScrollBar > maxCreativeInventoryScroll then
							mousePosToScrollBar = maxCreativeInventoryScroll
						end
						
						creativeInventoryScroll = mousePosToScrollBar
					else
						scrollbarHeld = false
						UiImageBox(creativeInventoryScrollBarImagePath, scrollbarWidth, scrollbarHeight, 0, 0)
					end
				UiPop()
				
				UiTranslate(0, 5 * itemInventoryOffset + 10 * scaling)
				UiPush() -- Hotbar
					for i = 0, 8 do
						local currInvSlot = inventoryHotBarStartIndex + i
						local mouseOver = false
						
						if UiIsMouseInRect(itemIconSize, itemIconSize) then
							inventoryIdMouseOver = {i + 1, inventory[currInvSlot][1]}
							mouseOver = true
						end
						
						drawSurvivalBlockButton(currInvSlot, mouseOver)
						
						UiTranslate(itemInventoryOffset, 0)
					end
				UiPop()
			UiPop()
		UiPop()
	else
		-- TODO: Survival Inventory
	end
	
	drawItemOnMouse()
	drawItemDescOnMouse()
end

function drawCreativeBlockButton(blockId, mouseOver)
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
				local stackSize = 1
				
				if InputDown("shift") then
					stackSize = 64
				end
				
				setInventoryBlockDataOnMouse(blockId, stackSize)
			end
		end
	end
end

function drawSurvivalBlockButton(invId, mouseOver)
	local inventoryData = inventory[invId]
	
	local blockId = inventoryData[1]
	local stackCount = inventoryData[2]
	local blockMaxStackSize = 64
	
	if blockId > 0 then
		UiImageBox("MOD/sprites/blocks/" .. blocks[blockId][1] .. ".png", itemIconSize, itemIconSize, 0, 0)
	end
	
	local rmbDown = InputPressed("rmb")
	
	if UiBlankButton(itemIconSize, itemIconSize) or (mouseOver and rmbDown) then
		if blockId == 0 and inventoryBlockDataOnMouse[1] == 0 then
			return
		end
		
		local lmbDown = not rmbDown
		
		if lmbDown then
			--DebugPrint("0")
			if inventoryBlockDataOnMouse[1] ~= 0 and blockId ~= inventoryBlockDataOnMouse[1] then
				--DebugPrint("0-0")
				local mouseData1 = inventoryBlockDataOnMouse[1]
				local mouseData2 = inventoryBlockDataOnMouse[2]
				
				setInventoryBlockDataOnMouse(blockId, stackCount)
				
				inventoryData[1] = mouseData1
				inventoryData[2] = mouseData2
			elseif blockId == inventoryBlockDataOnMouse[1] then
				--DebugPrint("0-1")
				if inventoryBlockDataOnMouse[2] + stackCount > blockMaxStackSize then
					local overflow = stackCount + inventoryBlockDataOnMouse[2] - blockMaxStackSize
					inventoryBlockDataOnMouse[2] = overflow
					inventoryData[2] = blockMaxStackSize
				else
					inventoryData[2] = stackCount + inventoryBlockDataOnMouse[2]
					
					setInventoryBlockDataOnMouse(0, 0)
				end
			else
				--DebugPrint("0-2")
				setInventoryBlockDataOnMouse(blockId, stackCount)
				inventoryData[1] = 0
				inventoryData[2] = 0
			end
		elseif rmbDown then
			--DebugPrint("1")
			if inventoryBlockDataOnMouse[1] ~= 0 and (blockId == inventoryBlockDataOnMouse[1] or blockId == 0) and stackCount < blockMaxStackSize then
				--DebugPrint("1-0")
				inventoryData[1] = inventoryBlockDataOnMouse[1]
				inventoryData[2] = inventoryData[2] + 1
				
				if inventoryBlockDataOnMouse[2] - 1 <= 0 then
					setInventoryBlockDataOnMouse(0, 0)
				else
					setInventoryBlockDataOnMouse(inventoryBlockDataOnMouse[1], inventoryBlockDataOnMouse[2] - 1)
				end
			elseif inventoryBlockDataOnMouse[1] == 0 and blockId ~= 0 then
				--DebugPrint("1-1")
				if stackCount > 1 then
					local halfStackCount = math.ceil(stackCount / 2)
					setInventoryBlockDataOnMouse(blockId, halfStackCount)
					
					inventoryData[2] = stackCount - halfStackCount
				else
					setInventoryBlockDataOnMouse(blockId, stackCount)
					inventoryData[1] = 0
					inventoryData[2] = 0
				end
			end
		end
		
		--[[
		if inventoryBlockDataOnMouse[1] ~= 0 and blockId > 0 and (not rmbDown or (lmbDown and inventoryBlockDataOnMouse[1] == blockId)) then
			DebugPrint("a")
			if inventoryBlockDataOnMouse[1] == blockId then
				if inventoryBlockDataOnMouse[2] + stackCount + inventoryBlockDataOnMouse[2] > blockMaxStackSize then
					local overflow = stackCount + inventoryBlockDataOnMouse[2] - blockMaxStackSize
					inventoryBlockDataOnMouse[2] = overflow
					inventoryData[2] = blockMaxStackSize
				else
					inventoryData[2] = stackCount + inventoryBlockDataOnMouse[2]
					
					setInventoryBlockDataOnMouse(0, 0)
				end
			else
				local mouseData1 = inventoryBlockDataOnMouse[1]
				local mouseData2 = inventoryBlockDataOnMouse[2]
				
				setInventoryBlockDataOnMouse(blockId, stackCount)
				
				inventoryData[1] = mouseData1
				inventoryData[2] = mouseData2
			end
		elseif (inventoryBlockDataOnMouse[1] ~= 0 and blockId <= 0) or (inventoryBlockDataOnMouse[1] == blockId) then
			DebugPrint("b")
			if rmbDown and stackCount < blockMaxStackSize then
				DebugPrint("b-a")
				inventoryData[1] = inventoryBlockDataOnMouse[1]
				inventoryData[2] = inventoryData[2] + 1
				
				inventoryBlockDataOnMouse[2] = inventoryBlockDataOnMouse[2] - 1
				
				if inventoryBlockDataOnMouse[2] <= 0 then
					inventoryBlockDataOnMouse[1] = 0
				end
			else
				DebugPrint("b-b")
				inventoryData[1] = inventoryBlockDataOnMouse[1]
				inventoryData[2] = inventoryBlockDataOnMouse[2]
				setInventoryBlockDataOnMouse(0, 0)
			end
		else
			DebugPrint("c")
			if rmbDown and stackCount > 1 then
				local halfStackCount = math.ceil(stackCount / 2)
				setInventoryBlockDataOnMouse(blockId, halfStackCount)
				
				inventoryData[2] = stackCount - halfStackCount
			else
				setInventoryBlockDataOnMouse(blockId, stackCount)
				inventoryData[1] = 0
				inventoryData[2] = 0
			end
		end]]--
	end
	
	if stackCount > 1 then
		UiPush()
			UiFont(font, fontSize * 1.5)
			UiTextShadow(0.25, 0.25, 0.25, 1, 2 / 26 * 40, 0)
			UiTranslate(itemIconSize / 4, itemIconSize / 4)
			UiText(stackCount)
		UiPop()
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
		
		if inventoryBlockDataOnMouse[2] > 1 then
			UiPush()
				UiFont(font, fontSize * 1.5)
				UiTextShadow(0.25, 0.25, 0.25, 1, 2 / 26 * 40, 0)
				UiTranslate(itemIconSize / 4, itemIconSize / 4)
				UiText(inventoryBlockDataOnMouse[2])
			UiPop()
		end
	UiPop()
end

function drawItemDescOnMouse()
	if inventoryBlockDataOnMouse[1] ~= 0 or inventoryIdMouseOver[1] <= 0 or inventoryIdMouseOver[2] <= 0 then
		return
	end
	
	local currBlockData = inventory[inventoryIdMouseOver]
	
	local blockData = nil
	
	if creativeMode	then
		blockData = blocks[inventoryIdMouseOver[2]]
	else
		blockData = blocks[inventory[inventoryIdMouseOver[1]][1]]
	end
	
	if blockData ~= nil then
		local blockName = blockData[1]
		
		drawDescriptionOnMouse(blockName)
	end
end

function drawDescriptionOnMouse(text)
	UiPush()
		UiFont(font, fontSize)
		
		if text ~= nil and text ~= "" then
			local mX, mY = UiGetMousePos()
			
			UiAlign("top left")
			
			UiTranslate(mX, mY)
			
			local textWidth, textHeight = UiGetTextSize(text)
					
			local boxWidth = mX + textWidth + descriptionBoxMargin
			
			local textOffsetX = 10
			
			if boxWidth > UiWidth() then
				UiAlign("top right")
				textOffsetX = -10
			end
			
			UiColor(0, 0, 0, 1)
			UiImageBox(descriptionBoxBg, textWidth + descriptionBoxMargin, textHeight + descriptionBoxMargin, 0, 0)
			
			UiTranslate(textOffsetX, 10)
			
			UiColor(1, 1, 1, 1)
			UiText(text)
		end
	UiPop()
end

function setInventoryScaling(newValue)
	scaling = newValue
	itemIconSize = 30 * scaling
end

function setInventoryOpen(newValue)
	inventoryOpen = newValue
	
	if not inventoryOpen then
		mouseInInventory = false
		creativeInventoryScroll = 0
	end
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