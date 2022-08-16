local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

--    1       2   		3		4					5				6					7			8
-- {shape, block id, power, connection shapes, power last tick, extra(repeaterdata), softPower, softPowerLast}

--				tag	   tick  curr
-- extra = {"interact", 0.1, 0.0}
function HandleRedstoneRepeater(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsPower = rsBlockData[3]
	local rsExtra = rsBlockData[6]
	
	local shapeTransform = GetShapeWorldTransform(rsShape)
		
	--[[local frontObject = TransformToParentPoint(shapeTransform, Vec(0.8, 0, -origBlockSize / 2))
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
	rearObject[3] = roundOne(rearObject[3])]]--
	
	local rotX, rotY, rotZ = GetQuatEuler(shapeTransform.rot)
	
	local shapeRot = QuatEuler(0, roundToNearest(rotY, 90) - 90, 0)
	
	local frontBlock = GetNonRedstoneBlock(rsShape, Vec(-0.5, 0.5, -0.5), nil, shapeTransform.pos, shapeRot)
	local rearBlock = GetNonRedstoneBlock(rsShape, Vec(1.5, 0.5, -0.5), nil, shapeTransform.pos, shapeRot)
	
	local frontRsData = GetRSDataFromShape(frontBlock)
	local rearRsData = GetRSDataFromShape(rearBlock)
	
	local tickMax = rsExtra[2]
	local tickCurr = rsExtra[3]
	local tickLinger = rsExtra[4]
	
	local rearPowered = false
	
	DrawShapeOutline(frontBlock, 1, 0, 0, 1)
	DrawShapeOutline(rearBlock, 0, 1, 0, 1)
	
	if rearRsData ~= nil then
		local rearPower = 0
		
		if rearRsData[3] >= 1 and rearRsData[5] >= 1 then
			rearPower = rearRsData[5]
		end
		
		if rearRsData[7] ~= nil and rearRsData[7] >= 1 and rearRsData[8] ~= nil and rearRsData[8] >= 1 then
			rearPower = rearRsData[7]
		end
		
		rearPowered = rearPower >= 1
	end
	
	DebugPrint(rsExtra[3])
	
	if rearPowered or tickCurr > 0 then
		if tickCurr < tickMax then
			rsExtra[3] = tickCurr + dt
			tickCurr = rsExtra[3]
		else
			rsBlockData[3] = 15
			rsPower = rsBlockData[3]
			
			rsExtra[3] = tickMax
			
			rsExtra[4] = 0.1
			tickLinger = 0.1
		end
	end
	
	if not rearPowered and tickLinger > 0 then
		rsExtra[4] = tickLinger - dt
		rsExtra[3] = 0
	elseif not rearPowered and tickLinger <= 0 then
		rsBlockData[3] = 0
	end
	
	if rsPower >= 1 then
		if frontRsData ~= nil and frontRsData[2] ~= 124 then
			frontRsData[3] = 15
		end
		SetShapeEmissiveScale(rsShape, 1)
	elseif rsPower <= 0 then
		SetShapeEmissiveScale(rsShape, 0)
	end
	
	rsBlockData[5] = rsBlockData[3]
end