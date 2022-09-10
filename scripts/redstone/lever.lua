local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleLever(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsConnections = rsBlockData[4]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	local rsSoftPower = rsBlockData[7]
	local rsSoftPowerLastTick = rsBlockData[8]
	
	
	local bodyTransform = GetBodyTransform(rsExtra)
	local rotX, rotY, rotZ = GetQuatEuler(bodyTransform.rot)
	
	local roundRot = round(rotX)
	
	rsBlockData[5] = rsPower
	
	if roundRot <= 0 then
		rsBlockData[3] = 16
	else
		rsBlockData[3] = 0
	end
	
end