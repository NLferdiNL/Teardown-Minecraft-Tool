#include "scripts/redstone/tnt.lua" 
#include "scripts/redstone/redstonerepeater.lua" 
#include "scripts/redstone/button.lua" 
#include "scripts/redstone/lamp.lua" 
#include "scripts/redstone/redstonetorch.lua" 

redstoneDB = {}
redstoneBlocksPosIndex = {}

--fakePoweredBlocks = {}
--fakePoweredBlocksShapeIndex = {}

-- TNT = 12
-- Block = 46
-- Dust = 123
-- Repeater = 124
-- Stone Button = 125
-- Wood Button = 126
-- Lamp = 127
-- Redstone Torch = 129

-- rsBlockData = {shape, block id, power, connection shapes, power last tick, extra(repeaterdata), softPower, softPowerLast}
local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult
--local rsCount = 0
--local dupeRs = 0
--local test = 0

local font = "MOD/fonts/MinecraftRegular.ttf"
local sfx = {"MOD/sfx/button/stone_button_press.ogg", "MOD/sfx/button/stone_button_unpress.ogg", "MOD/sfx/button/wood_button_press.ogg", "MOD/sfx/button/wood_button_unpress.ogg"}

function redstone_init()
	for i = 1, #sfx do
		sfx[i] = LoadSound(sfx[i], 1)
	end
end

