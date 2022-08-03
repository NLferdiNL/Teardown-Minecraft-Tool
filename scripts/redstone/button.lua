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
	
	if rsExtra[3] > 0 then
		rsExtra[3] = rsExtra[3] - dt
		rsBlockData[3] = 16
		local otherShape = rsBlockData[6][4]
	
		--SetTag(otherShape, "minecraftredstonehardpower", 16)
		--SetTag(otherShape, "minecraftredstonehardpowerlast", 16)
		
		local fakeRsData = GetRSDataFromShape(otherShape)
		
		if fakeRsData ~= nil then
			fakeRsData[3] = 16
		end
	else
		rsBlockData[5] = rsBlockData[3]
		rsBlockData[3] = 0
	end
end