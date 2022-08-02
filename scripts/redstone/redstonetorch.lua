local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleRedstoneTorch(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsPower = rsBlockData[3]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	
	local rsLight = rsExtra[1]
	local attachedShape = rsExtra[2]
	
	if attachedShape == nil then
		return
	end
	
	local hardPower = GetTagValue(attachedShape, "minecraftredstonehardpower")
	local hardPowerLast = GetTagValue(attachedShape, "minecraftredstonehardpowerlast")
	
	local softPower = GetTagValue(attachedShape, "minecraftredstonesoftpower")
	local softPowerLast = GetTagValue(attachedShape, "minecraftredstonesoftpowerlast")
	
	if hardPower == nil or hardPower == "" then
		hardPower = 0
	else
		hardPower = tonumber(hardPower)
	end
	
	if hardPowerLast == nil or hardPowerLast == ""  then
		hardPowerLast = 0
	else
		hardPowerLast = tonumber(hardPowerLast)
	end
	
	if softPower == nil or softPower == ""  then
		softPower = 0
	else
		softPower = tonumber(softPower)
	end
	
	if softPowerLast == nil or softPowerLast == ""  then
		softPowerLast = 0
	else
		softPowerLast = tonumber(softPowerLast)
	end
	
	--[[DebugWatch("hardPower", hardPower)
	DebugWatch("hardPowerLast", hardPowerLast)
	DebugWatch("softPower", softPower)
	DebugWatch("softPowerLast", softPowerLast)
	DebugWatch("timer", rsExtra[4])
	DebugWatch("rsPowerLastTick", rsPowerLastTick)
	DebugWatch("rsPower", rsPower)]]--
	
	if hardPower > 0 or hardPowerLast > 0 or softPower > 0 or softPowerLast > 0 then
		rsBlockData[3] = 0
		rsExtra[4] = rsExtra[3]
		
		--[[if hardPower == hardPowerLast or softPower == softPowerLast and rsExtra[4] ~= rsExtra[3] / 2 then
			rsExtra[4] = rsExtra[3] / 2
		end]]--
	else
		if rsBlockData[3] <= 0 and rsExtra[4] <= 0 then
			rsExtra[4] = rsExtra[3]
		end
	
		if rsExtra[4] > 0 then
			rsExtra[4] = rsExtra[4] - dt
			
			if rsExtra[4] <= 0 then
				rsBlockData[3] = 16
			end
		end
	end
	
	--[[if rsPowerLastTick <= 0 and rsPower >= 1 and rsPowerLastTick ~= rsPower and rsExtra[4] <= 0 then
		rsExtra[4] = rsExtra[3]
		rsBlockData[5] = rsPower
	end
	
	if hardPower > 0 or hardPowerLast > 0 or softPower > 0 or softPowerLast > 0 then
		rsBlockData[3] = 0
		rsExtra[4] = 0
	else
		if rsExtra[4] > 0 then
			rsExtra[4] = rsExtra[4] - dt
			return
		else
			rsBlockData[3] = 16
		end
	end]]--
	
	if rsBlockData[3] >=1 then
		SetShapeEmissiveScale(currConn, 1)
	else
		SetShapeEmissiveScale(currConn, 0)
	end
	
	SetLightEnabled(rsLight, rsBlockData[3] >= 1)
end