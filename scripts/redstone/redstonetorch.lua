local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleRedstoneTorch(x, y, z, rsBlockData, dt)
	if rsBlockData == nil or rsBlockData[6] == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsPower = rsBlockData[3]
	local rsPowerLastTick = rsBlockData[5]
	local rsExtra = rsBlockData[6]
	
	local rsLight = rsExtra[1]
	local attachedShape = rsExtra[2]
	
	local hardPower = 0
	local hardPowerLast = 0
	
	local softPower = 0
	local softPowerLast = 0
	
	local attachedRsData = nil
	
	if attachedShape ~= nil then
		attachedRsData = GetRSDataFromShape(attachedShape)
		--DrawShapeHighlight(attachedShape, 1)
	end
	
	if rsExtra[6] > 0 then
		rsExtra[6] = rsExtra[6] - dt
		
		if rsExtra[6] <= 0 then
			rsExtra[6] = 0
			rsExtra[7] = false
		end
	end
	
	if rsExtra[7] then
		SetLightEnabled(rsLight, false)
		SetShapeEmissiveScale(rsShape, 0)
		return
	end
	
	--[[if IsShapeBroken(attachedShape) then
		DebugPrint("BREAK")
		local breakPoint = GetRealBlockCenter(rsShape, 2)
		
		breakPoint = VecAdd(breakPoint, Vec(0, -0.25, 0))
		
		spawnDebugParticle(breakPoint, 1, Color4.Green)
		MakeHole(breakPoint, 0.25, 0.25, 0.25)
		return false
	end]]--
	
	if attachedRsData ~= nil then
		hardPower = attachedRsData[3]
		hardPowerLast = attachedRsData[5]
		
		softPower = attachedRsData[7]
		softPowerLast = attachedRsData[8]
	end
	
	--[[local hardPower = GetTagValue(attachedShape, "minecraftredstonehardpower")
	local hardPowerLast = GetTagValue(attachedShape, "minecraftredstonehardpowerlast")
	
	local softPower = GetTagValue(attachedShape, "minecraftredstonesoftpower")
	local softPowerLast = GetTagValue(attachedShape, "minecraftredstonesoftpowerlast")]]--
	
	if softPower == nil then
		softPower = 0
	end
	
	if softPowerLast == nil then
		softPowerLast = 0
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
		
		--DebugPrint("NOT")
		
		--[[if hardPower == hardPowerLast or softPower == softPowerLast and rsExtra[4] ~= rsExtra[3] / 2 then
			rsExtra[4] = rsExtra[3] / 2
		end]]--
	else
		--DebugPrint("AM")
		if rsExtra[4] >= 0 then
			rsExtra[4] = rsExtra[4] - dt
			
			if rsExtra[4] <= 0 then
				rsBlockData[3] = 16
			end
		end
	
		if rsBlockData[3] <= 0 and rsExtra[4] <= 0 then
			rsExtra[4] = rsExtra[3]
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
	
	--[[if rsBlockData[3] >=1 then
		SetShapeEmissiveScale(currConn, 1)
	else
		SetShapeEmissiveScale(currConn, 0)
	end]]--
	
	SetLightEnabled(rsLight, rsBlockData[3] >= 1)
	if rsPower >= 1 then
		SetShapeEmissiveScale(rsShape, 1)
	else
		SetShapeEmissiveScale(rsShape, 0)
		rsExtra[6] = rsExtra[6] + dt * (math.random(15, 20) / 10)
		
		if rsExtra[6] > 0.5 then
			rsExtra[7] = true
			local shapePos = GetShapeWorldTransform(rsShape).pos
			
			PlaySound(getFizzSfx(), shapePos, math.random(25, 50) / 100)
			PlayFizzParticleEffect(shapePos)
		end
	end
	
	return rsBlockData[3] >= 1
end

function PlayFizzParticleEffect(pos)
	ParticleReset()
	ParticleType("smoke")
	ParticleTile(6)
	ParticleColor(1, 0.4, 0.05, 0.1, 0.1, 0.1) 
	ParticleRadius(0.05)
	ParticleGravity(1.25, -5)
	ParticleEmissive(2, 0)
	ParticleStretch(2, 0)
	for i = 1, math.random(7,10) do
		local rndPos = Vec(pos[1], pos[2] + origBlockSize * 0.75, pos[3])
		local rndDir = rndVec(5)
		SpawnParticle(rndPos, rndDir, math.random(20, 30) / 10)
	end
end

function rndVec(length)
	local v = VecNormalize(Vec(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
	return VecScale(v, length)	
end

function getFizzSfx()
	if soundSfx["fizz"] == nil then
		soundSfx["fizz"] = LoadSound("MOD/sfx/fizz.ogg")
	end
	
	return soundSfx["fizz"]
end