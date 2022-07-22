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
local toolSlot = nil

-- TODO: Add dropping items.
-- TODO: Fix "block of ___" insides to be random.
-- TODO: Fix fence connection positioning.
-- TODO: Half fence connection when connecting to a block to prevent overlap.
-- MAYBE: Trapdoor use log alignment?

local toolVox = "MOD/vox/tool.vox"

local menu_disabled = false

--local selectedBlock = #blocks - 1 --1
local lastFrameTool = ""

local gridOffset = Vec(0, 0, 0)
local blockSize = 16 --10
local gridModulo = blockSize / 10

local modDisabled = false
local drawPlayerLine = false
local dynamicBlock = false
local checkCollision = false
creativeMode = true

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

local font = "MOD/fonts/MinecraftRegular.ttf"

local hotbarSelectedIndex = 1
inventory = {}

local mainInventorySize = 9 * 4
local miscInventorySlots = 4 --Armor

local itemSwitchTimer = 0
local itemSwitchTimerMax = 10
local itemSwitchTimerHalf = itemSwitchTimerMax / 2

for i = 1, mainInventorySize + miscInventorySlots do
	inventory[i] = {0, 0} --{BLOCKID, STACKSIZE}
	
	if i >= 32 then
		inventory[i] = {i - 31, 1}
		
		if i == 32 then
			inventory[i][1] = 40
		end
	end
end

inventoryHotBarStartIndex = #inventory - 8

inventoryScales = {1, 1.5, 2}

-- Aim variables
local hit = false
local hitPoint = Vec()
local distance = 0
local normal = Vec()
local shape = 0

local fencePosOffset = gridModulo / 16 * 8

local canGrabObject = false

local debugstart = true
local debugstarted = false

function init()
	saveFileInit(savedVars)
	menu_init()
	inventory_init(inventoryScales[GetValue("InventoryUIScale")])
	
	if toolSlot ~= nil then
		RegisterTool(toolName, toolReadableName, toolVox, toolSlot)
	else
		RegisterTool(toolName, toolReadableName, toolVox)
	end
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
	if debugstart and not debugstarted then
		debugstarted = true
		SetString("game.player.tool", toolName)
	end

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
	
	inventory_tick(dt)
	
	if not canUseTool() then
		return
	end
	
	--SetBool("hud.aimdot", false)
	SetBool("hud.disable", true)
	
	if itemSwitchTimer > 0 then
		itemSwitchTimer = itemSwitchTimer - dt * 8
	end
	
	if modDisabled then
		return
	end
	
	if InputPressed(binds["Open_Inventory"]) or (getInventoryOpen() and InputPressed("esc")) then
		if InputPressed("esc") then
			SetPaused(false)
		end
		
		local inventoryOpen = getInventoryOpen()
		if inventoryOpen then
			-- Drop Mouse Held Item()
			local blockId, stackSize = getInventoryBlockDataOnMouse()
			
			setInventoryBlockDataOnMouse(0, 0)
		end
		
		setInventoryOpen(not inventoryOpen)
	end
	
	if isMenuOpenRightNow  or getInventoryOpen() then
		return
	end
	
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
	
	AimLogic()
	
	if InputPressed(binds["Mine"]) then
		RemoveBlock()
		animTimer = animTimerMax
		ToolPlaceBlockAnim()
	end
	
	if InputPressed(binds["Pick_Block"]) then
		PickBlock()
	end
	
	if canGrabObject or GetPlayerGrabBody() ~= 0 or GetPlayerGrabShape() ~= 0 then
		return
	end
	
	if (InputPressed(binds["Place"]) or InputDown(binds["Place"])) and (GetPlayerGrabBody() == 0 or GetPlayerGrabShape() == 0) then
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
end

function draw(dt)
	menu_draw(dt)
	
	if not canUseTool() or isMenuOpen() then
		return
	end
	
	renderHud()
	
	inventory_draw()
	
	if not getInventoryOpen() then
		renderCrosshair()
	end
