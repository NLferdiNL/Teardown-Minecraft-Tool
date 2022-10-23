local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

-- max time, time, orig pos, id, otherShape
--{1.0, 0.0, platePos, extraData[2]}
function HandlePressurePlate(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsExtra = rsBlockData[6]
	
	local maxTime = rsExtra[1]
	local currTime = rsExtra[2]
	local originalPos = rsExtra[3]
	local otherShape = rsExtra[4]
	
	local shapeBody = GetShapeBody(rsShape)
	local shapeTransform = GetShapeWorldTransform(rsShape)
	
	local active = false
	
	if rsBlockId == 166 then
		active = GetActiveStateStone(originalPos)
	elseif rsBlockId == 167 then
		active = GetActiveStateWood(originalPos)
	end
	
	if active then
		local downDir = TransformToParentVec(shapeTransform, Vec(0, -1, 0))
		local downDirScaled = VecScale(downDir, 0.075)

		SetBodyTransform(shapeBody, Transform(VecAdd(originalPos, downDirScaled), shapeTransform.rot))
		
		local fakeRsData = GetRSDataFromShape(otherShape)
		
		if fakeRsData ~= nil then
			fakeRsData[3] = 16
			DrawShapeOutline(otherShape, 1, 1, 1, 1)
		else
			DrawShapeOutline(otherShape, 1, 0, 0, 1)
		end
		
		rsBlockData[3] = 16
	else
		SetBodyTransform(shapeBody, Transform(originalPos, shapeTransform.rot))
		
		rsBlockData[5] = rsBlockData[3]
		rsBlockData[3] = 0
	end
end

function GetActiveStateWood(pos)
	if GetActiveStateStone(pos) then
		return true
	end
	
end

function GetActiveStateStone(pos)
	local playerPos = GetPlayerTransform().pos
	
	local buttonMin = VecAdd(pos, Vec(0.1, 0.0, 0.0))
	local buttonMax = VecAdd(pos, Vec(1.5, 0.0, 1.5))
	
	local meetsX = playerPos[1] > buttonMin[1] and playerPos[1] <  buttonMax[1]
	local meetsY = playerPos[2] > buttonMin[2] and playerPos[2] <  buttonMax[2] + 0.1
	local meetsZ = playerPos[3] > buttonMin[3] and playerPos[3] <  buttonMax[3]
	
	return meetsX and meetsY and meetsZ
end