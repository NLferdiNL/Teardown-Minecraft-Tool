#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/menu.lua"
#include "scripts/varhandlers.lua"
#include "scripts/inventory.lua"
#include "datascripts/keybinds.lua"
#include "datascripts/inputList.lua"
#include "datascripts/color4.lua"
#include "datascripts/blockData.lua"
#include "datascripts/savedVars.lua"

toolName = "minecraftbuildtool"
toolReadableName = "Minecraft Tool"

-- TODO: Create hotbar, create inventory.

local toolVox = "MOD/vox/tool.vox"

local menu_disabled = false

local selectedBlock = #blocks - 1 --1
local lastFrameTool = ""

local gridOffset = Vec(0, 0, 0)
local blockSize = 16 --10
local gridModulo = blockSize / 10

local modDisabled = false
local drawPlayerLine = false
local dynamicBlock = false
local checkCollision = false
local creativeMode = true

local inventoryOpen = false
local inventoryBlockDataOnMouse = {0, 0}

local holdTimer = 0
local holdTimerMax = {0.5, 0.25, 0.1}

local animTimer = 0
local animTimerMax = 0.05

--					{SHAPE, BLOCKID}
local specialBlocks = {}

local interactionSound = LoadSound("MOD/sfx/stoneDig_0.ogg")
local hotbarImagePath = "MOD/sprites/hotbar.png"
local hotbarSelectorImagePath = "MOD/sprites/hotbar_selector.png"
local crosshairImagePath = "MOD/sprites/crosshair.png"

local hotbarSelectedIndex = 1
local inventory = {}

local mainInventorySize = 9 * 4
local miscInventorySlots = 4 --Armor

for i = 1, mainInventorySize + miscInventorySlots do
	inventory[i] = {0, 0} --{BLOCKID, STACKSIZE}
	
	if i >= 32 then
		inventory[i] = {i - 31, i - 31}
	end
end

function init()
	saveFileInit(savedVars)
	menu_init()
	inventory_init()
	
	RegisterTool(toolName, toolReadableName, toolVox)
	SetBool("game.tool." .. toolName .. ".enabled", true)
	
	--SetString("game.player.tool", toolName)
	
	if Spawn == nil then
		DebugPrint("Minecraft Building Tool requires the experimental build of Teardown.")
		modDisabled = true
	end
	
	if binds["Open_Menu"] == "unbound" then
		binds["Open_Menu"] = "m"
		saveVars(savedVars)
	end
end