end

function GetAimTarget()
	local cameraTransform = GetPlayerCameraTransform()
	local forward = TransformToParentVec(cameraTransform, Vec(0, 0, -1))
	
	local hit, hitPoint, distance, normal, shape = raycast(cameraTransform.pos, forward, 100)
	
	if not hit then
		return false, nil, nil, nil
	end
	
	return hit, hitPoint, distance, normal, shape
end

function PickBlock()
	if not hit then
		return
	end
	
	local blockTag = GetTagValue(shape, "minecraftblockid")
	local aimBlockId = tonumber(blockTag)
	
	if aimBlockId == nil or aimBlockId <= 0 then
		return
	end
	
	local found = false
	
	for i = 0, 8 do
		local selectedBlockInvData = getCurrentHeldBlockData(i)
		local currBlockId = selectedBlockInvData[1]
		
		if currBlockId == aimBlockId then
			found = true
			hotbarSelectedIndex = i + 1
			break
		end
	end
	
	if creativeMode and not found then
		inventory[inventoryHotBarStartIndex + hotbarSelectedIndex - 1] = {aimBlockId, 1}
	end
end

function setupBlockBreakParticles()
	ParticleReset()
	ParticleType("plain")
	ParticleTile(6)
	ParticleRadius(0.05)
	ParticleGravity(-9.807)
	ParticleStretch(0)
	ParticleCollide(1)
	ParticleSticky(0.25)
end

function spawnBrokenBlockParticles(blockShape)
	local blockTransform = GetShapeWorldTransform(blockShape) 
	local blockCenter = VecAdd(blockTransform.pos, Vec(blockSize / 10 / 2, blockSize / 10 / 2, blockSize / 10 / 2))
	local blockBoundsMin, blockBoundsMax = GetShapeBounds(blockShape)
	
	local dist = VecDist(blockBoundsMin, blockBoundsMax)
	
	--spawnDebugParticle(blockCenter, 2, Color4.Red)
	
	setupBlockBreakParticles()
	
	for i = 1, math.ceil(50 / 2.8 * dist) do
		--local randomDir = rndVec(blockSize / 10 / 2)
		local particlePos = GetRandomPosBetween(blockBoundsMin, blockBoundsMax) --VecAdd(blockCenter, randomDir)
		local matType, bR, bG, bB, bA = GetShapeMaterialAtPosition(blockShape, particlePos)
		
		local particleLifetime = math.abs(math.random() * 0.5 + 2.5)
		
		local particleVel = VecDir(blockCenter, particlePos)
		
		ParticleColor(bR, bG, bB)
		ParticleAlpha(bA)
		SpawnParticle(particlePos, particleVel, particleLifetime)
	end
end

function RemoveBlock()
	if not hit then
		return
	end
	
	local blockTag = GetTagValue(shape, "minecraftblockid")
	
	if blockTag == "" then
		return
	end
	
	local blockSpecialData = GetTagValue(shape, "minecraftspecialdata")
	
	local blockConnectedShapes = GetTagValue(shape, "minecraftconnectedshapes")
	
	if blockConnectedShapes ~= nil and blockConnectedShapes ~= "" then
		RemoveConnectedShapes(blockConnectedShapes)
	end
	
	if blockSpecialData ~= "" then
		local dataIndex = tonumber(blockSpecialData)
		table.remove(specialBlocks, dataIndex)
	end
	
	PlaySound(interactionSound, hitPoint)
	
	spawnBrokenBlockParticles(shape)
	
	Delete(shape)
end

