function tableToText(inputTable, loopThroughTables, useIPairs, addIndex, addNewLine)
	loopThroughTables = loopThroughTables or true
	useIPairs = useIPairs or false
	addIndex = addIndex or true
	addNewLine = addNewLine or false
	
	local returnString = "{ "
	
	if useIPairs then
		for key, value in ipairs(inputTable) do
			if type(value) == "string" or type(value) == "number" then
				returnString = returnString .. (not addIndex and key .. " = " or " ") .. value .. (addNewLine and ",\n" or ", ")
			elseif type(value) == "table" and loopThroughTables then
				returnString = returnString .. (not addIndex and key .. " = " or " ") .. tableToText(value, loopThroughTables, useIPairs, addIndex, addNewLine) .. (addNewLine and ",\n" or ", ")
			else
				returnString = returnString .. (not addIndex and key .. " = " or " ") .. tostring(value) .. (addNewLine and ",\n" or ", ")
			end
		end
	else
		for key, value in pairs(inputTable) do
			if type(value) == "string" or type(value) == "number" then
				returnString = returnString .. (not addIndex and key .. " = " or " ") .. value .. (addNewLine and ",\n" or ", ")
			elseif type(value) == "table" and loopThroughTables then
				returnString = returnString .. (not addIndex and key .. " = " or "") .. tableToText(value, loopThroughTables, useIPairs, addIndex, addNewLine) .. (addNewLine and ",\n" or ", ")
			else
				returnString = returnString .. (not addIndex and key .. " = " or " ") .. tostring(value) .. (addNewLine and ",\n" or ", ")
			end
		end
	end
	returnString = returnString .. "}"
	
	return returnString
end

function roundToTwoDecimals(a) -- To support older mods incase I update the utils.lua
	--return math.floor(a * 100)/100
	return roundToDecimal(a, 2)
end

function posAroundCircle(i, points, originPos, radius)
	local x = originPos[1] + radius * math.cos(2 * i * math.pi / points)
	local z = originPos[3] - radius * math.sin(2 * i * math.pi / points)
	
	return {x, originPos[2], z}
end