function tick(dt)
	HandleSpecialBlocks()
	
	if not menu_disabled then
		menu_tick(dt)
	end
	
	local isMenuOpenRightNow = isMenuOpen()
	
	if isMenuOpenRightNow then
		SetTimeScale(0.1)
	end
	
	ScrollLogic()
	lastFrameTool = GetString("game.player.tool")
	
	if not canUseTool() then
		return
	end
	
	SetString("hud.aimdot", false)
	
	if modDisabled then
		return
	end
	
	if isMenuOpenRightNow then
		return
	end
	
	if InputPressed(binds["Mine"]) then
		RemoveBlock()
		animTimer = animTimerMax
		ToolPlaceBlockAnim()
	end
	
	--[[if InputPressed(binds["Reset_Special_Blocks"]) then
		--DebugPrint("before " .. #specialBlocks)
		GetSpecialBlocks()
		--DebugPrint("after " .. #specialBlocks)
	end]]--
	
	--[[if InputPressed(binds["Set_Offset"]) then
		SetOffset()
	end]]--
	
	if animTimer > 0 then
		animTimer = animTimer - dt
		ToolPlaceBlockAnim()
	end
	
	if InputPressed(binds["Toggle_Dynamic"]) then
		dynamicBlock = not dynamicBlock
	end
	
	if InputPressed(binds["Quit_Tool"]) then
		SetString("game.player.tool", "sledge")
	end
	
	if InputPressed(binds["Open_Inventory"]) then
		inventoryOpen = not inventoryOpen
	end
	
	if InputPressed(binds["Place"]) or InputDown(binds["Place"])then
		if InputDown(binds["Place"]) then
			holdTimer = holdTimer - dt
			
			if holdTimer < 0 then
				PlaceBlock()
				ToolPlaceBlockAnim()
				animTimer = animTimerMax
				holdTimer = holdTimerMax[GetValue("BlockPlacementSpeed")]
			end
		else
			PlaceBlock()
			ToolPlaceBlockAnim()
			animTimer = animTimerMax
		end
	elseif InputReleased(binds["Place"]) then
		holdTimer = 0
	end
	
	AimLogic()
end

function draw(dt)
	menu_draw(dt)
	
	if not canUseTool() or isMenuOpen() then
		return
	end
	
	renderHud()
	renderCrosshair()
end

function GetAimTarget()
	local cameraTransform = GetPlayerCameraTransform()
	local forward = TransformToParentVec(cameraTransform, Vec(0, 0, -1))
	
	local hit, hitPoint, distance, normal, shape = raycast(cameraTransform.pos, forward, 100)
	
	if not hit then
		return false, nil, nil, nil
	end
	
	return hit, hitPoint, normal, shape
end

function RemoveBlock()
	local hit, hitPoint, normal, shape = GetAimTarget()
	
	if not hit then
		return
	end
	
	local blockTag = GetTagValue(shape, "minecraftblockid")
	local blockSpecialData = GetTagValue(shape, "minecraftspecialdata")
	
	if blockTag == "" then
		return
	end
	
	if blockSpecialData ~= "" then
		local dataIndex = tonumber(blockSpecialData)
		table.remove(specialBlocks, dataIndex)
	end
	
	PlaySound(interactionSound, hitPoint)
	
	Delete(shape)
end

function PlaceBlock()
	local hit, hitPoint, normal, shape = GetAimTarget()
	
	if not hit then
		return
	end
	
	local selectedBlockInvData = getCurrentHeldBlockData()
	
	if selectedBlockInvData == nil then
		return
	end
	
	local selectedBlockData = blocks[selectedBlockInvData[1]]
	
	--local hitPointBlockOffset = VecAdd(hitPoint, Vec(-0.8, -0.8, -0.8))
	--local normalOffset = VecAdd(hitPointBlockOffset, VecScale(normal, 0.8))
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, gridModulo / 2))
	local gridAligned = getGridAlignedPos(normalOffset)
	
	local blockRot = Quat()
	
	if selectedBlockData[3].x ~= 0 or selectedBlockData[3].y ~= 0 or selectedBlockData[3].z ~= 0 then
		local playerPos = GetPlayerCameraTransform().pos
	
		playerPos[2] = playerPos[2] - gridModulo / 2
		
		playerPos = getGridAlignedPos(playerPos, 1)
		--[[playerPos = Vec(playerPos[1] + 0.8,
						playerPos[2] + 0.8,
						playerPos[3] + 0.8)]]--
		
		--blockRot = QuatLookAt(gridAligned, playerPos)
		
		local blockEulerX = 0
		local blockEulerY = 0
		local blockEulerZ = 0
		local blockPosOffset = Vec()
		
		if playerPos[2] == gridAligned[2] then
			if selectedBlockData[3].x ~= 0 or selectedBlockData[3].z ~= 0 then
				if playerPos[1] == gridAligned[1] then
					--blockRot = QuatEuler(90 * selectedBlockData[3].x, 0, 0)
					blockEulerX = 90 * selectedBlockData[3].x
					blockPosOffset[2] = blockPosOffset[2] + gridModulo
				elseif playerPos[3] == gridAligned[3] then
					--blockRot = QuatEuler(0, 0, 90 * selectedBlockData[3].z)
					blockEulerZ = 90 * selectedBlockData[3].z
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
				end
			end
		end
			
		if selectedBlockData[3].y ~= 0 then
			if playerPos[1] == gridAligned[1] and playerPos[3] < gridAligned[3] then
				--blockRot = QuatEuler(0, 180 * selectedBlockData[3].y, 0)
				blockEulerY = 180 * selectedBlockData[3].y
				blockPosOffset[1] = blockPosOffset[1] + gridModulo
				blockPosOffset[3] = blockPosOffset[3] + gridModulo
			elseif playerPos[3] == gridAligned[3] and playerPos[1] < gridAligned[1]  then
				--blockRot = QuatEuler(0, -90 * selectedBlockData[3].y, 0)
				blockEulerY = -90 * selectedBlockData[3].y
				blockPosOffset[1] = blockPosOffset[1] + gridModulo
			elseif playerPos[3] == gridAligned[3] and playerPos[1] > gridAligned[1]  then
				--blockRot = QuatEuler(0, 90 * selectedBlockData[3].y, 0)
				blockEulerY = 90 * selectedBlockData[3].y
				blockPosOffset[3] = blockPosOffset[3] + gridModulo
			end
		end
		
		gridAligned = VecAdd(gridAligned, blockPosOffset)
		blockRot = QuatEuler(blockEulerX, blockEulerY, blockEulerZ)
	end
	
	--gridAligned = VecAdd(gridAligned[1] + selectedBlockData[6].x, gridAligned[2] + selectedBlockData[6].y, gridAligned[3] + selectedBlockData[6].z)
	
	--gridAligned = VecAdd(gridAligned, gridOffset)
	
	local blockTransform = Transform(gridAligned, blockRot)
	
	local blockSizeVec = Vec(selectedBlockData[5].x / 16 * blockSize, selectedBlockData[5].y / 16 * blockSize, selectedBlockData[5].z / 16 * blockSize)
	
	local blockSizeXML = "size='" .. blockSizeVec[1] .. " " .. blockSizeVec[2] .. " " .. blockSizeVec[3] .. "'"
	
	local blockOffsetXML = "offset='" .. 16 - selectedBlockData[6].x / 16 * blockSize .. " " .. 16 - selectedBlockData[6].y / 16 * blockSize .. " " .. 16 - selectedBlockData[6].z / 16 * blockSize .. "'"
	
	local blockBrushXML = "brush='" .. selectedBlockData[2]
	
	local collCheckPassed = not checkCollision or CollisionCheck(gridAligned, VecScale(blockSizeVec, blockSize / 100))
	
	if not collCheckPassed then
		return
	end
	
	local extraBlockXML = ""
	
	if selectedBlockData[9] ~= nil then
		extraBlockXML = selectedBlockData[9]
	end
	
	local blockXML = "<voxbox " .. blockSizeXML .. " " .. blockOffsetXML .. " prop='" .. tostring(dynamicBlock or selectedBlockData[8]) .. "' " .. blockBrushXML .. "' " .. selectedBlockData[4] .. ">" .. extraBlockXML .. "</voxbox>"
	
	local block = Spawn(blockXML, blockTransform, not dynamicBlock, true)[1]
	
	local hasSpecialData = 0
	
	if selectedBlockData[7] ~= nil then
		specialBlocks[#specialBlocks + 1] = {block, selectedBlock}
		hasSpecialData = #specialBlocks
	end
	
	PlaySound(interactionSound, gridAligned)
	
	if GetEntityType(block) == "body" then
		block = GetBodyShapes(block)[1]
	else
		SetTag(block, "minecraftblockid", selectedBlock)
		if hasSpecialData > 0 then
			SetTag(block, "minecraftspecialdata", hasSpecialData)
		end
	end
	
	SetTag(block, "minecraftblockid", selectedBlock)
	if hasSpecialData > 0 then
		SetTag(block, "minecraftspecialdata", hasSpecialData)
	end
	
	if not creativeMode then
		selectedBlockInvData[2] = selectedBlockInvData[2] - 1
		if selectedBlockInvData[2] <= 0 then
			selectedBlockInvData[1] = 0
			selectedBlockInvData[2] = 0
		end
	end
end

function CollisionCheck(pos, size)
	local margin = 0.05

	local minPos = Vec(pos[1] + margin, pos[2] + margin, pos[3] + margin)
	local maxPos = Vec(pos[1] + size[1] / 2 - margin, 
					   pos[2] + size[2] / 2 - margin, 
					   pos[3] + size[3] / 2 - margin)
	
	local shapes = QueryAabbShapes(minPos, maxPos)
	
	return #shapes <= 0
end

function AimLogic()
	local hit, hitPoint, normal, shape = GetAimTarget()
	
	if not hit then
		return
	end
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo / 2))
	local gridAligned = getGridAlignedPos(normalOffset)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	--blockOffset = VecAdd(blockOffset, gridOffset)
	
	--local hitPointBlockOffset = VecAdd(hitPoint, Vec(-0.8, -0.8, -0.8))
	--local normalOffset = VecAdd(hitPointBlockOffset, VecScale(normal, 0.8))
	
	renderBlockOutline(blockOffset, false)
	
	if drawPlayerLine then
		local playerPos = GetPlayerCameraTransform().pos
		
		playerPos[2] = playerPos[2] - gridModulo / 2
		
		playerPos = getGridAlignedPos(playerPos, 1)
		playerPos = Vec(playerPos[1] + gridModulo / 2,
						playerPos[2] + gridModulo / 2,
						playerPos[3] + gridModulo / 2)
		
		DebugLine(playerPos, blockOffset)
	end
