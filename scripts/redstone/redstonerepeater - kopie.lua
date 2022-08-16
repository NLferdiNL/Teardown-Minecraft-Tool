local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleRedstoneRepeater(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsPower = rsBlockData[3]
	local rsExtra = rsBlockData[6]
	
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
	
	local frontRsData = nil --GetFromDB(frontObject[1], frontObject[2], frontObject[3])
	local rearRsData = nil --GetFromDB(rearObject[1], rearObject[2], rearObject[3])
	
	local frontAltBlock = nil
	local rearAltBlock = nil
	local rotX, rotY, rotZ = GetQuatEuler(shapeTransform.rot)
	
	local overridePos = Vec(x / mult, y / mult, z / mult)
	
	--DebugPrint(roundOne(rotY / 100))
	
	rotY = roundOne(rotY / 100)
	
	if rotY == -90 then
		overridePos[1] = overridePos[1] + 1.6
	elseif rotY == 90 then
		overridePos[3] = overridePos[3] + 1.6
	elseif rotY == 180 then
		overridePos[1] = overridePos[1] + 1.6
		overridePos[3] = overridePos[3] + 1.6
	end
	
	if frontRsData == nil then
		frontAltBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 0.5, -0.5), nil, overridePos, QuatEuler(0, rotY, 0))
		frontRsData = GetRSDataFromShape(frontAltBlock)
	end
	
	if rearRsData == nil then
		rearAltBlock = GetNonRedstoneBlock(rsShape, Vec(0.5, 0.5, 1.5), nil, overridePos, QuatEuler(0, rotY, 0))
		rearRsData = GetRSDataFromShape(rearAltBlock)
	end
	
	if rearRsData ~= nil and rearRsData[7] ~= nil and rearRsData[3] <= 0 then
		rearRsData[3] = rearRsData[7]
	end
	
	local rearPower = 0
	
	if rearRsData ~= nil then
		rearPower = rearRsData[3]
		if rearRsData[5] > rearPower then
			rearPower = rearRsData[5]
		end
		
		if rearRsData[7] ~= nil then
			if rearRsData[7] > rearPower then
				rearPower = rearRsData[7]
			end
			
			--[[if rearRsData[8] > rearPower then
				rearPower = rearRsData[8]
			end]]--
		end
	end
	
	if (rearRsData ~= nil and (rearPower > 0)) or rsExtra[4] then
		SetShapeEmissiveScale(rsShape, 1)
		if rsExtra[3] > 0 then
			rsExtra[4] = true
			rsExtra[3] = rsExtra[3] - dt
		end
		
		local usableBlock = false
		
		if frontRsData ~= nil then
			usableBlock = frontRsData[2] ~= 46 and frontRsData[2] ~= 124 and frontRsData[2] ~= 125 and frontRsData[2] ~= 126 and frontRsData[2] ~= 129
		end
		
		if frontRsData ~= nil and usableBlock and rsExtra[3] <= 0 then
			--DebugPrint("HAA")
			--if frontAltBlock ~= nil then
				--SetTag(frontAltBlock, "minecraftredstonehardpower", 16)
				--SetTag(frontAltBlock, "minecraftredstonehardpowerlast", 16)
				
				--[[local fakeBlockIndex = fakePoweredBlocksShapeIndex[frontAltBlock]
				
				if fakeBlockIndex == nil then
					fakeBlockIndex = #fakePoweredBlocks + 1
					
					fakePoweredBlocksShapeIndex[frontAltBlock] = #fakePoweredBlocks + 1
					
				end
				
				if fakePoweredBlocks[fakeBlockIndex] == nil then
					fakePoweredBlocks[fakeBlockIndex] = frontRsData
				end]]--
				
				--frontRsData[3] = 15
			--else
			frontRsData[3] = 16
			--DebugPrint(tableToText(frontRsData))
			--end
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
end