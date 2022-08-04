local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleButton(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsBlockId = rsBlockData[2]
	local rsPower = rsBlockData[3]
	local rsExtra = rsBlockData[6]
	
	local maxTime = rsExtra[2]
	local timer = rsExtra[3]
	local otherShape = rsExtra[4]
	local sfxPress = rsExtra[5]
	local sfxUnpress = rsExtra[6]
	
	if timer > 0 then
		rsExtra[3] = rsExtra[3] - dt
		rsBlockData[3] = 16
	
		--SetTag(otherShape, "minecraftredstonehardpower", 16)
		--SetTag(otherShape, "minecraftredstonehardpowerlast", 16)
		
		local fakeRsData = GetRSDataFromShape(otherShape)
		
		if fakeRsData ~= nil then
			fakeRsData[3] = 16
		end
	else
		if rsBlockData[5] > 0 and rsBlockData[3] <= 0 then
			PlaySound(sfxUnpress, GetShapeWorldTransform(rsBlockData[1]).pos, 5)
		end
	
		rsBlockData[5] = rsBlockData[3]
		rsBlockData[3] = 0
	end
end

function HandleButtonInteraction(rsBlockData)
	rsBlockData[3] = 16
	rsBlockData[6][3] = rsBlockData[6][2]
	
	--if rsBlockData[5] <= 0 then
	
		local rsExtra = rsBlockData[6]
		
		local sfxPress = rsExtra[5]
		PlaySound(sfxPress, GetShapeWorldTransform(rsBlockData[1]).pos, 5)
	--end
end