end

function ToolPlaceBlockAnim()
	SetToolTransform(Transform(Vec(0, 0, -0.05), QuatEuler(-36, 44, 22)))
end

function ScrollLogic()
	if GetValue("NumbersToSelect") and GetString("game.player.tool") then
		for i = 1, 9 do
			local numberKeyDown = InputPressed(tostring(i))
			
			if numberKeyDown then
				hotbarSelectedIndex = i
				SetString("game.player.tool", toolName)
				return
			end
		end
	end

	local scrollDiff = 0
	
	if GetValue("ScrollToSelect") then
		scrollDiff = InputValue(binds["Scroll"])
	
		if scrollDiff == 0 then
			return
		end
	
		if scrollDiff ~= 0 and GetString("game.player.tool") ~= toolName and lastFrameTool == toolName then
			SetString("game.player.tool", toolName)
		end
	else
		if InputPressed(binds["Prev_Block"]) then
			scrollDiff = scrollDiff - 1
		end
		
		if InputPressed(binds["Next_Block"]) then
			scrollDiff = scrollDiff + 1
		end
	end
	
	if scrollDiff > 0 then
		selectedBlock = selectedBlock + 1
		hotbarSelectedIndex = hotbarSelectedIndex - 1
		if selectedBlock > #blocks then
			selectedBlock = 1
		end
		
		if hotbarSelectedIndex < 1 then
			hotbarSelectedIndex = 9
		end
	elseif scrollDiff < 0 then
		selectedBlock = selectedBlock - 1
		hotbarSelectedIndex = hotbarSelectedIndex + 1
		if selectedBlock < 1 then
			selectedBlock = #blocks
		end
		
		if hotbarSelectedIndex > 9 then
			hotbarSelectedIndex = 1
		end
	end