--local ticker = 1
function redstone_update(dt)
	--[[if ticker > 0 then
		ticker = ticker - dt
		return
	end]]--
	
	ticker = 1
	--[[for x, xArray in pairs(redstoneDB) do
		for y, yArray in pairs(xArray) do
			for z, rsBlockData in pairs(yArray) do
				if IsShapeBroken(rsBlockData[1]) then
					Redstone_Remove(Vec(x, y, z))
				elseif rsBlockData ~= nil then
					HandleRedstone(x, y, z, rsBlockData, dt)
				end
			end
		end
	end]]--
	
	for shape, index in pairs(redstoneBlocksPosIndex) do
		local rsData = GetFromDB(index[1], index[2], index[3])
		if IsShapeBroken(shape) or (GetShapeBody(shape) ~= 1 and (rsData == nil or (rsData ~= nil and rsData[2] ~= 12))) then
			if rsData ~= nil then
				rsData[3] = 0
				rsData[5] = 0
				if rsData[7] ~= nil then
					rsData[7] = 0
					rsData[8] = 0
				end
				
				HandleRedstone(index[1], index[2], index[3], rsData, dt)
			end
			
			Redstone_Remove(shape)
		elseif rsData then
			HandleRedstone(index[1], index[2], index[3], rsData, dt)
		end
	end
	
	--local nilCount = 0
	
	--[[if #fakePoweredBlocks > 0 then
		for shape, index in pairs(fakePoweredBlocksShapeIndex) do
			if fakePoweredBlocks[index] ~= nil then
				local currFake = fakePoweredBlocks[index]
				
				local pos = GetBlockCenter(currFake[1])
				
				HandleRedstone(pos[1], pos[2], pos[3], currFake, dt)
				
				local currSoft = currFake[7] --GetTagValue(currFake[1], "minecraftredstonesoftpower")
				local currHard = currFake[3] --GetTagValue(currFake[1], "minecraftredstonehardpower")
				
				local lastSoft = currFake[8] --GetTagValue(currFake[1], "minecraftredstonesoftpowerlast")
				local lastHard = currFake[5] --GetTagValue(currFake[1], "minecraftredstonehardpowerlast")
				
				--SetTag(currFake[1], "minecraftredstonesoftpowerlast", currSoft)
				--SetTag(currFake[1], "minecraftredstonehardpowerlast", currHard)
				
				--SetTag(currFake[1], "minecraftredstonesoftpower", 0)
				--SetTag(currFake[1], "minecraftredstonehardpower", 0)
				
				--lastSoft = tonumber(lastSoft)
				--lastHard = tonumber(lastHard)
				--currSoft = tonumber(currSoft)
				--currHard = tonumber(currHard)
				
				currFake[5] = currHard
				currFake[3] = 0
				
				currFake[8] = currSoft
				currFake[7] = 0
				
				if lastSoft == nil then
					lastSoft = 0
				end
				
				if lastHard == nil then
					lastHard = 0
				end
				
				if currSoft == nil then
					currSoft = 0
				end
				
				if currHard == nil then
					currHard = 0
				end
				
				if lastSoft <= 0 and lastHard <= 0 and currSoft <= 0 and currHard <= 0 then
					--DebugPrint(tostring(currFake))
					--table.remove(fakePoweredBlocksShapeIndex, shape)
					--table.remove(fakePoweredBlocks, index)
					--nilCount = nilCount + 1
					--SetTag(currFake[1], "minecraftredstonesoftpowerlast", 0)
					--SetTag(currFake[1], "minecraftredstonehardpowerlast", 0)
				
					--SetTag(currFake[1], "minecraftredstonesoftpower", 0)
					--SetTag(currFake[1], "minecraftredstonehardpower", 0)
				end
			--else
				--nilCount = nilCount + 1
			end
		end
	end]]--
	
	--DebugWatch("Fake count", #fakePoweredBlocks)
	--DebugWatch("Fake index count", #fakePoweredBlocksShapeIndex)
	
	--if #fakePoweredBlocks ~= #fakePoweredBlocksShapeIndex 
	
	--[[if nilCount == #fakePoweredBlocks and #fakePoweredBlocks > 0 then
		--DebugPrint("Cleanse me Lua")
		fakePoweredBlocks = {}
		fakePoweredBlocksShapeIndex = {}
	--elseif #fakePoweredBlocks > 0 then
		--DebugPrint("Dirty Dancer")
	end]]--
end

function Redstone_Draw(dt)
	local aimHit, aimHitPoint, aimDistance, aimNormal, aimShape = GetAimVariables()
	for x, xArray in pairs(redstoneDB) do
		for y, yArray in pairs(xArray) do
			for z, rsBlockData in pairs(yArray) do
				if rsBlockData ~= nil then
					if rsBlockData[2] == 124 or rsBlockData[2] == 125 or rsBlockData[2] == 126 then
						DrawInteractText(x, y, z, rsBlockData, dt, aimShape)
					end
				end
			end
		end
	end
	
	if debugstart then
		local aimPos = GetBlockCenter(aimShape)
		local rsData = GetFromDB(aimPos[1], aimPos[2], aimPos[3])
		
		--DebugWatch("aimShape", aimShape)
		
		--DebugWatch("index", tableToText(fakePoweredBlocksShapeIndex, false, false, true))
		
		--local blockRedstonePos = GetTagValue(aimShape, "minecraftredstonepos")
		
		--[[if rsData then or (blockRedstonePos ~= nil and blockRedstonePos ~= "") then
			if rsData == nil then
				rsData = fakePoweredBlocks[fakePoweredBlocksShapeIndex[aimShape] ]
			end
			
			if rsData == nil then
				if blockRedstonePos ~= nil and blockRedstonePos ~= "" then
					local redstonePos = Vec()
					local i = 1
					for posDigit in string.gmatch(blockRedstonePos, "%-?%d+") do
						redstonePos[i] = tonumber(posDigit)
						i = i + 1
					end
					
					rsData = GetFromDB(redstonePos[1], redstonePos[2], redstonePos[3])
				end
			end]]--
		if rsData ~= nil then
			UiPush()
				UiAlign("left top")
				UiFont(font, 26)
				--{shape, block id, power, connection shapes, power last tick, extra(repeaterdata), softPower, softPowerLast}
				UiTranslate(UiWidth() * 0.01, UiWidth() * 0.01)
				UiText("Pos: " .. aimPos[1] .. ", " .. aimPos[2] .. ", " .. aimPos[3])
				UiTranslate(0, 28)
				UiText("Shape: " .. rsData[1])
				UiTranslate(0, 28)
				UiText("ID: " .. rsData[2])
				UiTranslate(0, 28)
				UiText("Power: " .. rsData[3])
				UiTranslate(0, 28)
				if type(rsData[4]) == "table" then
					UiText("Conn shapes: " .. tableToText(rsData[4]))
				else
					UiText("Conn shapes: " .. tostring(rsData[4]))
				end
				UiTranslate(0, 28)
				UiText("Power last tick: " .. rsData[5])
				UiTranslate(0, 28)
				if type(rsData[6]) == "table" then
					UiText("Extra data: " .. tableToText(rsData[6]))
				else
					UiText("Extra data: " .. tostring(rsData[6]))
				end
				UiTranslate(0, 28)
				UiText("Soft power: " .. tostring(rsData[7]))
				UiTranslate(0, 28)
				UiText("Soft power last tick: " .. tostring(rsData[8]))
			UiPop()
			
			--DebugWatch("aimData", tableToText(rsData))
			DrawShapeHighlight(aimShape, 0.25)
		end
		--end
	end
end

function Redstone_Add(id, shape, connections, extraData, posOverride)
	--rsCount = rsCount + 1
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	local pos = posOverride --or GetBlockCenter(shape)
	
	if posOverride ~= nil then
		pos[1] = roundOne(pos[1])-- + (mult - roundOne(pos[1]) % mult)
		pos[2] = roundOne(pos[2])-- + (mult - roundOne(pos[2]) % mult)
		pos[3] = roundOne(pos[3])-- + (mult - roundOne(pos[3]) % mult)
		--DebugPrint(VecToString(pos))
	else
		DebugPrint("POS NIL IN ADDING BLOCK " .. id)
		return
	end
	
	--DebugPrint(VecToString(pos))
	
	--[[if origin == nil then
		origin = VecCopy(pos)
		pos = Vec(0, 0, 0)
	else
		pos = VecAdd(origin, pos)
	end]]--
	
	if redstoneDB[pos[1]] == nil then
		redstoneDB[pos[1]] = {}
	end
	
	if redstoneDB[pos[1]][pos[2]] == nil then
		redstoneDB[pos[1]][pos[2]] = {}
	end
	
	--[[if redstoneDB[pos[1]*][pos[2]*][pos[3]*] ~= nil then
		rsCount = rsCount - 1
		dupeRs = dupeRs + 1
	end]]--
	
	local power = 0
	local extra = nil
	local softPower = nil
	
	if id == 12 then
		shape = GetBodyShapes(shape)[1]
	elseif id == 46 then
		power = 16
	elseif id == 124 then
		SetTag(shape, "interact", "Tick: 0.1")
		extra = {"interact", 0.1, 0.0, 0.0, false}
	elseif id == 125 then
		extra = {"interact", 1.0, 0.0, extraData, sfx[1], sfx[2]}
	elseif id == 126 then
		extra = {"interact", 1.5, 0.0, extraData, sfx[3], sfx[4]}
	elseif id == 127 then
		extra = FindLight(extraData, true)
		SetShapeEmissiveScale(shape, 0)
		SetLightEnabled(extra, false)
		softPower = 0
	elseif id == 129 then
		local light = FindLight(extraData[1])
		local attachedBlock = extraData[2]
		
		extra = {light, attachedBlock, 0.125, 0.0, extraData[3]}
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = {shape, id, power, ConnectionToTable(connections), power, extra, softPower, softPower}
	redstoneBlocksPosIndex[shape] = pos
	
	--DebugPrint("Spawn: " .. VecToString(pos))
	return pos
end

function Redstone_Update(shape, connections)
	local pos = GetBlockCenter(shape)
	
	if redstoneDB[pos[1]] == nil then
		return
	end
	
	if redstoneDB[pos[1]][pos[2]] == nil then
		return
	end
	
	if redstoneDB[pos[1]][pos[2]][pos[3]] == nil then
		return
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]][4] = ConnectionToTable(connections)
end

