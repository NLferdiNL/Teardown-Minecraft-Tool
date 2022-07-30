redstoneDB = {}

-- TNT = 12
-- Block = 46
-- Dust = 123
-- Repeater = 124
-- Stone Button = 125
-- Wood Button = 126
-- Lamp = 127

-- rsBlockData = {shape, block id, power, connection shapes, power last tick, extra(repeaterdata)}
-- Origin = first block, then rest is pos + origin
local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult
--local origin = nil
--local rsCount = 0
--local dupeRs = 0
--local test = 0

--SetTag(switch, "interact", "Turn on")
--if GetPlayerInteractShape() == switch and InputPressed("interact") then

local font = "MOD/fonts/MinecraftRegular.ttf"

local fakePoweredBlocks = {}

function redstone_init()

end

function redstone_update(dt)
	for x, xArray in pairs(redstoneDB) do
		for y, yArray in pairs(xArray) do
			for z, rsBlockData in pairs(yArray) do
				if IsShapeBroken(rsBlockData[1]) then
					Redstone_Remove(Vec(x, y, z))
				elseif rsBlockData ~= nil then
					HandleRedstone(x, y, z, rsBlockData, dt)
				end
			end
		end
	end
	
	for i = 1, #fakePoweredBlocks do
		local currFake = fakePoweredBlocks[i]
		
		local pos = GetBlockCenter(currFake[1])
		
		HandleRedstone(pos[1], pos[2], pos[3], currFake[2], dt)
		
		local currSoft = GetTagValue(currFake[2][1], "minecraftredstonesoftpower")
		local currHard = GetTagValue(currFake[2][1], "minecraftredstonehardpower")
		
		local lastSoft = GetTagValue(currFake[2][1], "minecraftredstonesoftpowerlast")
		local lastHard = GetTagValue(currFake[2][1], "minecraftredstonehardpowerlast")
		
		SetTag(currFake[2][1], "minecraftredstonesoftpowerlast", currSoft)
		SetTag(currFake[2][1], "minecraftredstonehardpowerlast", currHard)
		
		SetTag(currFake[2][1], "minecraftredstonesoftpower", 0)
		SetTag(currFake[2][1], "minecraftredstonehardpower", 0)
	end
	
	fakePoweredBlocks = {}
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
end

function Redstone_Add(id, shape, connections, extraData)
	--rsCount = rsCount + 1
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	local pos = GetBlockCenter(shape)
	
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
	
	if id == 46 then
		power = 16
	elseif id == 124 then
		SetTag(shape, "interact", "Tick: 0.1")
		extra = {"interact", 0.1, 0.1, false}
	elseif id == 125 then
		extra = {"interact", 1.0, 0.0, extraData}
	elseif id == 126 then
		extra = {"interact", 1.5, 0.0, extraData}
	elseif id == 127 then
		extra = FindLight(extraData, true)
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = {shape, id, power, ConnectionToTable(connections), power, extra, 0}
	
	--DebugPrint("Spawn: " .. VecToString(pos))
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

function Redstone_Remove(shape)
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	local pos = GetBlockCenter(shape)
	
	--[[if dupeRs > 0 then
		dupeRs = dupeRs - 1
	else
		rsCount = rsCount - 1
	end]]--
	
	if redstoneDB[pos[1]] == nil then
		return
	end
	
	if redstoneDB[pos[1]][pos[2]] == nil then
		return
	end
	
	--DebugPrint("Destroy operation success: " .. tostring(redstoneDB[pos[1]][pos[2]][pos[3]] ~= nil))
	redstoneDB[pos[1]][pos[2]][pos[3]] = nil
end

function Redstone_Interact(shape)
	local pos = GetBlockCenter(shape)
	
	local rsBlockData = GetFromDB(pos[1], pos[2], pos[3])
	
	if rsBlockData[6] == nil or rsBlockData[6][1] ~= "interact" then
		return nil
	end
	
	if rsBlockData[2] == 125 or rsBlockData[2] == 126 then
		rsBlockData[3] = 16
		rsBlockData[6][3] = rsBlockData[6][2]
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

function GetFakeBlockData(shape)
	if shape == nil then
		return nil
	end
	
	local softBlockId = tonumber(GetTagValue(shape, "minecraftblockid"))
	local softPower = tonumber(GetTagValue(shape, "minecraftredstonesoftpowerlast"))
	local hardPower = tonumber(GetTagValue(shape, "minecraftredstonehardpowerlast"))
	
	if softPower == nil then
		softPower = 0
	end
	
	if hardPower == nil then
		hardPower = 0
	end
	
	return {shape, softBlockId, hardPower, "", hardPower, nil, softPower}