end

--[[function GetSpecialBlocks()
	local specialBlocks = FindShapes("minecraftspecialdata", true)
	specialBlocks = {}
	
	for i = 1, #specialBlocks do
		local currentSpecialBlock = specialBlocks[i]
		
		local currentBlockId = tonumber(setTag(currentSpecialBlock, "minecraftblockid"))
		
		specialBlocks[#specialBlocks + 1] = blocks[currentBlockId][7]
		
		SetTag(block, "minecraftspecialdata", #specialBlocks)
	end
end]]--

function SetOffset()
	local hit, hitPoint, normal, shape = GetAimTarget()
	
	if not hit then
		return
	end
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo / 2))
	local gridAligned = getGridAlignedPos(hitPoint)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	gridOffset = Vec(hitPoint[1] - blockOffset[1], hitPoint[2] - blockOffset[2], hitPoint[3] - blockOffset[3])
	
	DebugPrint(VecToString(gridOffset))
end

function HandleSpecialBlocks()
	for i = #specialBlocks, 1, -1 do
		local currentSpecialBlock = specialBlocks[i]
		
		if currentSpecialBlock ~= nil then
			local currentShape = currentSpecialBlock[1]
			if IsShapeBroken(currentSpecialBlock[1]) then
				table.remove(specialBlocks, i)
			else
				local blockId = currentSpecialBlock[2]
				
				blocks[blockId][7](currentShape)
			end
		end
	end
end

function canUseTool()
	return GetString("game.player.tool") == toolName and GetPlayerVehicle() == 0
end