function Redstone_Remove_Pos(x, y, z)
	if redstoneDB[x] == nil then
		return false
	end
	
	if redstoneDB[x][y] == nil then
		return false
	end
	
	--DebugPrint("Destroy operation success: " .. tostring(redstoneDB[pos[1]][pos[2]][pos[3]] ~= nil))
	redstoneDB[x][y][z] = nil
	return true
	--[[DebugPrint(#redstoneDB[x][y])
	if #redstoneDB[x][y] <= 0 then
		redstoneDB[x][y] = nil
	end
	
	if #redstoneDB[x] <= 0 then
		redstoneDB[x] = nil
	end]]--
end

function Redstone_Remove(shape)
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	local pos = redstoneBlocksPosIndex[shape]
	
	if pos == nil then
		return
	end
	
	--[[if dupeRs > 0 then
		dupeRs = dupeRs - 1
	else
		rsCount = rsCount - 1
	end]]--
	
	Redstone_Remove_Pos(pos[1], pos[2], pos[3])
	
	redstoneBlocksPosIndex[shape] = nil
	--[[if not Redstone_Remove_Pos(pos[1], pos[2], pos[3]) then
		local index = fakePoweredBlocksShapeIndex[shape]
		
		if index ~= nil then
			table.remove(fakePoweredBlocksShapeIndex, shape)
			table.remove(fakePoweredBlocks, index)
		end
	end]]--
end

function Redstone_Interact(shape)
	local pos = GetBlockCenter(shape)
	
	local rsBlockData = GetFromDB(pos[1], pos[2], pos[3])
	
	if rsBlockData == nil then
		return
	end
	
	if rsBlockData[6] == nil or rsBlockData[6][1] ~= "interact" then
		return nil
	end
	
	if rsBlockData[2] == 125 or rsBlockData[2] == 126 then
		HandleButtonInteraction(rsBlockData)
	elseif rsBlockData[2] == 124 then
		local rsExtra = rsBlockData[6]
		local rsTick = rsExtra[2] + 0.1
		
		if rsTick >= 0.5 then
			rsTick = 0.1
		end
		
		rsExtra[2] = rsTick
		
		SetTag(rsBlockData[1], "interact", "Tick: " .. rsTick)
	end
end

function ConnectionToTable(str)
	local returnTable = {}

	for shape in string.gmatch(str, "%d+") do
		returnTable[#returnTable + 1] = tonumber(shape)
	end
	
	return returnTable
end

function GetRSDataFromShape(shape)
	if shape == nil then
		return nil, nil
	end
	
	local softBlockId = tonumber(GetTagValue(shape, "minecraftblockid"))
	
	if softBlockId == nil or softBlockId == "" or softBlockId == 16 then
		return nil, nil
	end
	
	--DebugPrint("GET")
	--DebugPrint(fakePoweredBlocksShapeIndex[shape])
	
	--local shapePos = GetShapeWorldTransform(shape).pos
	--[[local redstonePos = GetBlockCenter(shape)
	
	local realRsData = GetFromDB(redstonePos[1], redstonePos[2], redstonePos[3])
	
	if realRsData ~= nil then
		return realRsData, false
	end]]--
	
	local indexPos = redstoneBlocksPosIndex[shape]
	
	if indexPos ~= nil then
		local rsData = redstoneDB[indexPos[1]][indexPos[2]][indexPos[3]]
		return rsData, rsData[7] ~= nil
	else
		indexPos = GetBlockCenter(shape)
	end
	
	
	--[[local softPower = tonumber(GetTagValue(shape, "minecraftredstonesoftpower"))
	local hardPower = tonumber(GetTagValue(shape, "minecraftredstonehardpower"))
	local hardPowerLast = tonumber(GetTagValue(shape, "minecraftredstonehardpowerlast"))
	
	SetTag(shape, "minecraftredstoneinfluenced", 1)
	
	if softPower == nil then
		softPower = 0
	end
	
	if hardPower == nil then
		hardPower = 0
	end
	
	if hardPowerLast == nil then
		hardPowerLast = 0
	end]]--
	
	--fakePoweredBlocks[#fakePoweredBlocks + 1] = {shape, softBlockId, 0, "", 0, nil, 0}
	
	if redstoneDB[indexPos[1]] == nil then
		redstoneDB[indexPos[1]] = {}
	end
	
	if redstoneDB[indexPos[1]][indexPos[2]] == nil then
		redstoneDB[indexPos[1]][indexPos[2]] = {}
	end
	
	redstoneDB[indexPos[1]][indexPos[2]][indexPos[3]] = {shape, softBlockId, 0, "", 0, nil, 0}
	
	local rsData = redstoneDB[indexPos[1]][indexPos[2]][indexPos[3]]
	
	redstoneBlocksPosIndex[shape] = indexPos
	
	return rsData, true
end

function GetAdjecent(x, y, z, shape, filterId)--, TESTID)
	local frontAltBlock = nil
	local rearAltBlock = nil
	
	local adjecentRs = {}
	
	local multDiv = 1.6
	
	--spawnDebugParticle(Vec(x / mult, y / mult, z / mult), 2, Color4.Yellow)
	
	for aX = x - blockSize, x + blockSize, blockSize * 2 do
		local realX = aX / mult -- round(aX)
		
		if redstoneDB[aX] ~= nil and redstoneDB[aX][y] ~= nil and redstoneDB[aX][y][z] ~= nil then
			if redstoneDB[aX][y][z][2] == filterId or filterId == nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[aX][y][z], {aX, y, z}}
			end
		elseif filterId == nil then
			local fakeBlock = GetNonRedstoneBlock(shape, Vec((aX - x) / mult / multDiv, 0, 0), nil, Vec(x / mult + origBlockSize / 2, y / mult + origBlockSize / 2, z / mult + origBlockSize / 2))
			local fakeRsData = GetRSDataFromShape(fakeBlock)
			
			if fakeRsData ~= nil and type(fakeRsData) == "table" then
				adjecentRs[#adjecentRs + 1] = {fakeRsData, Vec(aX, y, z)}
			end
		end
		
		--[[if TESTID == 129 then
			spawnDebugParticle(Vec(aX / mult, y / mult, z / mult), 2, Color4.Blue)
			if #adjecentRs > 0 then
				DrawShapeHighlight(adjecentRs[#adjecentRs][1][1], 1)
			end
		end]]--
	end
	
	for aZ = z - blockSize, z + blockSize, blockSize * 2 do
		local realZ = aZ / mult -- round(aZ)
		
		if redstoneDB[x] ~= nil and redstoneDB[x][y] ~= nil and redstoneDB[x][y][aZ] ~= nil then
			if redstoneDB[x][y][aZ][2] == filterId or filterId == nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][aZ], {x, y, aZ}}
			end
		elseif filterId == nil then
			local fakeBlock = GetNonRedstoneBlock(shape, Vec(0, 0, (aZ - z) / mult / multDiv), nil, Vec(x / mult + origBlockSize / 2, y / mult + origBlockSize / 2, z / mult + origBlockSize / 2))
			local fakeRsData = GetRSDataFromShape(fakeBlock)
			
			if fakeRsData ~= nil and type(fakeRsData) == "table" then
				adjecentRs[#adjecentRs + 1] = {fakeRsData, Vec(x, y, aZ)}
			end
		end
		
		--[[if TESTID == 129 then
			spawnDebugParticle(Vec(x / mult, y / mult, aZ / mult), 2, Color4.Blue)
			
			local test = GetFromDB(x, y, aZ)
			
			if test ~= nil then
				DrawShapeHighlight(adjecentRs[#adjecentRs][1][1], 1)
			end
			
			if #adjecentRs > 0 then
				DrawShapeHighlight(adjecentRs[#adjecentRs][1][1], 1)
			end
		end]]--
	end
	
	return adjecentRs
end

function GetBlockCenter(shape)
	if redstoneBlocksPosIndex[shape] ~= nil then
		return redstoneBlocksPosIndex[shape]
	end
	
	local blockRedstonePos = GetTagValue(blockToRemove, "minecraftredstonepos")
	
	if blockRedstonePos == nil or blockRedstonePos == "" then
		return GetBlockCenter_Old(shape)
	end
	
	local redstonePos = Vec()
	local i = 1
	for posDigit in string.gmatch(blockRedstonePos, "%-?%d+") do
		redstonePos[i] = tonumber(posDigit)
		i = i + 1
	end
	
	return redstonePos
end

function IsRealRedstone(rsData)
	return IsRealRedstoneId(rsData[2])
end

function IsRealRedstoneId(rsBlockId)
	return rsBlockId ~= 12 and rsBlockId ~= 46 and rsBlockId ~= 123 and rsBlockId ~= 124 and rsBlockId ~= 125 and rsBlockId ~= 126 and rsBlockId ~= 127 and rsBlockId ~= 129
end

function FilterNonRedstoneBlocks(tbl)
	local newTbl = {}
	
	for i = 1, #tbl do
		local currRsData = tbl[i]
		
		if IsRealRedstone(currRsData) then
			newTbl[#newTbl + 1] = currRsData
		end
	end
	
	return newTbl
end

function IsPowerAcceptingShape(shape)
	local rsData = GetRSDataFromShape(shape)

	return IsPowerAcceptingRedstone(rsData)
end

function IsPowerAcceptingRedstone(rsData)
	return rsData[2] == 12 or rsData[2] == 123 or rsData[2] == 127
end

function GetBlockCenter_Old(shape)
	local sMin, sMax = GetShapeBounds(shape)
	
	--sMax[2] = sMin[2]
	
	local vec = sMin --VecCenter(sMin, sMax)
	
	vec[1] = roundToNearest(roundOne(vec[1]), 160)
	vec[2] = roundToNearest(roundOne(vec[2]), 160)
	vec[3] = roundToNearest(roundOne(vec[3]), 160)
	
	return vec
end

function GetFromDB(x, y, z)
	if redstoneDB[x] == nil then
		return nil
	end
	
	if redstoneDB[x][y] == nil then
		return nil
	end
	
	if redstoneDB[x][y][z] == nil then
		return nil
	end
	
	return redstoneDB[x][y][z]
end

function GetRealBlockCenter(shape, negateY)
	if negateY == false then
		negateY = 1
	end
	
	negateY = negateY or 0
	local sMin, sMax = GetShapeBounds(shape)
	
	if negateY == 0 then
		sMax[2] = sMin[2]
	elseif negateY == 2 then
		sMin[2] = sMax[2]
	end
	
	local vec = VecCenter(sMin, sMax)
	
	return vec
end

function roundOne(a)
	--return a - a % blockSize
	--return a
	--DebugPrint("1 " .. a)
	--DebugPrint("2 " .. a * 10)
	--DebugPrint("3 " .. math.floor(a * 10))
	--DebugPrint("4 " .. math.floor(a * 10)/10)
	a = a * 100
	return tonumber(string.format("%.0f", a))
	--return math.floor(a * 10)/10
end

function GetNonRedstoneBlock(shape, localSide, color4, posOverride, rotOverride)
	localSide[1] = localSide[1] * origBlockSize
	localSide[2] = localSide[2] * origBlockSize
	localSide[3] = localSide[3] * origBlockSize
	
	local sMin = GetShapeBounds(shape) -- Don't even need sMax.
	local shapeTransform = Transform(posOverride or sMin, rotOverride or Quat())
	
	--[[if posOverride ~= nil then
		DebugPrint(VecToString(posOverride))
		DebugPrint(VecToString(sMin))
	end]]--
	
	local side = TransformToParentPoint(shapeTransform, localSide)
	
	if color4 ~= nil then
		spawnDebugParticle(side, 1, color4)
		spawnDebugParticle(sMin, 2, Color4.Yellow)
		local aabbSize = origBlockSize * 0.95 / 2
		
		renderAabbZone(VecAdd(side, Vec(-aabbSize, -aabbSize, -aabbSize)), VecAdd(side, Vec(aabbSize, aabbSize, aabbSize)), 1, 0, 0, 1, true)
	end
	
	local searchSize = {origBlockSize * 0.95, origBlockSize * 0.95, origBlockSize  * 0.95}
	
	local objectsOnSide = CollisionCheckCenterPivot(side, searchSize)
	
	objectsOnSide = FilterNonBlocks(objectsOnSide)
	
	return objectsOnSide[1]
end

function DrawInteractText(x, y, z, rsBlockData, dt, aimShape)
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[6]
	local rsExtra = rsBlockData[6]
	
	local interactText = GetTagValue(rsShape, "interact")
	
	if interactText == nil or interactText == "" then
		return
	end
	
	--interactText = "Interact: " .. interactText
	
	local shapePos = GetRealBlockCenter(rsShape, false)
	
	UiPush()
		UiTextShadow(0.25, 0.25, 0.25, 1, 2 / 26 * 40, 0)
		UiFont(font, 26)
		local posX, posY, dist = UiWorldToPixel(shapePos)
		local textWidth, textHeight = UiGetTextSize(interactText)
		
		if (dist >= 0 and dist <= 3) or (dist <= 3.3 and rsShape == aimShape) then
			UiTranslate(-textWidth / 2, 0)
			UiTranslate(posX, posY)
			UiText(interactText)
		end
	UiPop()
end

function HandleRedstone(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	local rsSoftPower = rsBlockData[7] -- Only valid for fake blocks.
	
	if rsBlockId == 12 then
		HandleTnt(x, y, z, rsBlockData, dt)
		return
	elseif rsBlockId == 124 then -- Don't need adjecent for this. Calculate manually.
		HandleRedstoneRepeater(x, y, z, rsBlockData, dt)
		return
	elseif rsBlockId == 125 or rsBlockId == 126 then
		HandleButton(x, y, z, rsBlockData, dt)
	elseif rsBlockId == 127 then
		HandleLamp(x, y, z, rsBlockData, dt)
		return
	elseif rsBlockId == 129 then
		if not HandleRedstoneTorch(x, y, z,rsBlockData, dt) then
			return
		end
	end
	
	--DebugWatch("pos", Vec(x, y, z))
	
	local adjecentRs = GetAdjecent(x, y, z, rsShape); -- {RSDATA, POS}
	
	if rsBlockId ~= 46 and rsBlockId ~= 125 and rsBlockId ~= 126 and rsPower ~= nil then
		SetShapeEmissiveScale(rsShape, 1 / 15 * rsPower)
		--DrawShapeHighlight(rsShape, 1 / 15 * rsPower)
	end
	
	if rsConnections ~= nil then
		for i = 1, #rsConnections do
			local currConn = rsConnections[i]
			local currPower = tonumber(GetTagValue(currConn, "minecraftpower"))
			
			if currPower == nil then
				currPower = 0
			end
			
			if currPower < rsPower then
				currPower = rsPower
			end
			
			SetTag(currConn, "minecraftpower", 0)
			SetShapeEmissiveScale(currConn, 1 / 15 * currPower)
		end
	end
	
	local isntRealRedstone = IsRealRedstoneId(rsBlockId)
	
	if isntRealRedstone and (rsPower > 0 or (rsSoftPower ~= nil and rsSoftPower > 0)) then
		local rsShapeTransform = GetShapeWorldTransform(rsShape)
		local upBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 1.5, 0.5))
		local downBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, -0.5, 0.5))
		
		local upRsData, actualFakeUp = GetRSDataFromShape(upBlock)
		local downRsData, actualFakeDown = GetRSDataFromShape(downBlock)
		
		--[[DrawShapeHighlight(rsShape, 1)
		DebugPrint("Step 1")
		DebugPrint("UpBlock: " .. tostring(upBlock))
		DebugPrint("DownBlock: " .. tostring(downBlock))
		DebugPrint("UpRsData: " .. tostring(upRsData))
		DebugPrint("DownRsData: " .. tostring(downRsData))
		DebugPrint("ActualFakeUp: " .. tostring(actualFakeUp))
		DebugPrint("ActualFakeDown: " .. tostring(actualFakeDown))]]--
		
		if upRsData ~= nil and IsPowerAcceptingRedstone(upRsData) then
			adjecentRs[#adjecentRs + 1] = {upRsData, Vec(x, y + blockSize, z), false}
			--DrawShapeOutline(upBlock, 1, 0, 0, 1)
		end
		
		if downRsData ~= nil and IsPowerAcceptingRedstone(downRsData) then
			adjecentRs[#adjecentRs + 1] = {downRsData, Vec(x, y - blockSize, z), false}
			--DrawShapeOutline(downBlock, 0, 1, 0, 1)
		end
	end
	
	if rsBlockId == 46 then
		local upBlock = GetFromDB(x, y + blockSize, z)
		local downBlock = GetFromDB(x, y - blockSize, z)
		
		if upBlock ~= nil and IsPowerAcceptingRedstone(upBlock) then
			adjecentRs[#adjecentRs + 1] = {upBlock, Vec(x, y - blockSize, z), false}
		end
		
		if downBlock ~= nil and IsPowerAcceptingRedstone(downBlock) then
			adjecentRs[#adjecentRs + 1] = {downBlock, Vec(x, y - blockSize, z), false}
		end
	elseif rsBlockId == 123 then
		if rsPower > 0 then
			local fakeDownBlock = GetNonRedstoneBlock(rsShape, Vec(0.25, -0.5, 0.25))
			local fakeDownRsData, actualFake = GetRSDataFromShape(fakeDownBlock)
			
			if fakeDownRsData ~= nil then
				adjecentRs[#adjecentRs + 1] = {fakeDownRsData, Vec(x, y - blockSize, z), fakeDownRsData[2] ~= 127}
			end
		end
		
		local fakeUpBlock = GetNonRedstoneBlock(rsShape, Vec(0.25, 1.5, 0.25))--, Color4.Green)
		--local fakeUpRsData, actualFake = GetRSDataFromShape(fakeDownBlock)
		
		local upAdj = {}
		
		if fakeUpBlock == nil then
			upAdj = GetAdjecent(x, y + blockSize, z, rsShape, 123);
		end
		
		local tempDownAdj = GetAdjecent(x, y - blockSize, z, rsShape, 123);
		local downAdj = {}
		
		for i = 1, #tempDownAdj do
			local currAdj = tempDownAdj[i]
			local fakeDownBlock = GetNonRedstoneBlock(currAdj[1][1], Vec(0.25, 1.5, 0.25))
			if fakeDownBlock == nil then
				downAdj[#downAdj + 1] = currAdj
			end
		end
		
		for i = 1, #upAdj + #downAdj do
			local index = i
			local array = upAdj
			
			if i > #upAdj then
				index = i - #upAdj
				array = downAdj
			end
			
			adjecentRs[#adjecentRs + 1] = array[index]
		end
		
		--[[if #rsConnections <= 2 then -- Straight softpowering.
		
		end]]--
	elseif rsBlockId == 129 then
		--local downOffset = Vec(0.0, -0.5, 0.0)
		--local upOffset = Vec(0.0, -0.5, 0.0)
		
		local downBlock = nil
		local upBlock = nil
		
		--if rsExtra[5] then
			downBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, -0.5, 0.5), nil, Vec(x / mult, y / mult, z / mult))
			upBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 1.5, 0.5), nil, Vec(x / mult, y / mult, z / mult))
		--else
			--downBlock = GetNonRedstoneBlock(rsShape, Vec(0.15, -0.5, 0.15), Color4.Blue)
			--upBlock = GetNonRedstoneBlock(rsShape, Vec(0.15, 1.5, 0.15), Color4.Red)
		--end
		
		
		local downRsData, actualFakeDown = GetRSDataFromShape(downBlock)
		local upRsData, actualFakeUp = GetRSDataFromShape(upBlock)
		
		if rsExtra == nil then
			DrawShapeHighlight(rsShape, GetTime() % 1)
		--elseif rsExtra[5] ~= nil then
		--	DebugPrint("Sideways: " .. tostring(rsExtra[5]))
		end
		
		if downRsData ~= nil and not actualFakeDown and rsExtra[5] then
			adjecentRs[#adjecentRs + 1] = {downRsData, Vec(x, y - blockSize, z), false}
			--DrawShapeHighlight(downBlock, 1)
		end
		
		if upRsData ~= nil then
			adjecentRs[#adjecentRs + 1] = {upRsData, Vec(x, y + blockSize, z), false}
			--DrawShapeHighlight(upBlock, 1)
		end
	end
	
	for i = 1, #adjecentRs do
		local currAdjData = adjecentRs[i]
		
		local currRsData = currAdjData[1]
		local currRsPos = currAdjData[2]
		local currRsToSoftPower = currAdjData[3]
		
		local currRsShape = currRsData[1]
		local currRsBlockId = currRsData[2]
		local currRsPower = currRsData[3]
		local currRsSoftPower = currRsData[7]
		
		if currRsToSoftPower == nil then
			currRsToSoftPower = false
		end
		
		if (rsBlockId == 129 and currRsShape ~= rsExtra[2]) or rsBlockId ~= 129 then
			if ((currRsToSoftPower and currRsSoftPower ~= nil) or IsRealRedstoneId(currRsBlockId))and rsBlockId ~= 46 then
				if currRsSoftPower < rsPower - 1 then
					currRsData[7] = rsPower - 1
				end
			elseif currRsData[2] == 12 or currRsData[2] == 127 then
				if rsSoftPower ~= nil and rsSoftPower > rsPower then
					rsPower = rsSoftPower
				end
				
				if rsPower >= 1 then
					currRsData[3] = rsPower
				end
			elseif currRsBlockId ~= 129 and ((rsBlockId == 46 and IsPowerAcceptingRedstone(currRsData)) or rsBlockId ~= 46) then
				if currRsPower < rsPower - 1 then
					currRsData[3] = rsPower - 1
				end
			end
		end
	end
	
	if rsBlockId ~= 46 and rsBlockId ~= 124 and rsBlockId ~= 125 and rsBlockId ~= 126 and rsBlockId ~= 129 then
		rsBlockData[5] = rsPower
		rsBlockData[3] = 0
		
		if rsBlockData[7] ~= nil then
			rsBlockData[8] = rsBlockData[7]
			rsBlockData[7] = 0
		end
	end
	--end
end