function rndVec(length)
	local v = VecNormalize(Vec(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
	return VecScale(v, length)	
end

function Lerp(a, b, t)
    return a + (b - a) * t
end

function VecDir(a, b)
	return VecNormalize(VecSub(b, a))
end

function VecCenter(a, b)
	return Vec((a[1] + b[1]) / 2, (a[2] + b[2]) / 2, (a[3] + b[3]) / 2)
end

function VecCeil(a)
	return Vec(math.ceil(a[1]), math.ceil(a[1]), math.ceil(a[1]))
end

function VecFloor(a)
	return Vec(math.floor(a[1]), math.floor(a[1]), math.floor(a[1]))
end

function VecRound(vec, numDecimalPlaces)
	return Vec(round(vec[1], numDecimalPlaces), round(vec[2], numDecimalPlaces), round(vec[3], numDecimalPlaces))
end

function roundToDecimal(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function round(num)
  return num + (2^52 + 2^51) - (2^52 + 2^51)
end

function VecAngle(a, b)
	local magA = VecMag(a)
	local magB = VecMag(b)
	
	local dotP = VecDot(a, b)
	
	local angle = math.deg(math.acos(dotP / (magA * magB)))
	
	return angle
end

function VecDist(a, b)
	local directionVector = VecSub(b, a)
	
	local distance = VecMag(directionVector)
	
	return distance
end

function VecMag(a)
	return math.sqrt(a[1]^2 + a[2]^2 + a[3]^2)
end

function VecAbs(a)
	return Vec(math.abs(a[1]), math.abs(a[2]), math.abs(a[3]))
end

function VecToString(vec)
	return vec[1] .. ", " .. vec[2] .. ", " .. vec[3]
end

function VecInvert(vec)
	return Vec(-vec[1], -vec[2], -vec[3])
end

function VecCompare(a, b)
	return a[1] == b[1], a[2] == b[2], a[3] == b[3]
end

function VecCross(a, b)
	local xC = a[2] * b[3] - a[3] * b[2]
	local yC = a[3] * b[1] - a[1] * b[3]
	local zC = a[1] * b[2] - a[2] * b[1]
	
	return Vec(xC, yC, zC)
end

--[[function VecRotate(origin, point, angle)
	local centeredPoint = VecSub(point, origin)
	
	
end]]--

function raycast(origin, direction, maxDistance, radius, rejectTransparant)
	maxDistance = maxDistance or 500 -- Make this arguement optional, it is usually not required to raycast further than this.
	local hit, distance, normal, shape = QueryRaycast(origin, direction, maxDistance, radius, rejectTransparant)
	
	if hit then
		local hitPoint = VecAdd(origin, VecScale(direction, distance))
		return hit, hitPoint, distance, normal, shape
	end
	
	return false, nil, nil, nil, nil
end

function getMaxTextSize(text, fontSize, maxSize, minFontSize)
	minFontSize = minFontSize or 1
	UiPush()
		UiFont("regular.ttf", fontSize)
		
		local currentSize = UiGetTextSize(text)
		
		while currentSize > maxSize and fontSize > minFontSize do
			fontSize = fontSize - 0.1
			UiFont("regular.ttf", fontSize)
			currentSize = UiGetTextSize(text)
		end
	UiPop()
	return fontSize, fontSize > minFontSize
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function renderBillboardSprite(spriteHandle, pos, lookPos, size, color4, depth, additive)
	size = size or 0.5
	color4 = color4 or Color4.White
	depth = depth or false
	additive = additive or false
	
	local lookAtCameraRot = QuatLookAt(pos, lookPos)

	local spriteTransform = Transform(pos, lookAtCameraRot)
	
	DrawSprite(spriteHandle, spriteTransform, size, size, color4.r, color4.g, color4.b, color4.a, false, false)
end

local frontLookRot = QuatLookAt(Vec(0, 0, 0), Vec(0, 0, -1))
local topLookRot = QuatLookAt(Vec(0, 0, 0), Vec(0, -1, 0))
local sideLookRot = QuatLookAt(Vec(0, 0, 0), Vec(-1, 0, 0))

function getAaBbCorners(minPos, maxPos, extraWide)
	if extraWide ~= nil and extraWide ~= 0 then
		local dirToMin = VecDir(maxPos, minPos)
		local dirToMax = VecDir(minPos, maxPos)
		minPos = VecAdd(minPos, VecScale(dirToMin, extraWide))
		maxPos = VecAdd(maxPos, VecScale(dirToMax, extraWide))
	end

	local xWidth = -(minPos[1] - maxPos[1])
	local yWidth = -(minPos[2] - maxPos[2])
	local zWidth = -(minPos[3] - maxPos[3])

	local cRBT = VecAdd(maxPos, Vec(0, -yWidth, 0)) 	--corner right back top cRBT
	local cRBB = maxPos 								-- corner right back bottom cRBB
	
	local cRFT = VecAdd(minPos, Vec(xWidth, 0, 0)) 		-- corner right front top cRFT
	local cRFB = VecAdd(maxPos, Vec(0, 0, -zWidth)) 	-- corner right front bottom cRFB
	
	local cLBT = VecAdd(minPos, Vec(0, 0, zWidth)) 		-- corner left back top cLBT
	local cLBB = VecAdd(minPos, Vec(0, yWidth, zWidth)) -- corner left back bottom cLBB
	
	local cLFT = minPos 								-- corner left front top cLFT
	local cLFB = VecAdd(minPos, Vec(0, yWidth, 0)) 		-- corner left front bottom cLFB
	
	return xWidth, yWidth, zWidth, cRBT, cRBB, cRFT, cRFB, cLBT, cLBB, cLFT, cLFB
end

function renderAabbZone(minPos, maxPos, red, green, blue, alpha, renderFaces)
	local xWidth, yWidth, zWidth, cRBT, cRBB, 
		  cRFT, cRFB, cLBT, cLBB, cLFT, cLFB = getAaBbCorners(minPos, maxPos, 0.01)

	local frontFace = VecLerp(cLFT, cRFB, 0.5)
	local backFace = VecLerp(cLBT, cRBB, 0.5)
	
	local leftFace = VecLerp(cLFT, cLBB, 0.5)
	local rightFace = VecLerp(cRFT, cRBB, 0.5)
	
	local topFace = VecLerp(cLFT, cRBT, 0.5)
	local bottomFace = VecLerp(cLFB, cRBB, 0.5)

	DrawLine(cRBT, cRBB, red, green, blue, alpha)
	DrawLine(cRFT, cRFB, red, green, blue, alpha)
	DrawLine(cLBT, cLBB, red, green, blue, alpha)
	DrawLine(cLFT, cLFB, red, green, blue, alpha)
	
	DrawLine(cRBT, cLBT, red, green, blue, alpha)
	DrawLine(cLBB, cRBB, red, green, blue, alpha)
	
	DrawLine(cRFT, cLFT, red, green, blue, alpha)
	DrawLine(cLFB, cRFB, red, green, blue, alpha)
	
	DrawLine(cRFT, cRBT, red, green, blue, alpha)
	DrawLine(cRFB, cRBB, red, green, blue, alpha)
	
	DrawLine(cLFT, cLBT, red, green, blue, alpha)
	DrawLine(cLFB, cLBB, red, green, blue, alpha)
	
	if renderFaces then
		renderFace(frontFace, frontLookRot, xWidth, yWidth, red, green, blue, alpha / 2)
		renderFace(backFace, frontLookRot, xWidth, yWidth, red, green, blue, alpha / 2)
		
		renderFace(leftFace, sideLookRot, zWidth, yWidth, red, green, blue, alpha / 2)
		renderFace(rightFace, sideLookRot, zWidth, yWidth, red, green, blue, alpha / 2)
		
		renderFace(topFace, topLookRot, xWidth, zWidth, red, green, blue, alpha / 2)
		renderFace(bottomFace, topLookRot, xWidth, zWidth, red, green, blue, alpha / 2)
	end
end

local faceSprite = LoadSprite("MOD/sprites/square.png")

function renderFace(pos, rot, xWidth, yWidth, red, green, blue, spriteAlpha)
	DrawSprite(faceSprite, Transform(pos, rot), xWidth, yWidth, red, green, blue, spriteAlpha, true, false)
end

function spawnDebugParticle(pos, lifetime, color4)
	lifetime = lifetime or 10
	color4 = color4 or {r = 1, g = 0, b = 0}
	ParticleReset()
	ParticleCollide(0)
	ParticleType("plain")
	ParticleTile(4)
	ParticleColor(color4.r, color4.g, color4.b)
	ParticleRadius(0.25)
	SpawnParticle(pos, Vec(), lifetime)
end

function GetRandomPosBetween(a, b)
	local rX = math.random() * (b[1] - a[1]) + a[1]
	local rY = math.random() * (b[2] - a[2]) + a[2]
	local rZ = math.random() * (b[3] - a[3]) + a[3]

	return Vec(rX, rY, rZ)
end

function CheckIfPosWithin(pos, minBounds, maxBounds)
	local xCheck = pos[1] > minBounds[1] and pos[1] < maxBounds[1]
	
	if not xCheck then
		return false
	end
	
	local yCheck = pos[2] > minBounds[2] and pos[2] < maxBounds[2]
	
	if not yCheck then
		return false
	end
	
	local zCheck = pos[3] > minBounds[3] and pos[3] < maxBounds[3]
	
	if not zCheck then
		return false
	end
	
	return true
end

function roundToNearest(x, factor) 
    return math.floor(x/factor+0.5)*factor
end

function CollisionCheckCenterPivot(pos, size)
	margin = margin or 0.05

	local minPos = Vec(pos[1] + margin - size[1] / 2, 
					   pos[2] + margin - size[2] / 2, 
					   pos[3] + margin - size[3] / 2)
	
	local maxPos = Vec(pos[1] + size[1] / 2 - margin, 
					   pos[2] + size[2] / 2 - margin, 
					   pos[3] + size[3] / 2 - margin)
	
	local shapes = QueryAabbShapes(minPos, maxPos)
	
	return shapes
end

function CollisionCheck(pos, size, margin)
	margin = margin or 0.05

	local minPos = Vec(pos[1] + margin, pos[2] + margin, pos[3] + margin)
	local maxPos = Vec(pos[1] + size[1] / 2 - margin, 
					   pos[2] + size[2] / 2 - margin, 
					   pos[3] + size[3] / 2 - margin)
	
	local shapes = QueryAabbShapes(minPos, maxPos)
	
	return shapes
end

--[[glm::vec3 CreateAngledPoint(glm::vec3 rotation_point, float radius, float angle, glm::vec3 normal)
{
    // Normalize the normal (axis to rotate on)
    normal = glm::normalize(normal);
    // Create a vector that will be used for the dot product
    glm::vec3 to_cross = glm::normalize(glm::vec3(0.0f,1.0f,0.0f));
    // Make sure that the normal and cross vector are not the same, if they are change the cross vector
    if (to_cross == normal) to_cross = glm::normalize(glm::vec3(0.0f, 0.0f, 1.0f));
    // Get the cross product
    glm::vec3 to_return = glm::normalize(glm::cross(normal,to_cross));
    // Rotate point around the axis
    to_return = glm::rotate(to_return, angle* RAD_TO_DEG, normal);
    // Scale the point up from the origin
    to_return *= radius;
    // Apply it to the point in space we are rotating around
    return rotation_point + to_return;
}

function CreateAngledVec(rotation_point, radius, angle, normal)
	normal = VecNormalize(normal)
	
	local to_cross = VecNormalize(Vec(0, 1, 0))
	
	local xC, yC, zC = VecCompare(to_cross, normal)
	
	local vecSame = xC and yC and zC
	
	if vecSame then
		to_cross = VecNormalize(Vec(0, 0, 1))
	end
	
	local cross = VecNormalize(VecCross(a, b))
	
	
end]]--