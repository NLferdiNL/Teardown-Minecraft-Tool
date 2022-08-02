local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleTnt(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsPower = rsBlockData[3]
	
	if rsPower <= 0 then
		return
	end
	
	local shapePos = GetRealBlockCenter(rsShape)
		
	MakeHole(shapePos, 0.2, 0.2, 0.2, true)
end