function PlaceBlock()
	if not hit then
		return
	end
	
	local selectedBlockInvData = getCurrentHeldBlockData()
	
	if selectedBlockInvData == nil then
		return
	end
	
	local selectedBlockId = selectedBlockInvData[1]
	local selectedBlockData = blocks[selectedBlockId]
	
	--local hitPointBlockOffset = VecAdd(hitPoint, Vec(-0.8, -0.8, -0.8))
	--local normalOffset = VecAdd(hitPointBlockOffset, VecScale(normal, 0.8))
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, gridModulo * 0.1))
	local gridAligned = getGridAlignedPos(normalOffset)
	
	local blockRot = Quat()
	
	local playerCameraTransform = GetPlayerCameraTransform()
	local playerPos = playerCameraTransform.pos
	
	playerPos[2] = playerPos[2] - gridModulo / 2
	
	playerPos = getGridAlignedPos(playerPos, 1)
	--[[playerPos = Vec(playerPos[1] + 0.8,
					playerPos[2] + 0.8,
					playerPos[3] + 0.8)]]--
	
	--blockRot = QuatLookAt(gridAligned, playerPos)
	
	if math.abs(gridAligned[1] - playerPos[1]) < math.abs(gridAligned[3] - playerPos[3]) then
		playerPos[1] = gridAligned[1]
	else
		playerPos[3] = gridAligned[3]
	end
	
	local blockEulerX = 0
	local blockEulerY = 0
	local blockEulerZ = 0
	local blockPosOffset = Vec()
	
	if GetValue("OldRotationMethod") then
		if selectedBlockData[3].x ~= 0 or selectedBlockData[3].y ~= 0 or selectedBlockData[3].z ~= 0 then
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
		end
	else
		if (selectedBlockData[3].x ~= 0 or selectedBlockData[3].z ~= 0) and selectedBlockData[3].y == 0 then
			local gridAlignedHitPoint = getGridAlignedPos(VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1)))
			
			--DebugWatch("a", gridAligned)
			--DebugWatch("b", gridAlignedHitPoint)
			
			if gridAlignedHitPoint[1] == gridAligned[1] and gridAlignedHitPoint[2] == gridAligned[2] then
				blockEulerX = 90 * selectedBlockData[3].x
				blockPosOffset[2] = blockPosOffset[2] + gridModulo
			elseif gridAlignedHitPoint[3] == gridAligned[3] and gridAlignedHitPoint[2] == gridAligned[2] then
				blockEulerZ = 90 * selectedBlockData[3].z
				blockPosOffset[1] = blockPosOffset[1] + gridModulo
			end
		end
		
		if selectedBlockData[3].y ~= 0 then
			if selectedBlockData[9] == 5 and hitPoint[2] + normal[2] * 0.01 > gridAligned[2] + blockSize / 10 / 2 then
				blockEulerZ = blockEulerZ - 180
				if playerPos[1] == gridAligned[1] and playerPos[3] < gridAligned[3] then
					blockEulerY = 180 * selectedBlockData[3].y
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
				elseif playerPos[3] == gridAligned[3] and playerPos[1] < gridAligned[1] then
					blockEulerY = -90 * selectedBlockData[3].y
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
				elseif playerPos[3] == gridAligned[3] and playerPos[1] > gridAligned[1] then
					blockEulerY = 90 * selectedBlockData[3].y
				else
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
				end
				
				gridAligned = VecAdd(gridAligned, Vec(0, gridModulo, 0))
			else
				if playerPos[1] == gridAligned[1] and playerPos[3] < gridAligned[3] then
					blockEulerY = 180 * selectedBlockData[3].y
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
				elseif playerPos[3] == gridAligned[3] and playerPos[1] < gridAligned[1]  then
					blockEulerY = -90 * selectedBlockData[3].y
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
				elseif playerPos[3] == gridAligned[3] and playerPos[1] > gridAligned[1]  then
					blockEulerY = 90 * selectedBlockData[3].y
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
				end
			end
		end
	end
	
	--[[
	local alignOffset = Vec()
			
	--if otherBlockTransform.pos[1] == gridAligned.po
	DebugPrint(VecToString(gridAligned))
	DebugPrint(VecToString(otherBlockTransform.pos))
	
	--blockRot = QuatRotateQuat(blockRot, QuatEuler(0, 180, 0)
	--gridAligned = VecAdd(gridAligned, alignOffset)
	]]--
	
	local mirrorJointLimits = nil
	local connectedShapesTag = ""
	
	if selectedBlockData[9] > 1 then
		local otherBlock = shape
		local otherBlockId = 0
		local otherBlockType = 1
		local otherBlockTransform = GetShapeWorldTransform(otherBlock)
		
		if HasTag(shape, "minecraftblockid") then
			otherBlockId = tonumber(GetTagValue(shape, "minecraftblockid"))
			otherBlockType = blocks[otherBlockId][9]
		end
	
		if selectedBlockData[9] == 2 then
			local playerRotX, playerRotY, playerRotZ = GetQuatEuler(playerCameraTransform.rot)
			
			--DebugWatch("yrot", playerRotY)
			--DebugWatch("yrot round", roundToNearest(playerRotY, 90))
			
			local tempPos = VecAdd(gridAligned, Vec(gridModulo / 2, gridModulo / 2, gridModulo / 2))
			local tempTransform = Transform(tempPos, QuatEuler(0, roundToNearest(playerRotY, 90), 0))
			local left = TransformToParentPoint(tempTransform, Vec(-gridModulo, 0, 0))
			local forward = TransformToParentVec(tempTransform, Vec(0, 0, -1))
			local right = TransformToParentPoint(tempTransform, Vec(gridModulo, 0, 0))
			
			--spawnDebugParticle(left, 1)
			--spawnDebugParticle(tempPos, 1, Color4.Yellow)
			--spawnDebugParticle(right, 1, Color4.Green)
			
			local searchSize = {gridModulo, gridModulo, gridModulo}
			
			local objectsLeft = CollisionCheckCenterPivot(left, searchSize)
			local objectsRight = CollisionCheckCenterPivot(right, searchSize)
			
			--local doorRotated = false
			
			if #objectsLeft > 0 or #objectsRight > 0 then
				local selectedObjects = nil
				
				if #objectsLeft > 0 then
					selectedObjects = FilterBlockType(objectsLeft, 2)
				else
					selectedObjects = FilterBlockType(objectsRight, 2, true)
				end
				--DebugPrint("l")
				
				if #selectedObjects > 0 then
					blockEulerY = blockEulerY + 180
					
					local otherShapeTransform = GetShapeWorldTransform(selectedObjects[1])
					
					gridAligned = VecAdd(right, VecScale(Vec(-gridModulo / 2, -gridModulo / 2, -gridModulo / 2), 1))
					gridAligned = VecAdd(gridAligned, VecScale(forward, -gridModulo / 16 * 2))
					mirrorJointLimits = {"limits='%-90 0", "limits='0 90"}
					--gridAligned = VecAdd(gridAligned, VecScale(TransformToParentVec(tempTransform, Vec(1, 0, 0)), gridModulo)) --0.1245
					--gridAligned = VecAdd(gridAligned, VecScale(TransformToParentVec(tempTransform, Vec(0, 0, 1)), -math.floor(gridModulo / 16 * 2))) --0.1245
				end
			end
			
			--[[if not doorRotated and #objectsRight > 0 then
				local filteredObjectsRight = FilterBlockType(objectsRight, 2)
				
				if #filteredObjectsRight > 0 then
					blockEulerY = blockEulerX + 270
					--blockPosOffset = VecAdd(blockPosOffset, VecScale(gridModuloTransformToParentVec(tempTransform, Vec(0, 0, 1))
				end
			end]]--
		elseif otherBlockType == selectedBlockData[9] and otherBlockType == 3 and CheckIfPosWithin(VecAdd(hitPoint, VecScale(normal, gridModulo * 0.1)), otherBlockTransform.pos, VecAdd(otherBlockTransform.pos, blockMaxBounds)) then
			local otherBlockTransform = GetShapeWorldTransform(otherBlock)
			
			if otherBlockTransform.pos[2] < gridAligned[2] + blockSize / 2 then
				gridAligned = VecAdd(otherBlockTransform.pos, Vec(0, blockSize / 10 / 2, 0))
			else
				gridAligned = VecAdd(otherBlockTransform.pos, Vec(0, -blockSize / 10 / 2, 0))
			end
		elseif selectedBlockData[9] == 3 then
			if hitPoint[2] + normal[2] * 0.01 > gridAligned[2] + blockSize / 10 / 2 then
				gridAligned = VecAdd(gridAligned, Vec(0, blockSize / 10 / 2, 0))
			end
		elseif selectedBlockData[9] == 4 and not dynamicBlock then
			local tempPos = VecAdd(gridAligned, Vec(fencePosOffset, 0, fencePosOffset))
			local tempTransform = Transform(tempPos, Quat())
			
			local forward = TransformToParentPoint(tempTransform, Vec(0, gridModulo / 2, -gridModulo))
			local backward = TransformToParentPoint(tempTransform, Vec(0, gridModulo / 2, gridModulo))
			
			local left = TransformToParentPoint(tempTransform, Vec(-gridModulo, gridModulo / 2, 0))
			local right = TransformToParentPoint(tempTransform, Vec(gridModulo, gridModulo / 2, 0))
			
			local searchSpots = {forward, backward, left, right}
			local searchSize = {gridModulo, gridModulo, gridModulo}
			
			spawnDebugParticle(gridAligned, 5, Color4.Yellow)
			spawnDebugParticle(tempPos, 5, Color4.Blue)
			
			for i = 1, #searchSpots do
				local shapeList = CollisionCheckCenterPivot(searchSpots[i], searchSize)
				shapeList = FilterNonBlocks(shapeList)
				
				if shapeList[1] ~= nil then
					local otherShape = shapeList[1]
					local otherShapeTransform = GetShapeWorldTransform(otherShape)
					local shapePos = otherShapeTransform.pos
					
					if i > 1 then
						connectedShapesTag = connectedShapesTag .. " "
					end
					
					local currPieces = SpawnFenceConnector(selectedBlockData, tempPos, otherShape, shapePos, i > 2)
					
					connectedShapesTag = connectedShapesTag .. currPieces
					
					local otherShapeConnectedTag = GetTagValue(otherShape, "minecraftconnectedshapes")
					
					if otherShapeConnectedTag == nil or otherShapeConnectedTag == "" then
						SetTag(otherShape, "minecraftconnectedshapes", connectedShapesTag)
					else
						SetTag(otherShape, "minecraftconnectedshapes", otherShapeConnectedTag .. " " .. currPieces)
					end
				end
			end
		elseif selectedBlockData[9] == 6 then
			--DebugWatch("a", hitPoint[2] + normal[2] * 0.01)
			--DebugWatch("a", gridAligned[2])
			if hitPoint[2] + normal[2] * 0.01 > gridAligned[2] + blockSize / 10 / 2 then
				gridAligned = VecAdd(gridAligned, Vec(0, gridModulo / 16 * 13, 0))
				
				mirrorJointLimits = "alt"
			end
		end
	end
	
	gridAligned = VecAdd(gridAligned, blockPosOffset)
	blockRot = QuatEuler(blockEulerX, blockEulerY, blockEulerZ)
	
	--gridAligned = VecAdd(gridAligned[1] + selectedBlockData[6].x, gridAligned[2] + selectedBlockData[6].y, gridAligned[3] + selectedBlockData[6].z)
	
	--gridAligned = VecAdd(gridAligned, gridOffset)
	
	local blockTransform = Transform(gridAligned, blockRot)
	
	local blockSizeVec = Vec(selectedBlockData[5].x / 16 * blockSize, selectedBlockData[5].y / 16 * blockSize, selectedBlockData[5].z / 16 * blockSize)
	
	local blockSizeXML = "size='" .. blockSizeVec[1] .. " " .. blockSizeVec[2] .. " " .. blockSizeVec[3] .. "'"
	
	local blockOffsetXML = "offset='" .. 16 - selectedBlockData[6].x / 16 * blockSize .. " " .. 16 - selectedBlockData[6].y / 16 * blockSize .. " " .. 16 - selectedBlockData[6].z / 16 * blockSize .. "'"
	
	local blockBrushXML = "brush='" .. selectedBlockData[2]
	
	--local testList = CollisionCheck(gridAligned, VecScale(blockSizeVec, blockSize / 100))
	
	local collCheckPassed = not checkCollision or #CollisionCheck(gridAligned, VecScale(blockSizeVec, blockSize / 100)) <= 0
	
	--[[if not collCheckPassed then
		DrawShapeOutline(testList[1], 1, 0, 0, 1)
		
		local hit, p, n = GetShapeClosestPoint(testList[1], gridAligned)
		spawnDebugParticle(p, Color4.Green)
		return
	end]]--
	
	local extraBlockXML = ""
	
	if selectedBlockData[10] ~= nil then
		extraBlockXML = selectedBlockData[10]
		
		if mirrorJointLimits ~= nil then
			if mirrorJointLimits == "alt" then
				extraBlockXML = selectedBlockData[11]
			else
				extraBlockXML = string.gsub(extraBlockXML, mirrorJointLimits[1], mirrorJointLimits[2])
			end
		end
	end
	
	local blockXML = "<voxbox " .. blockSizeXML .. " " .. blockOffsetXML .. " prop='" .. tostring(dynamicBlock or selectedBlockData[8]) .. "' " .. blockBrushXML .. "' " .. selectedBlockData[4] .. ">" .. extraBlockXML .. "</voxbox>"
	
	if string.find(selectedBlockData[2], "xml") ~= nil then
		blockXML = selectedBlockData[2]
	end
	
	local block = Spawn(blockXML, blockTransform, not dynamicBlock, true)[1]
	
	local hasSpecialData = 0
	
	if selectedBlockData[7] ~= nil then
		specialBlocks[#specialBlocks + 1] = {block, selectedBlockId}
		hasSpecialData = #specialBlocks
	end
	
	PlaySound(interactionSound, gridAligned)
	
	if GetEntityType(block) == "body" then
		block = GetBodyShapes(block)[1]
	end
	
	SetTag(block, "minecraftblockid", selectedBlockId)
	if hasSpecialData > 0 then
		SetTag(block, "minecraftspecialdata", hasSpecialData)
	end
	
	if connectedShapesTag ~= "" then
		SetTag(block, "minecraftconnectedshapes", connectedShapesTag)
	end
	
	if not creativeMode then
		selectedBlockInvData[2] = selectedBlockInvData[2] - 1
		if selectedBlockInvData[2] <= 0 then
			selectedBlockInvData[1] = 0
			selectedBlockInvData[2] = 0
		end
	end
end

function AimLogic()
	hit, hitPoint, distance, normal, shape = GetAimTarget()
	
	if not hit then
		return
	end
	
	canGrabObject = distance <= 3 and IsBodyDynamic(GetShapeBody(shape))
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1))
	local gridAligned = getGridAlignedPos(normalOffset)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	--blockOffset = VecAdd(blockOffset, gridOffset)
	
	--local hitPointBlockOffset = VecAdd(hitPoint, Vec(-0.8, -0.8, -0.8))
	--local normalOffset = VecAdd(hitPointBlockOffset, VecScale(normal, 0.8))
	
	local blockSize = nil
	--[[
	local blockId = tonumber(GetTagValue(shape, "minecraftblockid"))
	
	if blockId ~= nil and blockId > 0 then
		local shapeBoundsMin, shapeBoundsMax = GetShapeBounds(shape)
		local absSize = VecAbs(VecSub(shapeBoundsMax, shapeBoundsMin))
	
		blockSize = {x = absSize[1], y = absSize[2], z = absSize[3]}
		--blockOffset = VecAdd(GetShapeWorldTransform(shape).pos, VecScale(Vec(1, 0.5, 1), gridModulo / 2))
	end]]--
	
	renderBlockOutline(blockOffset, blockSize, false)
	
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

function FilterBlockType(shapeList, typeId, blacklist)
	local newList = {}
	blacklist = blacklist or false
	
	for i = 1, #shapeList do
		local currShape = shapeList[i]
		
		local blockId = tonumber(GetTagValue(currShape, "minecraftblockid"))
		
		--DebugPrint(blockId)
		
		if blockId ~= nil and blockId > 0 then
			local otherTypeId = blocks[blockId][9]
			
			--DebugPrint(otherTypeId)
		
			if (otherTypeId == typeId and not blacklist) or (otherTypeId ~= typeId and blacklist) then
				newList[#newList + 1] = currShape
			end
		end
	end
	
	--DebugPrint(#newList)
	
	return newList
end

function FilterNonBlocks(shapeList)
	local newList = {}
	
	for i = 1, #shapeList do
		local currShape = shapeList[i]
		
		local blockId = tonumber(GetTagValue(currShape, "minecraftblockid"))
		
		if blockId ~= nil and blockId > 0 then
			newList[#newList + 1] = currShape
		end
	end
	
	return newList
end

function ToolPlaceBlockAnim()
	SetToolTransform(Transform(Vec(0, 0, -0.05), QuatEuler(-36, 44, 22)))
end

function ScrollLogic()
	if getInventoryOpen() then
		return
	end
	
	if GetValue("NumbersToSelect") and lastFrameTool == toolName then
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
			scrollDiff = scrollDiff + 1
		end
		
		if InputPressed(binds["Next_Block"]) then
			scrollDiff = scrollDiff - 1
		end
	end
	
	if scrollDiff > 0 then
		--selectedBlock = selectedBlock + 1
		hotbarSelectedIndex = hotbarSelectedIndex - 1
		--[[if selectedBlock > #blocks then
			selectedBlock = 1
		end]]--
		
		if hotbarSelectedIndex < 1 then
			hotbarSelectedIndex = 9
		end
	elseif scrollDiff < 0 then
		--selectedBlock = selectedBlock - 1
		hotbarSelectedIndex = hotbarSelectedIndex + 1
		--[[if selectedBlock < 1 then
			selectedBlock = #blocks
		end]]--
		
		if hotbarSelectedIndex > 9 then
			hotbarSelectedIndex = 1
		end
	end
	
	if scrollDiff ~= 0 then
		itemSwitchTimer = itemSwitchTimerMax
	end
end

function SpawnFenceConnector(selectedBlockData, shapePos, otherShape, otherShapePos, leftOrRight)
	local dir = VecDir(shapePos, otherShapePos)
	
	--[[for i = 1, #dir do
		if dir[i] < -0.5 then
			dir[i] = -1
		elseif dir[i] > 0.5 then
			dir[i] = 1
		else
			dir[i] = 0
		end
	end]]--
	
	dir[2] = 0
	
	--otherShapePos = VecAdd(otherShapePos, VecScale(dir, fencePosOffset / 2))
	
	DebugWatch("dir", dir)
	--DebugWatch("shapePos", shapePos)
	--DebugWatch("otherShapePos", otherShapePos)
	
	--spawnDebugParticle(otherShapePos, 2, Color4.Green)

	--local dist = VecDist(shapePos, shapePos)
	
	--local middle = Vec((otherShapePos[1] + shapePos[1]) / 2, (otherShapePos[2] + shapePos[2]) / 2, (otherShapePos[3] + shapePos[3]) / 2)
	
	--middle = VecAdd(middle, VecScale(dir, -gridModulo / 16 * 1.5))
	
	local fencePos = VecAdd(shapePos, VecScale(dir, gridModulo / 16 * 2))
	
	fencePos[2] = shapePos[2] + gridModulo / 16 * 6
	
	DebugWatch("dir", dir)
	
	local rot = 90
	
	if leftOrRight then
		rot = 0
	end
	
	local fenceMiddleTransform = Transform(fencePos, QuatEuler(0, rot, 0))
	
	local blockBrushXML = "brush='" .. string.gsub(selectedBlockData[2], "%.vox", "_c%.vox")
	
	local blockSizeVec = Vec(blockSize / 16 * 12, blockSize / 16 * 9, blockSize / 16 * 2)
	--local blockSizeVec = Vec(1.2, 1.5, 0.2)
	
	local blockSizeXML = "size='" .. blockSizeVec[1] .. " " .. blockSizeVec[2] .. " " .. blockSizeVec[3] .. "'"
	
	local blockXML = "<voxbox " .. blockSizeXML .. " prop='false' " .. blockBrushXML .. "' " .. selectedBlockData[4] .. "></voxbox>"
	
	local connectionPiece = Spawn(blockXML, fenceMiddleTransform, true, true)[1]
	
	if GetEntityType(connectionPiece) == "body" then
		local bodyShapes = GetBodyShapes(connectionPiece)
		
		for i = 1, #bodyShapes do
			connectionPiece = connectionPiece .. " " .. bodyShapes[i]
		end
	end
	
	return connectionPiece
end

function RemoveConnectedShapes(shapeList)
	for shape in string.gmatch(shapeList, "%d+") do
		Delete(shape)
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
	if not hit then
		return
	end
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo / 2))
	local gridAligned = getGridAlignedPos(hitPoint)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	gridOffset = Vec(hitPoint[1] - blockOffset[1], hitPoint[2] - blockOffset[2], hitPoint[3] - blockOffset[3])
	
	--DebugPrint(VecToString(gridOffset))
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

	local currInvData = inventory[inventoryHotBarStartIndex + index]
	
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
			UiFont(font, 40)
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
							UiImageBox("MOD/sprites/blocks/" .. blockName .. ".png", selectorWidth * 0.6, selectorHeight * 0.6, 0, 0)
							
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

	UiPush()
		UiAlign("center left")
		
		UiTranslate(UiWidth() * 0.5, UiHeight() * (0.96))
		UiFont(font, 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		
		if modDisabled then
			UiTranslate(0, -150)
			UiText("Minecraft Building Tool requires the experimental build of Teardown.")
			return
		end--[[else
			if GetValue("ScrollToSelect") then
				UiText(blocks[selectedBlock][1])
			else
				UiText("<[" .. binds["Prev_Block"]:upper() .. "] - " .. blocks[selectedBlock][1] .. " - [" .. binds["Next_Block"]:upper() .. "]>")
			end
		end
		
		UiTranslate(-75, -30)]]--
		
		UiAlign("center middle")
		
		
		
		if itemSwitchTimer > 0 then
			local heldBlock = getCurrentHeldBlockData(index)
			if heldBlock ~= nil then
				UiPush()
					local selectedBlockId = heldBlock[1]
					local selectedBlockData = blocks[selectedBlockId]
				
					local transparancy = itemSwitchTimer / itemSwitchTimerHalf
					
					if transparancy > 2 then
						transparancy = 1
					end
					
					UiTranslate(0, -110)
					UiFont(font, 30)
					UiColor(1, 1, 1, transparancy)
					UiText(selectedBlockData[1])
					
				UiPop()
			end
		end
		UiTranslate(-75, 20)
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

function renderBlockOutline(pos, size, renderFaces)
	if size == nil then
		size = { x = gridModulo, y = gridModulo, z = gridModulo}
		--DebugWatch("hit", false)
	else
		size = deepcopy(size)
		size.x = size.x
		size.y = size.y
		size.z = size.z
		--DebugWatch("hit", true)
	end
	
	--DebugWatch("size", {size.x, size.y, size.z})
	

	local minPos = VecAdd(pos, Vec(-size.x / 2, -size.y / 2, -size.z / 2))
	local maxPos = VecAdd(pos, Vec(size.x / 2, size.y / 2, size.z / 2))
	
	local color = 0.1

	renderAabbZone(minPos, maxPos, color, color, color, 0.8, renderFaces)
end