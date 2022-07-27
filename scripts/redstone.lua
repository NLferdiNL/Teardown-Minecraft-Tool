redstoneDB = {}

-- TNT = 12
-- Block = 46
-- Dust = 123
-- Repeater = 124

-- rsBlockData = {shape, block id, power, connection shapes, power last tick, extra(repeaterdata)}
-- Origin = first block, then rest is pos + origin
local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult
--local origin = nil
--local rsCount = 0
--local dupeRs = 0
--local test = 0

function redstone_init()

end

function redstone_update(dt)
	--local ax = 0
	--local ay = 0
	--local az = 0
	--test = 0
	--local liveCount = 0
	--local repeaterQueue = {}
	
	--local repeaterTest = 0
	
	for x, xArray in pairs(redstoneDB) do
		--ax = ax + 1
		for y, yArray in pairs(xArray) do
			--ay = ay + 1
			for z, rsBlockData in pairs(yArray) do
				--az = az + 1
				if IsShapeBroken(rsBlockData[1]) then
					Redstone_Remove(Vec(x, y, z))
				elseif rsBlockData == nil then
				
				--elseif rsBlockData[2] == 124 then
					--repeaterQueue[#repeaterQueue + 1] = {x, y, z, rsBlockData}
				else
					--[[if rsBlockData[2] == 124 then
						repeaterTest = repeaterTest + 1
					end]]--
					HandleRedstone(x, y, z, rsBlockData, dt)
					--liveCount = liveCount + 1
				end
			end
		end
	end
	
	--DebugWatch("repeaterTest", repeaterTest)
	
	--[[for i = 1, #repeaterQueue do
		HandleRedstone(repeaterQueue[i][1], repeaterQueue[i][2], repeaterQueue[i][3], repeaterQueue[i][4])
	end]]--
	
	--DebugWatch("x", ax)
	--DebugWatch("y", ay)
	--DebugWatch("z", az)
	--DebugWatch("recorded", rsCount)
	--DebugWatch("live", liveCount)
end

function Redstone_Add(id, shape, connections)
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
		extra = {0.4, 0.4, false}
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = {shape, id, power, ConnectionToTable(connections), power, extra}
	
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

function ConnectionToTable(str)
	local returnTable = {}

	for shape in string.gmatch(str, "%d+") do
		returnTable[#returnTable + 1] = tonumber(shape)
	end
	
	return returnTable
end

function GetAdjecent(x, y, z)
	local adjecentRs = {}
	
	--spawnDebugParticle(Vec(x, y, z), 0.25, Color4.Blue)
	
	for aX = x - blockSize, x + blockSize, blockSize * 2 do
		local realX = aX / mult -- round(aX)
		
		if redstoneDB[aX] ~= nil and redstoneDB[aX][y] ~= nil then
			if redstoneDB[aX][y][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[aX][y][z], {aX, y, z}}
				--spawnDebugParticle(Vec(realX, y / mult, z / mult), 0.25, Color4.Green)
			else
				--spawnDebugParticle(Vec(realX, y / mult, z / mult), 0.25, Color4.Yellow)
			end
		else
			--spawnDebugParticle(Vec(realX, y / mult, z / mult), 0.25, Color4.Yellow)
		end
	end
	
	for aZ = z - blockSize, z + blockSize, blockSize * 2 do
		local realZ = aZ / mult -- round(aZ)
		
		if redstoneDB[x] ~= nil and redstoneDB[x][y] ~= nil  then
			if redstoneDB[x][y][aZ] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][aZ], {x, y, aZ}}
				--spawnDebugParticle(Vec(x / mult, y / mult, realZ), 0.25, Color4.Green)
			else
				--spawnDebugParticle(Vec(x / mult, y / mult, realZ), 0.25, Color4.Yellow)
			end
		else
			--spawnDebugParticle(Vec(x / mult, y / mult, realZ), 0.25, Color4.Yellow)
		end
	end
	
	--test = test + 1
	--DebugWatch("a", test)
		--[[for aY = y - blockSize, y + blockSize, blockSize * 2 do
			aY = y
			for aZ = z - blockSize, z + blockSize, blockSize * 2 do
				
				local roundY = round(aY)
				local roundZ = round(aZ)
				
				spawnDebugParticle(Vec(roundX, roundY, roundZ), 0.1, Color4.Green)
				
				DebugWatch(VecToString(Vec(roundX, roundY, roundZ)), false)
				if redstoneDB[roundX] ~= nil then
					if redstoneDB[roundX][roundY] ~= nil then
						if redstoneDB[roundX][roundY][roundZ] ~= nil then
							DebugWatch(VecToString(Vec(roundX, roundY, roundZ)), true)
							DebugPrint(VecToString(Vec(roundX,roundY,roundZ)))
							adjecentRs[#adjecentRs + 1] = {redstoneDB[roundX][roundY][roundZ], {roundX, roundY, roundZ}}
						end
					end
				end
			end
		--end
	end]]--
	-- Definitely some better way than spaghetti. Works for now.
	
	--[[if redstoneDB[x + 1] ~= nil then
		if redstoneDB[y] ~= nil then
			if redstoneDB[x + 1][y][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x + 1][y][z], {x + 1, y, z}}
			end
		end
	end
	
	if redstoneDB[x - 1] ~= nil then
		if redstoneDB[y] ~= nil then
			if redstoneDB[x - 1][y][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x - 1][y][z], {x - 1, y, z}}
			end
		end
	end
	
	if redstoneDB[x] ~= nil then
		if redstoneDB[y + 1] ~= nil then
			if redstoneDB[x][y + 1][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y + 1][z], {x, y + 1, z}}
			end
		end
	end
	
	if redstoneDB[x] ~= nil then
		if redstoneDB[y - 1] ~= nil then
			if redstoneDB[x][y - 1][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y - 1][z], {x, y - 1, z}}
			end
		end
	end
	
	if redstoneDB[x] ~= nil then
		if redstoneDB[y] ~= nil then
			if redstoneDB[x][y][z + 1] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][z + 1], {x, y, z + 1}}
			end
		end
	end
	
	if redstoneDB[x] ~= nil then
		if redstoneDB[y] ~= nil then
			if redstoneDB[x][y][z - 1] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][z - 1], {x, y, z - 1}}
			end
		end
	end]]--
	
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

