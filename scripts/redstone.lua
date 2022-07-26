redstoneDB = {}

-- TNT = 12
-- Block = 46
-- Dust = 123
-- Repeater = 124

-- rsBlockData = {shape, blockId, power, connectionShapes}
-- Origin = first block, then rest is pos + origin
local mult = 100
local blockSize = 1.6 * mult
--local origin = nil
--local rsCount = 0
--local dupeRs = 0
--local test = 0

function redstone_init()

end

function redstone_tick(dt)
	--local ax = 0
	--local ay = 0
	--local az = 0
	--test = 0
	--local liveCount = 0
	for x, xArray in pairs(redstoneDB) do
		--ax = ax + 1
		for y, yArray in pairs(xArray) do
			--ay = ay + 1
			for z, rsBlockData in pairs(yArray) do
				--az = az + 1
				if IsShapeBroken(rsBlockData[1]) then
					Redstone_Remove(Vec(x, y, z))
				elseif rsBlockData == nil then
				
				else
					HandleRedstone(x, y, z, rsBlockData)
					--liveCount = liveCount + 1
				end
			end
		end
	end
	
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
	
	if id == 46 then
		power = 16
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = {shape, id, power, ConnectionToTable(connections)}
	
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

function HandleRedstone(x, y, z, rsBlockData)
	--DebugWatch("ahh", GetTime())
	local adjecentRs = GetAdjecent(x, y, z); -- {RSDATA, POS}
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	
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
		rsBlockData[3] = 0
	end
	--end
end