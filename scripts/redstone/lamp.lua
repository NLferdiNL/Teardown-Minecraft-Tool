local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleLamp(x, y, z, rsBlockData, dt)
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
	
	if rsPower >= 1 or rsPowerLastTick >= 1 then
		SetShapeEmissiveScale(currConn, 1)
		SetLightEnabled(rsExtra, true)
	else
		SetShapeEmissiveScale(currConn, 0)
		SetLightEnabled(rsExtra, false)
	end
	
	rsBlockData[5] = rsBlockData[3]
	rsBlockData[3] = 0
end