end

function GetAdjecent(x, y, z, shape)
	local frontAltBlock = nil
	local rearAltBlock = nil
	
	local adjecentRs = {}
	
	for aX = x - blockSize, x + blockSize, blockSize * 2 do
		local realX = aX / mult -- round(aX)
		
		if redstoneDB[aX] ~= nil and redstoneDB[aX][y] ~= nil then
			if redstoneDB[aX][y][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[aX][y][z], {aX, y, z}}
			else
				local fakeBlock = GetNonRedstoneBlock(rsShape, Vec(x / mult, y / mult, z / mult))
				local fakeRsData = GetFakeBlockData(frontAltBlock)
				
				adjecentRs[#adjecentRs + 1] = fakeRsData
			end
		end
	end
	
	for aZ = z - blockSize, z + blockSize, blockSize * 2 do
		local realZ = aZ / mult -- round(aZ)
		
		if redstoneDB[x] ~= nil and redstoneDB[x][y] ~= nil  then
			if redstoneDB[x][y][aZ] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][aZ], {x, y, aZ}}
			else
				local fakeBlock = GetNonRedstoneBlock(rsShape, Vec(x / mult, y / mult, z / mult))
				local fakeRsData = GetFakeBlockData(frontAltBlock)
				
				adjecentRs[#adjecentRs + 1] = fakeRsData
			end
		end
	end
	
	return adjecentRs
end

function GetBlockCenter(shape)
	local sMin, sMax = GetShapeBounds(shape)
	
	sMax[2] = sMin[2]
	
	local vec = VecCenter(sMin, sMax)
	
	vec[1] = roundOne(vec[1])
	vec[2] = roundOne(vec[2])
	vec[3] = roundOne(vec[3])
	
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
	negateY = negateY or true
	local sMin, sMax = GetShapeBounds(shape)
	
	if negateY then
		sMax[2] = sMin[2]
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

function GetNonRedstoneBlock(shape, localSide)
	localSide[1] = localSide[1] * origBlockSize
	localSide[2] = localSide[2] * origBlockSize
	localSide[3] = localSide[3] * origBlockSize
	
	local shapeTransform = GetShapeWorldTransform(shape)
	
	local side = TransformToParentPoint(shapeTransform, localSide)
	
	local searchSize = {origBlockSize, origBlockSize, origBlockSize}
	
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
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	local rsSoftPower = rsBlockData[7] -- Only valid for fake blocks.
	
	if rsBlockId == 12 then
		if rsPower <= 0 then
			return
		end
		
		local shapePos = GetRealBlockCenter(rsShape)
			
		MakeHole(shapePos, 0.2, 0.2, 0.2, true)
		
		return
	elseif rsBlockId == 124 then -- Don't need adjecent for this. Calculate manually.
		local shapeTransform = GetShapeWorldTransform(rsShape)
		
		local frontObject = TransformToParentPoint(shapeTransform, Vec(0.8, 0, -origBlockSize / 2))
		local rearObject = TransformToParentPoint(shapeTransform, Vec(0.8, 0, origBlockSize * 1.5))
		
		--spawnDebugParticle(frontObject, 2, Color4.Yellow)
		--spawnDebugParticle(rearObject, 2, Color4.Red)
		
		--DebugPrint("PRE " .. VecToString(rearObject))
		
		--rearObject = VecScale(rearObject, mult)
		frontObject[1] = roundOne(frontObject[1])
		frontObject[2] = y
		frontObject[3] = roundOne(frontObject[3])
		
		rearObject[1] = roundOne(rearObject[1])
		rearObject[2] = y
		rearObject[3] = roundOne(rearObject[3])
		
		local frontRsData = GetFromDB(frontObject[1], frontObject[2], frontObject[3])
		local rearRsData = GetFromDB(rearObject[1], rearObject[2], rearObject[3])
		
		local frontAltBlock = nil
		local rearAltBlock = nil
		
		if frontRsData == nil then
			frontAltBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 0.5, -0.5))
			frontRsData = GetFakeBlockData(frontAltBlock)
		end
		
		if rearRsData == nil then
			rearAltBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 0.5, 1.5))
			rearRsData = GetFakeBlockData(rearAltBlock)
		end
		
		if rearRsData ~= nil and rearRsData[7] ~= nil and rearRsData[3] <= 0 then
			rearRsData[3] = rearRsData[7]
		end
		
		if (rearRsData ~= nil and (rearRsData[3] > 0 or rearRsData[5] > 0)) or rsExtra[4] then
			SetShapeEmissiveScale(rsShape, 1)
			if rsExtra[3] > 0 then
				rsExtra[4] = true
				rsExtra[3] = rsExtra[3] - dt
			end
			
			local usableBlock = false
			
			if frontRsData ~= nil then
				usableBlock = frontRsData[2] ~= 46 and frontRsData[2] ~= 124 and frontRsData[2] ~= 125 and frontRsData[2] ~= 126
			end
			
			if frontRsData ~= nil and usableBlock and rsExtra[3] <= 0 then
				if frontAltBlock ~= nil then
					SetTag(frontAltBlock, "minecraftredstonehardpower", 16)
					SetTag(frontAltBlock, "minecraftredstonehardpowerlast", 16)
					fakePoweredBlocks[#fakePoweredBlocks + 1] = {frontAltBlock, frontRsData}
				else
					frontRsData[3] = 15
				end
			end
			
			if rsExtra[3] <= 0 then
				rsBlockData[3] = 15
				rsExtra[4] = false
			end
		else
			rsExtra[3] = rsExtra[2]
			SetShapeEmissiveScale(rsShape, 0)
			rsBlockData[3] = 0
		end
		
		return
	elseif rsBlockId == 125 or rsBlockId == 126 then
		if rsExtra[3] > 0 then
			rsExtra[3] = rsExtra[3] - dt
			rsBlockData[3] = 16
			local otherShape = rsBlockData[6][4]
		
			SetTag(otherShape, "minecraftredstonehardpower", 16)
			SetTag(otherShape, "minecraftredstonehardpowerlast", 16)
			
			local fakeRsData = GetFakeBlockData(otherShape)
			
			fakePoweredBlocks[#fakePoweredBlocks + 1] = {otherShape, fakeRsData}
		else
			rsBlockData[5] = rsBlockData[3]
			rsBlockData[3] = 0
		end
	elseif rsBlockId == 127 then
		if rsPower >= 1 or rsPowerLastTick >= 1 then
			SetShapeEmissiveScale(currConn, 1)
			SetLightEnabled(rsExtra, true)
		else
			SetShapeEmissiveScale(currConn, 0)
			SetLightEnabled(rsExtra, false)
		end
		
		rsBlockData[5] = rsBlockData[3]
		rsBlockData[3] = 0
		
		return
	end
	
	local adjecentRs = GetAdjecent(x, y, z, rsShape); -- {RSDATA, POS}
	
	if rsBlockId ~= 46 and rsBlockId ~= 125 and rsBlockId ~= 126 then
		SetShapeEmissiveScale(rsShape, 1 / 15 * rsPower)
		--DrawShapeHighlight(rsShape, 1 / 15 * rsPower)
	end
	
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
	
	if rsSoftPower ~= nil then
		local upRsData = GetFromDB(x, y + blockSize, z)
		
		if upRsData ~= nil then
			adjecentRs[#adjecentRs + 1] = {upRsData, Vec(x, y + blockSize, z), false}
		end
		
		local downRsData = GetFromDB(x, y + blockSize, z)
	end
	
	if rsBlockId == 123 then
		local fakeDownBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, -0.5, 0.5))
		local fakeDownRsData = GetFakeBlockData(fakeDownBlock)
		
		if fakeDownRsData ~= nil then
			adjecentRs[#adjecentRs + 1] = {fakeDownRsData, Vec(x, y - blockSize, z), true}
		end
	end
	
	for i = 1, #adjecentRs do
		local currAdjData = adjecentRs[i]
		
		local currRsData = currAdjData[1]
		local currRsPos = currAdjData[2]
		local currRsToSoftPower = currAdjData[3] -- Only valid for fake blocks.
		
		local currRsShape = currRsData[1]
		local currRsBlockId = currRsData[2]
		local currRsPower = currRsData[3]
		local currRsSoftPower = currRsData[7] -- Only valid for fake blocks.
		
		if currRsToSoftPower ~= nil and currRsToSoftPower then
			SetTag(currRsShape, "minecraftredstonesoftpower", rsPower)
			SetTag(currRsShape, "minecraftredstonesoftpowerlast", rsPower)
			fakePoweredBlocks[#fakePoweredBlocks + 1] = {currRsShape, currRsData}
		elseif currRsData[2] == 12 or currRsData[2] == 127  then
			if rsPower >= 1 then
				currRsData[3] = rsPower
			end
		elseif currRsBlockId == 123 then
			if currRsPower < rsPower - 1 then
				currRsData[3] = rsPower - 1
			end
		end
	end
	
	if rsBlockId ~= 46 and rsBlockId ~= 125 and rsBlockId ~= 126 then
		rsBlockData[5] = rsPower
		rsBlockData[3] = 0
	end
	--end
end