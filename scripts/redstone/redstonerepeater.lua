function HandleRedstoneRepeater(x, y, z, rsBlockData, dt)
	if rsBlockData == nil or rsBlockData[6] == nil then
		return false
	end
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	local rsSoftPower = rsBlockData[7]
	
	local maxTick = rsExtra[2]
	local currTick = rsExtra[3]
	local afterTick = rsExtra[4]
	local rearPowered = rsExtra[5]
	local rearTorch = rsExtra[6]
	local rearTorchDefaultPos = rsExtra[7]
	
	local shapeTransform = GetShapeWorldTransform(rsShape)
	
	local rotX, rotY, rotZ = GetQuatEuler(shapeTransform.rot)
	
	local shapeRot = QuatEuler(0, roundToNearest(rotY, 90) - 90, 0)
	
	local frontBlock = GetNonRedstoneBlock(rsShape, Vec(-0.5, 0.5, -0.5), nil, shapeTransform.pos, shapeRot, {0.8, 0.95, 0.8})
	local rearBlock = GetNonRedstoneBlock(rsShape, Vec(1.5, 0.5, -0.5), nil, shapeTransform.pos, shapeRot)
	
	local frontRsData = GetRSDataFromShape(frontBlock)
	local rearRsData = GetRSDataFromShape(rearBlock)
	
	local rearTorchShape = GetBodyShapes(rearTorch)[1]
	local rsShapeTransform = GetShapeWorldTransform(rsShape)
	local rearTorchTransform = GetBodyTransform(rearTorch)
	
	if IsShapeBroken(rearTorchShape) then
		MakeHole(VecAdd(shapeTransform.pos, Vec(0.6, 0.1, 0.6)), 0.2, 0.2, 0.2)
		return false
	end
	
	local forwardVec = TransformToParentVec(rsShapeTransform, Vec(0, 0, -1))
	local tickOffset = maxTick - 0.1
	
	local torchPos = VecAdd(rearTorchDefaultPos, VecScale(forwardVec, tickOffset * 2))
	
	SetBodyTransform(rearTorch, Transform(torchPos, rearTorchTransform.rot))
	
	--[[if rearBlock ~= nil then
		DrawShapeOutline(rearBlock, 1, 0, 0, 1)
	end
	
	if frontBlock ~= nil then
		DrawShapeOutline(frontBlock, 0, 1, 0, 1)
	end]]--
	
	--[[if rearRsData ~= nil then
		DebugPrint(tableToText(rearRsData))
	end]]--
	
	if rearRsData ~= nil then
		local isRearPowered = rearRsData[3] > 0 or 
							  rearRsData[5] > 0 or
							  (rearRsData[7] ~= nil and rearRsData[7] > 0) or
							  (rearRsData[8] ~= nil and rearRsData[8] > 0)
		if isRearPowered then
			local firstloop = false
			if currTick <= 0 and not rearPowered then
				currTick = maxTick
				rsExtra[3] = currTick
				
				afterTick = 0.0
				rsExtra[4] = afterTick
				firstloop = true
			end
			
			rearPowered = true
			rsExtra[5] = rearPowered
			
			if firstloop then
				return true
			end
		else
			rearPowered = false
			rsExtra[5] = rearPowered
		end
	else
		rearPowered = false
		rsExtra[5] = rearPowered
	end
	
	if rearPowered or currTick > 0 or afterTick > 0 then
		if currTick > 0 then
			currTick = currTick - dt
			rsExtra[3] = currTick
			
			if currTick <= 0 then
				afterTick = 0.001
				rsExtra[4] = afterTick
				
				currTick = 0
				rsExtra[3] = currTick
			end
		elseif afterTick > 0 and not rearPowered then
			afterTick = afterTick - dt
			rsExtra[4] = afterTick
			
			if afterTick < 0 then
				afterTick = 0
				rsExtra[4] = afterTick
			end
		end
	end
	
	if (rearPowered and currTick <= 0) or afterTick > 0 then
		rsPower = 16
		rsBlockData[3] = rsPower
	else
		rsPower = 0
		rsBlockData[3] = rsPower
	end
	
	if rsPower > 0 and frontRsData ~= nil and frontRsData[2] ~= 124 then
		frontRsData[3] = 15
	end
	
	--[[rsPowerLastTick = rsPower
	rsPower = 0
	rsBlockData[3] = rsPower
	rsBlockData[5] = rsPowerLastTick]]--
	
	if rsPower > 0 or currTick > 0 or afterTick > 0 then
		SetShapeEmissiveScale(rsShape, 1)
		SetShapeEmissiveScale(rearTorchShape, 1)
	else
		SetShapeEmissiveScale(rsShape, 0)
		SetShapeEmissiveScale(rearTorchShape, 0)
	end
	
	return true
end