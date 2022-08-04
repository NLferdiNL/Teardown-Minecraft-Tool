#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/menu.lua"
#include "scripts/varhandlers.lua"
#include "scripts/inventory.lua"
#include "scripts/redstone.lua"
#include "datascripts/keybinds.lua"
#include "datascripts/inputList.lua"
#include "datascripts/color4.lua"
#include "datascripts/blockData.lua"
#include "datascripts/blockConnectorSizing.lua"
#include "datascripts/savedVars.lua"

toolName = "minecraftbuildtool"
toolReadableName = "Minecraft Tool"
local toolSlot = nil

-- TODO List Redstone Update: (Release once empty.)
-- Fake blocks retaining last tick power?
-- Allow lamps to soft power each other.
-- Soft power down not working?
-- Prevent hard powered blocks from powering other blocks.
-- Fix conn shapes sometimes not using spaces.
-- Fix Redstone block powering adjectent blocks. 
-- Redstone dust up and down blocking with a block cutting it off. (Include connections) (cutting off could use around adj for comparison)
-- Fix redstone to side button connecting.
-- Fix button sounds playing when powered.
-- Tnt Anim less rapid.
-- Fix redstone interact not working when tool not equipped.
-- Replace dev art for Dust, Repeater, Lamp
-- Maybe pressure plates.
-- Fix RS Nor Latch not working.

-- TODO List Redstone Update 2: (Release once empty.)
-- Repeater stay on delay (requires a refactor)
-- Add straight redstone soft powering. (And connections for visuals)
-- SetBodyDynamic false, button, press anim.
-- Torch burnout timers.
-- Power interactions with items such as doors.
-- Maybe pistons.

-- Unimportant for now:

-- TODO: Add dropping items.
-- TODO: Fix "block of ___" insides to be random.
-- TODO: Fix block break particles moving one way, sometimes.
-- TODO: Add corner stairs.

-- Unknown if still issue:
-- TODO: Fix RSExtra going nil when repeaters powering blocks. (Repeater may potentially be fakepowering redstone components) (Fake power removed though..)

-- MAYBE: Trapdoor use log alignment?
-- MAYBE: Implement repeater locking functionality.

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
local uniqueLightId = 0

for i = 1, mainInventorySize + miscInventorySlots do
	inventory[i] = {0, 0} --{BLOCKID, STACKSIZE}
	
	if i >= 32 then
		inventory[i] = {i - 31, 1}
	end
	
	if i == 32 then
		inventory[i][1] = 123
	end
	
	if i == 33 then
		inventory[i][1] = 124
	end
	
	if i == 34 then
		inventory[i][1] = 46
	end
	
	if i == 35 then
		inventory[i][1] = 125
	end
	
	if i == 36 then
		inventory[i][1] = 126
	end
	
	if i == 37 then
		inventory[i][1] = 127
	end
	
	if i == 38 then
		inventory[i][1] = 129
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

local blockCenterPosOffset = gridModulo / 2
local fenceOffset = Vec(0, gridModulo / 16 * 6, 0)
local redstoneOffset = Vec(0, 0, gridModulo / 16 * -2)

local canGrabObject = false

debugstart = true
local debugstarted = false

function init()
	saveFileInit(savedVars)
	menu_init()
	inventory_init(inventoryScales[GetValue("InventoryUIScale")])
	redstone_init()
	
	if toolSlot ~= nil then
		RegisterTool(toolName, toolReadableName, toolVox, toolSlot)
	else
		RegisterTool(toolName, toolReadableName, toolVox)
	end
	SetBool("game.tool." .. toolName .. ".enabled", true)
	
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
	
	local playerInteractShape = GetPlayerInteractShape()
	local playerInteractingWithAimShape = playerInteractShape == shape
	
	if playerInteractingWithAimShape and InputPressed(binds["Interact"]) then
		Redstone_Interact(playerInteractShape)
	end
	
	if (InputPressed(binds["Place"]) or InputDown(binds["Place"])) and (GetPlayerGrabBody() == 0 or GetPlayerGrabShape() == 0) and not playerInteractingWithAimShape then
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

function update(dt)
	redstone_update(dt)
end

function draw(dt)
	menu_draw(dt)
	
	if not canUseTool() or isMenuOpen() then
		return
	end
	
	renderHud()
	
	Redstone_Draw(dt)
	
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
		if selectedBlockInvData ~= nil then
			local currBlockId = selectedBlockInvData[1]
			
			if currBlockId == aimBlockId then
				found = true
				hotbarSelectedIndex = i + 1
				break
			end
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