function getGridAlignedPos(pos, modulo)
	if modulo == nil then
		modulo = gridModulo
	end

	return Vec(pos[1] - (pos[1]) % gridModulo,
			   pos[2] - (pos[2]) % gridModulo,
			   pos[3] - (pos[3]) % gridModulo)
end

function getCurrentHeldBlockData(index)
	index = index or hotbarSelectedIndex - 1

	local inventoryStartIndex = #inventory - 8

	local currInvData = inventory[inventoryStartIndex + index]
	
	if currInvData[1] == 0 or currInvData[2] == 0 then
		return nil
	end
	
	return currInvData
end

function renderHud()
	UiPush()
		UiAlign("center middle")
		
		local hotbarWidth = 364 * 2
		local hotbarHeight = 44 * 2
		
		local selectorWidth = 48 * 2
		local selectorHeight = 48 * 2
		
		local arbitraryIndexNumber = 0.8357 -- Don't like this solution, but it works.
		
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.92)
		
		UiImageBox(hotbarImagePath, hotbarWidth, hotbarHeight, 0, 0)
		
		UiAlign("center left")
		
		UiTranslate(-hotbarWidth / 2 + selectorWidth / 2 - 5, -selectorHeight / 2)
		
		UiPush()
			UiTranslate((hotbarSelectedIndex - 1) * (selectorWidth * arbitraryIndexNumber), 0)
			UiImageBox(hotbarSelectorImagePath, selectorWidth, selectorHeight, 0, 0)
		UiPop()
		
		UiPush()
			UiTranslate(0, selectorHeight / 2)
			UiFont("MOD/fonts/MinecraftRegular.ttf", 40)
			UiTextShadow(0.25, 0.25, 0.25, 1, 2 / 26 * 40, 0)
			for i = 0, 8 do
				UiPush()
					local currInvData = getCurrentHeldBlockData(i)
					
					if currInvData ~= nil then
						local currBlockId = currInvData[1]
						local currBlockStackSize = currInvData[2]
						
						if currBlockId > 0 and currBlockStackSize > 0 then
							local blockName = blocks[currBlockId][1]
							UiAlign("center middle")
							UiTranslate(i * (selectorWidth * arbitraryIndexNumber))
							UiImageBox("MOD/sprites/blocks/" .. blockName .. ".png", selectorWidth / 2, selectorHeight / 2, 0, 0)
							
							if currBlockStackSize > 1 then
								UiTranslate(selectorHeight / 4, selectorHeight / 4)
								UiText(currBlockStackSize)
							end
							--UiText(blocks[currBlockId][1])
						end
					end
				UiPop()
			end
		UiPop()
	UiPop()

	if true then
		return
	end

	UiPush()
		UiAlign("center left")
		
		UiTranslate(UiWidth() * 0.5, UiHeight() * (0.96))
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		
		if modDisabled then
			UiText("Minecraft Building Tool requires the experimental build of Teardown.")
		else
			if GetValue("ScrollToSelect") then
				UiText(blocks[selectedBlock][1])
			else
				UiText("<[" .. binds["Prev_Block"]:upper() .. "] - " .. blocks[selectedBlock][1] .. " - [" .. binds["Next_Block"]:upper() .. "]>")
			end
		end
		
		UiTranslate(-75, -30)
		
		drawStatusBox("[" .. binds["Toggle_Dynamic"]:upper() .. "] Dynamic Block", dynamicBlock)
		--drawToggle("[" .. binds["Toggle_Walk_Mode"]:upper() .. "] to toggle walk speed.", walkModeActive)
		
	UiPop()
end

function renderCrosshair()
	local crosshairSize = 25
	UiPush()
		UiAlign("center middle")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
		UiImageBox(crosshairImagePath, crosshairSize, crosshairSize)
	UiPop()
end

function renderBlockOutline(pos, renderFaces)
	local minPos = VecAdd(pos, Vec(-gridModulo / 2, -gridModulo / 2, -gridModulo / 2))
	local maxPos = VecAdd(pos, Vec(gridModulo / 2, gridModulo / 2, gridModulo / 2))
	
	local color = 0.1

	renderAabbZone(minPos, maxPos, color, color, color, 0.8, renderFaces)
end