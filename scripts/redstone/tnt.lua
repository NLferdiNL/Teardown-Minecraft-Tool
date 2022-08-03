local mult = 100
local origBlockSize = 1.6
local blockSize = origBlockSize * mult

function HandleTnt(x, y, z, rsBlockData, dt)
	if rsBlockData == nil then
		return
	end
	
	local rsShape = rsBlockData[1]
	local rsPower = rsBlockData[3]
	local rsExtra = rsBlockData[6]
	
	if rsPower <= 0 and rsExtra == nil then
		return
	end
	
	if rsExtra == nil then
		rsBlockData[6] = 4.0
		SetBodyDynamic(GetShapeBody(rsShape), true)
		SetTag(rsShape, "unbreakable")
		return
	end
	
	if rsExtra > 0 then
		rsBlockData[6] = rsBlockData[6] - dt
		--DrawShapeHighlight(rsShape, 1 - (1 / 0.25 * rsExtra) % 1)
		DrawShapeHighlight(rsShape, GetTime() % (rsExtra + 1))
	else
		local shapePos = GetRealBlockCenter(rsShape)
		RemoveTag(rsShape, "unbreakable")
		MakeHole(shapePos, 0.2, 0.2, 0.2, true)
	end
end