function GetRealBlockCenter(shape)
	local sMin, sMax = GetShapeBounds(shape)
	
	sMax[2] = sMin[2]
	
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

function HandleRedstone(x, y, z, rsBlockData, dt)
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[6]
	local rsExtra = rsBlockData[6]
	
	if rsBlockId == 124 then -- Don't need adjecent for this. Calculate manually.
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
		
		--[[if frontRsData ~= nil then
			DrawShapeOutline(frontRsData[1], 0.75, 0.75, 0, 1)
		else
			DebugPrint("Bark1 " .. GetTime())
		end
		
		if rearRsData ~= nil then
			DrawShapeOutline(rearRsData[1], 0.75, 0, 0, 1)
		else
			DebugPrint("Bark2 " .. GetTime())
		end]]--
		
		--DebugWatch("front", frontRsData == nil)
		--DebugWatch("back", rearRsData == nil)
		
		--[[if rearRsData ~= nil and rearRsData[2] == 124 then
		DebugPrint(tableToText(rearRsData))
		end]]--
		
		--DebugWatch("extra 1", rsExtra[1])
		--DebugWatch("extra 2", rsExtra[2])
		
		--[[if rsExtra[3] then
			DebugPrint("1 " .. tostring(frontRsData ~= nil))
			if frontRsData ~= nil then
				DebugPrint("2 " .. tostring(frontRsData[2] == 123))
			end
		end]]--
		
		--DebugWatch("cond 1", rearRsData ~= nil)
		--DebugWatch("cond 2", rearRsData ~= nil and rearRsData[3] > 0)
		
		--[[if rearRsData ~= nil then
			DebugWatch("cond 2.a", rearRsData[3])
		end]]--
		
		if (rearRsData ~= nil and (rearRsData[3] > 0 or rearRsData[5] > 0)) or rsExtra[3] then
			SetShapeEmissiveScale(rsShape, 1)
			if rsExtra[2] > 0 then
				rsExtra[3] = true
				rsExtra[2] = rsExtra[2] - dt
				--DebugWatch("AHH", 2)
			end
			
			if frontRsData ~= nil and frontRsData[2] == 123 and rsExtra[2] <= 0 then
				--DebugPrint(frontRsData[3])
				frontRsData[3] = 15
				--DebugPrint(frontRsData[3])
				--DrawShapeHighlight(frontRsData[1], 0.5)
				--DebugPrint("FIRE")
				--DebugWatch("AHH", 3)
			end
			
			if rsExtra[2] <= 0 then
				rsBlockData[3] = 15
				--DebugPrint("BANG")
				rsExtra[3] = false
			end
		else
			--DebugWatch("AHH", 1)
			rsExtra[2] = rsExtra[1]
			SetShapeEmissiveScale(rsShape, 0)
			--DebugPrint("Bark " .. GetTime())
			rsBlockData[3] = 0
		end
		
		return
	end
	--DebugWatch("ahh", GetTime())
	local adjecentRs = GetAdjecent(x, y, z); -- {RSDATA, POS}
	
	if rsBlockId ~= 46 then
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
	
	--[[if rsBlockData[2] == 46 then
		for i = 1, #adjecentRs do
			local currAdjData = adjecentRs[i]
			
			local currRsData = currAdjData[1]
			
			local currRsShape = currRsData[1]
			local currRsBlockId = currRsData[2]
			local currRsPower = currRsData[3]
			
			if currRsData[2] == 12 then
				local shapePos = GetRealBlockCenter(currRsShape)
				
				MakeHole(shapePos, 0.2, 0.2, 0.2, true)
			elseif currRsBlockId == 123 then
				if currRsPower < 15 then
					currRsData[3] = 15
				end
			end
		end
	elseif rsBlockData[2] == 123 then]]--
	for i = 1, #adjecentRs do
		local currAdjData = adjecentRs[i]
		
		local currRsData = currAdjData[1]
		local currRsPos = currAdjData[2]
		
		local currRsShape = currRsData[1]
		local currRsBlockId = currRsData[2]
		local currRsPower = currRsData[3]
		
		if currRsData[2] == 12 and rsPower >= 1 then
			local shapePos = GetRealBlockCenter(currRsShape)
			
			MakeHole(shapePos, 0.2, 0.2, 0.2, true)
		elseif currRsBlockId == 123 then
			if currRsPower < rsPower - 1 then
				currRsData[3] = rsPower - 1
			end
		end
	end
	
	if rsBlockId ~= 46 then
		rsBlockData[5] = rsPower
		rsBlockData[3] = 0
	end
	--end
end