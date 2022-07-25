redstoneDB = {}

-- TNT = 12
-- Block = 46
-- Dust = 123

-- rsBlockData = {shape, blockId, power}

local blockSize = 1.6

function redstone_init()

end

function redstone_tick(dt)
	for x, xArray in pairs(redstoneDB) do
		for y, yArray in pairs(xArray) do
			for z, rsBlockData in pairs(yArray) do
				if IsShapeBroken(rsBlockData[1]) then
					Redstone_Remove(Vec(x, y, z))
				elseif rsBlockData == nil then
				
				else
					HandleRedstone(x, y, z, rsBlockData)
				end
			end
		end
	end
end

function Redstone_Add(id, shape, pos)
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	pos = GetBlockCenter(shape)
	
	if redstoneDB[pos[1]] == nil then
		redstoneDB[pos[1]] = {}
	end
	
	if redstoneDB[pos[1]][pos[2]] == nil then
		redstoneDB[pos[1]][pos[2]] = {}
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = {shape, id, 0}
	
	DebugPrint("Spawn: " .. VecToString(pos))
end

function Redstone_Remove(pos)
	--pos = VecRound(pos, 2)
	--pos = Vec(pos[1] / blockSize, pos[2] / blockSize, pos[3] / blockSize)
	pos = GetBlockCenter(shape)
	
	if redstoneDB[pos[1]] == nil then
		return
	end
	
	if redstoneDB[pos[1]][pos[2]] == nil then
		return
	end
	
	redstoneDB[pos[1]][pos[2]][pos[3]] = nil
	DebugPrint("Destroy")
end

function GetAdjecent(x, y, z)
	local adjecentRs = {}
	
	for aX = x - blockSize, x + blockSize, blockSize * 2 do
		local roundX = round(aX)
		
		spawnDebugParticle(Vec(roundX, y, z), 0.1, Color4.Green)
		if redstoneDB[roundX] ~= nil and redstoneDB[roundX][y] ~= nil then
			if redstoneDB[roundX][y][z] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[roundX][y][z], {roundX, y, z}}
			end
		end
	end
	
	for aZ = z - blockSize, z + blockSize, blockSize * 2 do
		local roundZ = round(aZ)
		
		spawnDebugParticle(Vec(x, y, roundZ), 0.1, Color4.Green)
		
		if redstoneDB[x] ~= nil and redstoneDB[x][y] ~= nil  then
			if redstoneDB[x][y][roundZ] ~= nil then
				adjecentRs[#adjecentRs + 1] = {redstoneDB[x][y][z], {x, y, roundZ}}
			end
		end
	end
	
	DebugWatch("a", #adjecentRs)
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
	
	local vec = VecCenter(sMin, sMax), 3
	
	vec[1] = roundOne(vec[1])
	vec[2] = roundOne(vec[2])
	vec[3] = roundOne(vec[3])
	
	return vec
end

function roundOne(a)
	return math.floor(a * 10)/10
end

function HandleRedstone(x, y, z, rsBlockData)
	local adjecentRs = GetAdjecent(x, y, z);
	
	if rsBlockData[1] == 46 then
		for i = 1, #adjecentRs do
			if adjecentRs[1][2] == 12 then
				local shape = adjecentRs[1][1]
				local shapePos = GetShapeWorldTransform(shape).pos
				MakeHole(pos, 0.2, 0.2, 0.2, true)
			end
		end
	elseif rsBlockData[1] == 123 then
		
	end
end