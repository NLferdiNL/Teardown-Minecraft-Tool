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
	local rsSoftPower = rsBlockData[7]
	local rsSoftPowerLastTick = rsBlockData[8]
	
	if rsPower >= 1 or rsPowerLastTick >= 1 or rsSoftPower >= 1 or rsSoftPowerLastTick >= 1 then
		SetLightIntensity(rsExtra, 1)
	
		SetShapeEmissiveScale(rsShape, 1)
		SetLightEnabled(rsExtra, true)
	else
		SetShapeEmissiveScale(rsShape, 0)
		SetLightEnabled(rsExtra, false)
		return
	end
	
	if rsPower > 0 then
		local adjecentRs = GetAdjecent(x, y, z, rsShape, 127)
		local upBlock = GetFromDB(x, y + blockSize, z)
		local downBlock = GetFromDB(x, y - blockSize, z)
		
		if upBlock ~= nil and upBlock[2] == 127 then
			adjecentRs[#adjecentRs + 1] = {upBlock, Vec(x, y + blockSize, z), false}
		end
		
		if downBlock ~= nil and downBlock[2] == 127 then
			adjecentRs[#adjecentRs + 1] = {downBlock, Vec(x, y - blockSize, z), false}
		end
		
		for i = 1, #adjecentRs do
			local currAdjData = adjecentRs[i]
			
			local currRsData = currAdjData[1]
			local currRsPos = currAdjData[2]
			local currRsToSoftPower = currAdjData[3]
			
			local currRsShape = currRsData[1]
			local currRsBlockId = currRsData[2]
			local currRsPower = currRsData[3]
			local currRsSoftPower = currRsData[7]
			
			if currRsBlockId == 127 and currRsPower <= 0 and currRsSoftPower < rsPower - 1 then
				currRsData[7] = rsPower - 2
			end
		end
	end
	
	rsBlockData[5] = rsBlockData[3]
	rsBlockData[3] = 0
	
	rsBlockData[8] = rsBlockData[7]
	rsBlockData[7] = 0
end