function RemoveBlock(blockToRemove)
	if not hit and blockToRemove == nil then
		return
	end
	
	if hit and blockToRemove == nil then
		blockToRemove = shape
	end
	
	local blockTag = tonumber(GetTagValue(blockToRemove, "minecraftblockid"))
	
	if blockTag == nil or blockTag <= 0 then
		return
	end
	
	local blockData = blocks[blockTag]
	
	local blockRedstonePos = GetTagValue(blockToRemove, "minecraftredstonepos")
	local blockRedstoneInfluenced = GetTagValue(blockToRemove, "minecraftredstoneinfluenced")
	
	local redstonePos = nil
	
	if blockRedstonePos ~= nil and blockRedstonePos ~= "" then
		redstonePos = Vec()
		local i = 1
		for posDigit in string.gmatch(blockRedstonePos, "%-?%d+") do
			redstonePos[i] = tonumber(posDigit)
			i = i + 1
		end
	end
	
	if redstonePos ~= nil then
		--DebugPrint(VecToString(redstonePos))
		Redstone_Remove_Pos(redstonePos[1], redstonePos[2], redstonePos[3])
	elseif blockData[9] == 7 or blockRedstoneInfluenced ~= nil then
		Redstone_Remove(blockToRemove)
	end
	
	local blockSpecialData = GetTagValue(blockToRemove, "minecraftspecialdata")
	
	local blockConnectedShapes = GetTagValue(blockToRemove, "minecraftconnectedshapes")
	
	if blockConnectedShapes ~= nil and blockConnectedShapes ~= "" then
		RemoveConnectedShapes(blockConnectedShapes)
	end
	
	if blockSpecialData ~= "" then
		local dataIndex = tonumber(blockSpecialData)
		table.remove(specialBlocks, dataIndex)
	end
	
	PlaySound(interactionSound, hitPoint)
	
	spawnBrokenBlockParticles(blockToRemove)
	
	Delete(blockToRemove)
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
	
	local normalOffset = 0.45
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, gridModulo * normalOffset))
	local gridAligned = getGridAlignedPos(normalOffset)
	
	local blockRot = Quat()
	
	local playerCameraTransform = GetPlayerCameraTransform()
	local playerPos = playerCameraTransform.pos
	
	playerPos[2] = playerPos[2] - gridModulo / 2
	
	playerPos = getGridAlignedPos(playerPos, 1)
	
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
					
						blockEulerX = 90 * selectedBlockData[3].x
						blockPosOffset[2] = blockPosOffset[2] + gridModulo
					elseif playerPos[3] == gridAligned[3] then
					
						blockEulerZ = 90 * selectedBlockData[3].z
						blockPosOffset[1] = blockPosOffset[1] + gridModulo
					end
				end
			end
				
			if selectedBlockData[3].y ~= 0 then
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
	else
		if (selectedBlockData[3].x ~= 0 and selectedBlockData[3].y ~= 0 and selectedBlockData[3].z ~= 0) then
			local gridAlignedHitPoint = getGridAlignedPos(VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1)))
			--local tempGridTransform = Transform(gridAlignedHitPoint, QuatEuler(blockEulerX, blockEulerY, blockEulerZ))
			
			if gridAlignedHitPoint[2] > gridAligned[2] then
				blockEulerZ = blockEulerZ + 180
				blockPosOffset[1] = blockPosOffset[1] + gridModulo
				blockPosOffset[2] = blockPosOffset[2] + gridModulo
			elseif gridAlignedHitPoint[2] == gridAligned[2] then
				if gridAlignedHitPoint[1] == gridAligned[1] then
					blockEulerX = blockEulerX + 90
					blockPosOffset[2] = blockPosOffset[2] + gridModulo
				
					if gridAlignedHitPoint[3] > gridAligned[3] then
						blockEulerY = blockEulerY + 180
						blockPosOffset[1] = blockPosOffset[1] + gridModulo
						blockPosOffset[3] = blockPosOffset[3] + gridModulo
					end
				else
					blockEulerX = blockEulerX + 90
					if gridAlignedHitPoint[1] > gridAligned[1] then
						blockEulerY = blockEulerY - 90
						blockPosOffset[1] = blockPosOffset[1] + gridModulo
						blockPosOffset[2] = blockPosOffset[2] + gridModulo
					else
						blockEulerY = blockEulerY + 90
						blockPosOffset[2] = blockPosOffset[2] + gridModulo
						blockPosOffset[3] = blockPosOffset[3] + gridModulo
					end
				end
			end
			
			if gridAlignedHitPoint[3] == playerPos[3] and gridAlignedHitPoint[2] ~= gridAligned[2] then
				blockEulerY = blockEulerY + 90
				if gridAlignedHitPoint[2] > gridAligned[2] then
					blockPosOffset[1] = blockPosOffset[1] - gridModulo
				else
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
				end
			end
			
			--[[local gridAlignedHitPoint = getGridAlignedPos(VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1)))
			
			if gridAlignedHitPoint[1] == gridAligned[1] and not gridAlignedHitPoint[2] == gridAligned[2] then
				DebugPrint("1")
			elseif gridAlignedHitPoint[3] == gridAligned[3] and not gridAlignedHitPoint[2] == gridAligned[2] then
				DebugPrint("2")
			else
				if gridAlignedHitPoint[2] < gridAligned[2] then
					DebugPrint("3")
				else
					blockEulerZ = blockEulerZ + 180
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
					blockPosOffset[2] = blockPosOffset[2] + gridModulo
					DebugPrint("4")
				end
				
				if gridAlignedHitPoint[1] == gridAligned[1] then
					DebugPrint("4")
					blockEulerY = blockEulerY + 90
					
					if gridAlignedHitPoint[2] > gridAligned[2] then
						blockPosOffset[1] = blockPosOffset[1] - gridModulo
					elseif gridAlignedHitPoint[2] < gridAligned[2] then
						blockPosOffset[3] = blockPosOffset[3] + gridModulo
					end
				elseif gridAlignedHitPoint[3] == gridAligned[3] then
					DebugPrint("5")
					blockEulerY = blockEulerY + 180
					if gridAlignedHitPoint[2] > gridAligned[2] then
						blockPosOffset[1] = blockPosOffset[3] + gridModulo
					elseif gridAlignedHitPoint[2] < gridAligned[2] then
						blockPosOffset[3] = blockPosOffset[1] - gridModulo
					end
				end
			end]]--
			
			--[[if gridAlignedHitPoint[2] == gridAligned[2] then
				if gridAlignedHitPoint[1] == gridAligned[1] then
					DebugPrint("1")
				elseif gridAlignedHitPoint[3] == gridAligned[3] then
					DebugPrint("2")
				end
			else
				if gridAlignedHitPoint[1] == gridAligned[1] then
					DebugPrint("3")
				elseif gridAlignedHitPoint[3] == gridAligned[3] then
					DebugPrint("4")
				end
			end]]--
		elseif (selectedBlockData[3].x ~= 0 or selectedBlockData[3].z ~= 0) and selectedBlockData[3].y == 0 then
			local gridAlignedHitPoint = getGridAlignedPos(VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1)))
			
			if gridAlignedHitPoint[1] == gridAligned[1] and gridAlignedHitPoint[2] == gridAligned[2] then
				blockEulerX = 90 * selectedBlockData[3].x
				blockPosOffset[2] = blockPosOffset[2] + gridModulo
			elseif gridAlignedHitPoint[3] == gridAligned[3] and gridAlignedHitPoint[2] == gridAligned[2] then
				blockEulerZ = 90 * selectedBlockData[3].z
				blockPosOffset[1] = blockPosOffset[1] + gridModulo
			end
		elseif selectedBlockData[3].y ~= 0 then
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
	
	local mirrorJointLimits = nil
	local connectedShapesTag = ""
	
	local tempPos = VecAdd(gridAligned, Vec(blockCenterPosOffset, 0, blockCenterPosOffset))
	local tempTransform = Transform(tempPos, Quat())
	
	local adjecentBlocks = FindAdjecentBlocks(tempTransform)

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
			
			local tempPos = VecAdd(gridAligned, Vec(gridModulo / 2, gridModulo / 2, gridModulo / 2))
			local tempTransform = Transform(tempPos, QuatEuler(0, roundToNearest(playerRotY, 90), 0))
			local left = TransformToParentPoint(tempTransform, Vec(-gridModulo, 0, 0))
			local forward = TransformToParentVec(tempTransform, Vec(0, 0, -1))
			local right = TransformToParentPoint(tempTransform, Vec(gridModulo, 0, 0))
			
			local searchSize = {gridModulo, gridModulo, gridModulo}
			
			local objectsLeft = CollisionCheckCenterPivot(left, searchSize)
			local objectsRight = CollisionCheckCenterPivot(right, searchSize)
			
			if #objectsLeft > 0 or #objectsRight > 0 then
				local selectedObjects = nil
				
				if #objectsLeft > 0 then
					selectedObjects = FilterBlockType(objectsLeft, 2)
				else
					selectedObjects = FilterBlockType(objectsRight, 2, true)
				end
				
				if #selectedObjects > 0 then
					blockEulerY = blockEulerY + 180
					
					local otherShapeTransform = GetShapeWorldTransform(selectedObjects[1])
					
					gridAligned = VecAdd(right, VecScale(Vec(-gridModulo / 2, -gridModulo / 2, -gridModulo / 2), 1))
					gridAligned = VecAdd(gridAligned, VecScale(forward, -gridModulo / 16 * 2))
					mirrorJointLimits = {"limits='%-90 0", "limits='0 90"}
				end
			end
			
		elseif otherBlockType == selectedBlockData[9] and otherBlockType == 3 and 
			   CheckIfPosWithin(VecAdd(hitPoint, VecScale(normal, gridModulo * 0.1)), otherBlockTransform.pos, VecAdd(otherBlockTransform.pos, blockMaxBounds)) then
			
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
			connectedShapesTag = ConnectToAdjecentBlocks(selectedBlockData, adjecentBlocks, tempPos, fenceOffset, nil, 2)
		elseif selectedBlockData[9] == 6 then
		
			if hitPoint[2] + normal[2] * 0.01 > gridAligned[2] + blockSize / 10 / 2 then
				gridAligned = VecAdd(gridAligned, Vec(0, gridModulo / 16 * 13, 0))
				
				mirrorJointLimits = "alt"
			end
		elseif selectedBlockData[9] == 7 and not dynamicBlock then
			if selectedBlockId == 123 then
				local adjTransformUp = Transform(VecAdd(tempPos, Vec(0, gridModulo, 0)), Quat())
				local adjTransformDown = Transform(VecAdd(tempPos, Vec(0, -gridModulo, 0)), Quat())
				
				local adjBlocksUp = FindAdjecentBlocks(adjTransformUp)
				local adjBlocksDown = FindAdjecentBlocks(adjTransformDown)
				
				connectedShapesTag = connectedShapesTag .. ConnectToAdjecentBlocks(selectedBlockData, adjecentBlocks, tempPos, redstoneOffset, {12, 46, 123, 124, 125, 126, 127}, 4) -- Vec(-0.155, 0, -0.205)
				connectedShapesTag = connectedShapesTag .. ConnectToAdjecentBlocks(selectedBlockData, adjBlocksUp, adjTransformUp.pos, VecAdd(redstoneOffset, Vec(0, -gridModulo, 0)), 123, 4, "_cu") -- Vec(-0.155, 0, -0.205)
				connectedShapesTag = connectedShapesTag .. ConnectToAdjecentBlocks(selectedBlockData, adjBlocksDown, adjTransformDown.pos, redstoneOffset, 123, 4, "_cd") -- Vec(-0.155, 0, -0.205)
			end
		elseif selectedBlockData[9] == 8 then
			local tempRot = QuatEuler(blockEulerX, blockEulerY, blockEulerZ)
			local tempTransform = Transform(gridAligned, tempRot, 0)
			
			local gateLocalOffset = Vec()
			local blockRotY = blockEulerY / 90
			
			if blockRotY == -1 then -- Why do math when brute force work.
				gateLocalOffset = Vec(gridModulo / 2, gridModulo / 16 * 5, -gridModulo / 2)
			elseif blockEulerY / 90 == 0 then
				gateLocalOffset = Vec(gridModulo / 2, gridModulo / 16 * 5, gridModulo / 2)
			elseif blockRotY == 1 then
				gateLocalOffset = Vec(-gridModulo / 2, gridModulo / 16 * 5, gridModulo / 2)
			elseif blockRotY == 2 then
				gateLocalOffset = Vec(-gridModulo / 2, gridModulo / 16 * 5, -gridModulo / 2)
			end
			
			local gateOffset = TransformToParentPoint(tempTransform, gateLocalOffset)
			
			gridAligned = gateOffset
			blockPosOffset = Vec()
		end
	end
	
	if selectedBlockId == 16 or selectedBlockId == 129 then
		local gridAlignedHitPoint = getGridAlignedPos(VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1)))
		local playerRotX, playerRotY, playerRotZ = GetQuatEuler(playerCameraTransform.rot)
		
		if gridAlignedHitPoint[2] == gridAligned[2] then
			blockEulerZ = 15
			blockPosOffset[2] = blockPosOffset[2] + gridModulo / 16
			
			if gridAlignedHitPoint[1] == gridAligned[1] then
				if gridAlignedHitPoint[3] > gridAligned[3] then
					blockEulerY = -90
					blockPosOffset[1] = blockPosOffset[1] + gridModulo
					blockPosOffset[3] = blockPosOffset[3] + gridModulo * 0.5
				else
					blockPosOffset[3] = blockPosOffset[3] + gridModulo * 0.5
					blockEulerY = 90
				end
			elseif gridAlignedHitPoint[3] == gridAligned[3] then
				if gridAlignedHitPoint[1] > gridAligned[1] then
					--blockPosOffset[1] = blockPosOffset[1] + gridModulo
					blockPosOffset[1] = blockPosOffset[1] + gridModulo * 0.5
				else
					blockPosOffset[1] = blockPosOffset[1] + gridModulo * 0.5
					blockPosOffset[3] = blockPosOffset[3] + gridModulo
					blockEulerY = 180
				end
			end
		elseif gridAlignedHitPoint[2] > gridAligned[2] then
			blockEulerZ = 180
			blockPosOffset[1] = blockPosOffset[1] + gridModulo
			blockPosOffset[2] = blockPosOffset[2] + gridModulo
		end
	end
	
	local gridAlignedPreOffset = VecCopy(gridAligned)
	gridAligned = VecAdd(gridAligned, blockPosOffset)
	blockRot = QuatEuler(blockEulerX, blockEulerY, blockEulerZ)
	
	local blockTransform = Transform(gridAligned, blockRot)
	
	local blockSizeVec = Vec(selectedBlockData[5].x / 16 * blockSize, selectedBlockData[5].y / 16 * blockSize, selectedBlockData[5].z / 16 * blockSize)
	
	local blockSizeXML = "size='" .. blockSizeVec[1] .. " " .. blockSizeVec[2] .. " " .. blockSizeVec[3] .. "'"
	
	local blockOffsetXML = "offset='" .. 16 - selectedBlockData[6].x / 16 * blockSize .. " " .. 16 - selectedBlockData[6].y / 16 * blockSize .. " " .. 16 - selectedBlockData[6].z / 16 * blockSize .. "'"
	
	local blockBrushXML = "brush='" .. selectedBlockData[2]
	
	local collCheckPassed = not checkCollision or #CollisionCheck(gridAligned, VecScale(blockSizeVec, blockSize / 100)) <= 0
	
	local extraBlockXML = ""
	
	if selectedBlockData[10] ~= nil then
		extraBlockXML = selectedBlockData[10]
		if selectedBlockId == 127 then
			uniqueLightId = uniqueLightId + 1
			extraBlockXML = string.gsub(extraBlockXML, "LAMPID", "MCL_" .. tostring(uniqueLightId))
		elseif selectedBlockId == 129 then
			uniqueLightId = uniqueLightId + 1
			extraBlockXML = string.gsub(extraBlockXML, "LAMPID", "MCL_" .. tostring(uniqueLightId))
		end
		
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
	
	if selectedBlockData[9] == 7 then
		if selectedBlockId == 12 then
			SetBodyDynamic(block, false)
		end
		
		local offsetPos = gridAlignedPreOffset
		
		--DebugPrint(tostring(offsetPos == nil) .. " " .. selectedBlockId)
		
		if selectedBlockId == 125 or selectedBlockId == 126 then
			local returnPos = Redstone_Add(selectedBlockId, block, connectedShapesTag, shape, offsetPos)
			
			SetTag(block, "minecraftredstonepos", returnPos[1] .. " " .. returnPos[2] .. " " .. returnPos[3])
		elseif selectedBlockId == 127 then
			local returnPos = Redstone_Add(selectedBlockId, block, connectedShapesTag, "MCL_" .. tostring(uniqueLightId), offsetPos)
			
			SetTag(block, "minecraftredstonepos", returnPos[1] .. " " .. returnPos[2] .. " " .. returnPos[3])
		elseif selectedBlockId == 129 then
			local otherBlock = shape
			local otherBlockId = GetTagValue(shape, "minecraftblockid")
			
			if otherBlockId == nil or otherBlockId == "" then
				otherBlock = nil
			end
			
			--[[local offsetPos = nil
			
			if blockEulerX ~= 0 or blockEulerY ~= 0 or blockEulerZ ~= 0 then
				offsetPos = VecAdd(gridAlignedPreOffset, Vec(gridModulo / 2, -0.02, gridModulo / 2))
			end]]--
			
			local returnPos = Redstone_Add(selectedBlockId, block, connectedShapesTag, {"MCL_" .. tostring(uniqueLightId), otherBlock, blockEulerX ~= 0 or blockEulerY ~= 0 or blockEulerZ ~= 0}, offsetPos)--VecSub(gridAligned, blockPosOffset))
			
			SetTag(block, "minecraftredstonepos", returnPos[1] .. " " .. returnPos[2] .. " " .. returnPos[3])
		else
			local returnPos = Redstone_Add(selectedBlockId, block, connectedShapesTag, nil, offsetPos)
			
			SetTag(block, "minecraftredstonepos", returnPos[1] .. " " .. returnPos[2] .. " " .. returnPos[3])
		end
	end
	
	if selectedBlockData[9] == 8 then
		local gateR = FindShape("gateR", true)
		local gateL = FindShape("gateL", true)
		
		RemoveTag(gateR, "gateR") --To prevent future findings.
		RemoveTag(gateL, "gateL")
		
		connectedShapesTag = connectedShapesTag .. gateR .. " " .. gateL .. " "
	end
	
	PlaySound(interactionSound, gridAligned)
	
	if GetEntityType(block) == "body" then
		block = GetBodyShapes(block)[1]
	end
	
	SetTag(block, "minecraftblockid", selectedBlockId)
	if hasSpecialData > 0 then
		SetTag(block, "minecraftspecialdata", hasSpecialData)
	end
	
	if selectedBlockData[9] ~= 4 and selectedBlockId ~= 123 and not dynamicBlock then
		for i = 1, #adjecentBlocks do
			local currBlock = adjecentBlocks[i]
			local currBlockId = tonumber(GetTagValue(currBlock, "minecraftblockid"))
			
			if currBlockId ~= nil then
				local blockTransform = GetShapeWorldTransform(currBlock)
				local currBlockData = blocks[currBlockId]
				local currBlockType = currBlockData[9]
				
				local currOffset = nil
				
				local skip = false
				
				if currBlockType == 4 then
					currOffset = fenceOffset
				elseif currBlockType == 7 and selectedBlockData[9] == 7 then
					currOffset = redstoneOffset
				else
					skip = true
				end
				
				if not skip then
					local otherBlockMin, otherBlockMax = GetShapeBounds(currBlock)
					
					otherBlockMax[2] = otherBlockMin[2]
					
					local otherBlockCenter = VecCenter(otherBlockMin, otherBlockMax)
					
					local rot = (4 - i) * 90
					
					if rot == 0 then
						rot = 180
					elseif rot == 180 then
						rot = 0
					end
					
					local blockConnectionTransform, dir = GetBlockConnectionTransform(otherBlockCenter, tempPos, rot, currOffset, 2)
					
					local currPieces = SpawnAdjustedConnector(currBlockData, currBlockId, block, blockConnectionTransform, dir)
					
					if currPieces == nil then
						currPieces = ""
					end
						
					connectedShapesTag = connectedShapesTag .. currPieces
					
					local otherShapeConnectedTag = GetTagValue(currBlock, "minecraftconnectedshapes")
					
					if otherShapeConnectedTag == nil or otherShapeConnectedTag == "" then
						SetTag(currBlock, "minecraftconnectedshapes", connectedShapesTag)
						if currBlockType == 7 then
							Redstone_Update(currBlock, connectedShapesTag)
						end
					else
						SetTag(currBlock, "minecraftconnectedshapes", otherShapeConnectedTag .. " " .. currPieces)
						if currBlockType == 7 then
							Redstone_Update(currBlock, otherShapeConnectedTag .. " " .. currPieces)
						end
					end
				end
			end
		end
	end
	-- TNT = 12
	-- Block = 46
	-- Dust = 123
	-- Repeater = 124
	-- Stone Button = 125
	-- Wood Button = 126
	-- Lamp = 127
	-- Redstone Torch = 129
	if selectedBlockId == 123 or selectedBlockId == 124 or selectedBlockId == 125 or selectedBlockId == 126 or selectedBlockId == 129 then
		local otherBlock = shape
		
		if HasTag(shape, "minecraftblockid") then
			local otherConnectedShapes = GetTagValue(otherBlock, "minecraftconnectedshapes")
			
			if otherConnectedShapes == nil then
				otherConnectedShapes = ""
			end
			
			otherConnectedShapes = otherConnectedShapes .. " " .. block
			
			SetTag(otherBlock, "minecraftconnectedshapes", otherConnectedShapes)
		end
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
		hitPoint = Vec()
		distance = 0
		normal = Vec()
		shape = 0
		return
	end
	
	canGrabObject = distance <= 3 and IsBodyDynamic(GetShapeBody(shape))
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo * 0.1))
	local gridAligned = getGridAlignedPos(normalOffset)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	
	local blockSize = nil
	
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
		
		if blockId ~= nil and blockId > 0 then
			local otherTypeId = blocks[blockId][9]
			
			if (otherTypeId == typeId and not blacklist) or (otherTypeId ~= typeId and blacklist) then
				newList[#newList + 1] = currShape
			end
		end
	end
	
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

function FindAdjecentBlocks(blockTransform)
	local forward = TransformToParentPoint(blockTransform, Vec(0, gridModulo / 2, -gridModulo))
	local backward = TransformToParentPoint(blockTransform, Vec(0, gridModulo / 2, gridModulo))
	
	local left = TransformToParentPoint(blockTransform, Vec(-gridModulo, gridModulo / 2, 0))
	local right = TransformToParentPoint(blockTransform, Vec(gridModulo, gridModulo / 2, 0))
	
	local searchSpots = {forward, left, backward, right}
	local searchSize = {gridModulo, gridModulo, gridModulo}
	
	local blocks = {}
	
	for i = 1, #searchSpots do
		local shapeList = CollisionCheckCenterPivot(searchSpots[i], searchSize)
		shapeList = FilterNonBlocks(shapeList)
		
		if #shapeList > 0 then
			blocks[#blocks + 1] = shapeList[1]
		else
			blocks[#blocks + 1] = -1
		end
	end
	
	return blocks
end

function IsBlockInFilter(filter, id)
	if type(filter) == "number" then
		if filter == id then
			return true
		else
			return false
		end
	elseif type(filter) == "table" then
		for i = 1, #filter do
			if filter[i] == id then
				return true
			end
		end
	end
	
	return false
end

function ConnectToAdjecentBlocks(selectedBlockData, adjecentBlocks, middlePos, blockOffset, blockFilter, dirMultiplier, suffix)
	local connectedShapesTag = ""
	
	for i = 1, #adjecentBlocks do
		if adjecentBlocks[i] ~= -1 then
			local otherShape = adjecentBlocks[i]
			local otherBlockId = tonumber(GetTagValue(otherShape, "minecraftblockid"))
			
			if blockFilter == nil or IsBlockInFilter(blockFilter, otherBlockId) then
				local otherShapeTransform = GetShapeWorldTransform(otherShape)
				
				local blockMin, blockMax = GetShapeBounds(otherShape)
				
				blockMax[2] = blockMin[2]
				
				local center = VecCenter(blockMin, blockMax)
				
				if i > 1 then
					connectedShapesTag = connectedShapesTag .. " "
				end
				
				local fenceConnectionTransform, dir = GetBlockConnectionTransform(middlePos, center, i * 90, blockOffset, dirMultiplier)
				
				local currPieces = SpawnAdjustedConnector(selectedBlockData, selectedBlockId, otherShape, fenceConnectionTransform, dir, suffix)
				
				connectedShapesTag = connectedShapesTag .. currPieces
				
				local otherShapeConnectedTag = GetTagValue(otherShape, "minecraftconnectedshapes")
				
				if otherShapeConnectedTag == nil or otherShapeConnectedTag == "" then
					SetTag(otherShape, "minecraftconnectedshapes", connectedShapesTag)
				else
					SetTag(otherShape, "minecraftconnectedshapes", otherShapeConnectedTag .. " " .. currPieces)
				end
			end
		end
	end

	return connectedShapesTag
end

function ToolPlaceBlockAnim()
	SetToolTransform(Transform(Vec(0, 0, -0.05), QuatEuler(-36, 44, 22)))
end

function ScrollLogic()
	if getInventoryOpen() then
		return
	end
	
	local scrollDiff = 0
	
	if GetValue("NumbersToSelect") and lastFrameTool == toolName then
		for i = 1, 9 do
			local numberKeyDown = InputPressed(tostring(i))
			
			if numberKeyDown then
				itemSwitchTimer = itemSwitchTimerMax
				hotbarSelectedIndex = i
				SetString("game.player.tool", toolName)
				return
			end
		end
	end

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
		hotbarSelectedIndex = hotbarSelectedIndex - 1
		
		if hotbarSelectedIndex < 1 then
			hotbarSelectedIndex = 9
		end
	elseif scrollDiff < 0 then
		hotbarSelectedIndex = hotbarSelectedIndex + 1
		
		if hotbarSelectedIndex > 9 then
			hotbarSelectedIndex = 1
		end
	end
	
	if scrollDiff ~= 0 then
		itemSwitchTimer = itemSwitchTimerMax
	end
end

function GetBlockConnectionTransform(shapePos, otherShapePos, rot, posOffset, dirMultiplier)
	local dir = VecDir(shapePos, otherShapePos)
	
	dir[2] = 0
	
	local blockPos = VecAdd(shapePos, VecScale(dir, gridModulo / 16 * dirMultiplier))
	
	local fenceConnectionTransform = Transform(blockPos, QuatEuler(0, rot, 0))
	
	if posOffset ~= nil then
		fenceConnectionTransform.pos = TransformToParentPoint(fenceConnectionTransform, posOffset)
	end
	
	local offsetDir = TransformToParentVec(fenceConnectionTransform, Vec(0, 0, -1))
	
	fenceConnectionTransform.pos = VecAdd(fenceConnectionTransform.pos, VecScale(offsetDir, gridModulo / 16))
	
	return fenceConnectionTransform, dir
end

function SpawnBlockConnector(selectedBlockData, connectionTransform, sizeModifier, suffix)
	if sizeModifier == nil then
		sizeModifier = Vec(1, 1, 1)
	end
	
	local blockConnectorSize = blockConnectorSizing[selectedBlockData[9]][1]
	
	if suffix == nil then
		suffix = "_c"
	else
		blockConnectorSize = blockConnectorSizing[selectedBlockData[9]][2]
	end
	
	local blockBrushXML = "brush='" .. string.gsub(selectedBlockData[2], "%.vox", suffix .. "%.vox")
	
	local blockSizeVec = Vec(blockSize / 16 * blockConnectorSize.x * sizeModifier[1], blockSize / 16 * blockConnectorSize.y * sizeModifier[2], blockSize / 16 * blockConnectorSize.z * sizeModifier[3])
	
	local blockSizeXML = "size='" .. blockSizeVec[1] .. " " .. blockSizeVec[2] .. " " .. blockSizeVec[3] .. "'"
	
	local blockXML = "<voxbox " .. blockSizeXML .. " prop='false' " .. blockBrushXML .. "' " .. selectedBlockData[4] .. "></voxbox>"
	
	local connectionPiece = Spawn(blockXML, connectionTransform, true, true)[1]
	
	if GetEntityType(connectionPiece) == "body" then
		local bodyShapes = GetBodyShapes(connectionPiece)
		
		for i = 1, #bodyShapes do
			connectionPiece = connectionPiece .. " " .. bodyShapes[i]
		end
	end
	
	return connectionPiece
end

function SpawnAdjustedConnector(selectedBlockData, selectedBlockId, otherShape, connectionTransform, dir, suffix)
	local otherBlockId = GetTagValue(otherShape, "minecraftblockid")
	
	if otherBlockId == nil then
		DebugPrint(toolName .. " WARNING: invalid otherShape passed in SpawnAdjustedConnector()")
	end
	
	otherBlockId = tonumber(otherBlockId)
	
	local sizeModifier = Vec(1, 1, 1)
	
	if otherBlockId == nil or otherBlockId == 0 then
		DebugPrint(toolName .. " WARNING: invalid block id from otherShape in SpawnAdjustedConnector()")
	else
		local otherShapeBlockType = blocks[otherBlockId][9]
		
		for i = 1, #dir do
			if dir[i] < -0.5 then
				dir[i] = -1
			elseif dir[i] > 0.5 then
				dir[i] = 1
			else
				dir[i] = 0
			end
			
			local isValidBlockType = otherShapeBlockType == 1 or
									 otherShapeBlockType == 3 or
									 otherShapeBlockType == 5 or
									 (otherShapeBlockType == 7 and selectedBlockId == 123 and otherBlockId ~= 123) or
									 otherShapeBlockType == 8
			
			if math.abs(dir[i]) == 1 and isValidBlockType then
				local selectedBlockType = selectedBlockData[9]
				if selectedBlockType == 4 then
					sizeModifier[1] = 0.5
				elseif selectedBlockType == 7 then
					sizeModifier[1] = 0.75
				end
			end
		end
	end
	
	local connectionPiece = SpawnBlockConnector(selectedBlockData, connectionTransform, sizeModifier, suffix)
	
	return connectionPiece
end

function RemoveConnectedShapes(shapeList)
	for shape in string.gmatch(shapeList, "%d+") do
		if HasTag(shape, "minecraftblockid") then
			RemoveBlock(shape)
		else
			Delete(shape)
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
	if not hit then
		return
	end
	
	local normalOffset = VecAdd(hitPoint, VecScale(normal, -gridModulo / 2))
	local gridAligned = getGridAlignedPos(hitPoint)
							
	local blockOffset = Vec(gridAligned[1] + gridModulo / 2,
							gridAligned[2] + gridModulo / 2,
							gridAligned[3] + gridModulo / 2)
							
	gridOffset = Vec(hitPoint[1] - blockOffset[1], hitPoint[2] - blockOffset[2], hitPoint[3] - blockOffset[3])
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
		end
		
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

function GetAimVariables()	
	return hit, hitPoint, distance, normal, shape
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
		
	else
		size = deepcopy(size)
		size.x = size.x
		size.y = size.y
		size.z = size.z
	end

	local minPos = VecAdd(pos, Vec(-size.x / 2, -size.y / 2, -size.z / 2))
	local maxPos = VecAdd(pos, Vec(size.x / 2, size.y / 2, size.z / 2))
	
	local color = 0.1

	renderAabbZone(minPos, maxPos, color, color, color, 0.8, renderFaces)
end