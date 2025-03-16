portalSprites = {}

--During horizontal frame finding, check one block above and stop for frame edges.
--Other wise it will find the farthest and cause issues.

local function initPortalSprites()
	for i = 1, 32 do
		local currSprite = "MOD/sprites/effects/nether_portal/" .. i .. ".png"
		
		portalSprites[i] = LoadSprite(currSprite)
	end
end

local function FindBlockAbove(block)
	QueryRejectShape(block)
	QueryRequire("static")
	
	local shapeBoundsMin, shapeBoundsMax = GetShapeBounds(block)
	local blockCenter = VecLerp(shapeBoundsMin, shapeBoundsMax, 0.5)
	
	local hit, dist, normal, shape = QueryRaycast(blockCenter, Vec(0, 1, 0), 40)
	
	--DebugLine(blockCenter, VecAdd(blockCenter, VecScale(Vec(0, 1, 0), dist)))
	
	if HasTag(shape, "minecraftblockid") and GetTagValue(shape, "minecraftblockid") == "Obsidian" and dist > 0.9 then
		return shape, dist
	end
	
	return nil
end

local function SearchForBlocksInDirection(start, direction)
	local blocksFound = {}

	for i = 1, 20 do
		local foundBlocksAtPosition = FindBlocksAt(start, VecScale(direction, i))
		
		if #foundBlocksAtPosition <= 0 then
			-- End of portal
			break
		else
			blocksFound[i] = foundBlocksAtPosition[1]
		end
		
		if blocksFound[i] ~= nil and HasTag(blocksFound[i], "minecraftblockid") then
			local blockId = GetTagValue(blocksFound[i], "minecraftblockid")
			
			if blockId ~= "Obsidian" then
				blocksFound[i] = nil
				-- End of portal
				break
			end
		end
	end
	
	return blocksFound
end

local function FindBlocksLeftRight(pos, dir, maxDist)
	local pieces = {}
	
	-- Left first
	QueryRequire("static")
	local hit, dist, normal, shape = QueryRaycast(pos, dir, maxDist)
	
	if not hit then
		return nil
	end
	
	--DebugLine(pos, VecAdd(pos, VecScale(dir, dist)))
	
	if not HasTag(shape, "minecraftblockid") or GetTagValue(shape, "minecraftblockid") ~= "Obsidian" then
		return nil
	end
	
	pieces[1] = {shape, dist}
	
	-- Now right
	QueryRequire("static")
	hit, dist, normal, shape = QueryRaycast(pos, VecScale(dir, -1), maxDist)
	
	if not hit then
		return nil
	end
	
	if not HasTag(shape, "minecraftblockid") or GetTagValue(shape, "minecraftblockid") ~= "Obsidian" then
		return nil
	end
	
	--DebugLine(pos, VecAdd(pos, VecScale(VecScale(dir, -1), dist)))
	
	pieces[2] = {shape, dist}
	
	return pieces
end

local function GetCenterBetweenTwoBlocks(a, b)
	local minA, maxA = GetShapeBounds(a)
	local minB, maxB = GetShapeBounds(b)
	
	local aCenter = VecLerp(minA, maxA, 0.5)
	local bCenter = VecLerp(minB, maxB, 0.5)
	
	return aCenter, bCenter, VecLerp(aCenter, bCenter, 0.5)
end

local function IndexBlocksAbove(fromTable, toTable)
	local firstDist = 0

	for i = #fromTable, 0, -1 do
		local block, dist = FindBlockAbove(fromTable[i]) 
		
		if block ~= nil then
			if firstDist == 0 then
				firstDist = dist
			end
			
			toTable[#toTable + 1] = {fromTable[i], block}
		else
			fromTable[i] = nil
		end
	end
	
	return firstDist
end

local function GetPortalFrame(starterBlock)
	local portalFound = true
	
	local shapeBoundsMin, shapeBoundsMax = GetShapeBounds(starterBlock)
	local blockTransform = Transform(VecLerp(shapeBoundsMin, shapeBoundsMax, 0.5))

	local blocksLeft = SearchForBlocksInDirection(blockTransform, Vec(1.6, 0, 0))
	local blocksRight = SearchForBlocksInDirection(blockTransform, Vec(-1.6, 0, 0))
	
	-- TODO: Combine left and right into one longy.
	
	local portalHorizontalFrame = {}
	
	local portalVerticalFrameDirection = Vec(1, 0, 0)
	local frameForward = Vec(0, 0, 1)
	
	--DebugPrint("---")
	--DebugPrint(#blocksLeft)
	--DebugPrint(#blocksRight)
	
	--table.insert(blocksLeft, 1, starterBlock)
	table.insert(blocksRight, 1, starterBlock)
	
	IndexBlocksAbove(blocksLeft, portalHorizontalFrame)
	local upwardsDist = IndexBlocksAbove(blocksRight, portalHorizontalFrame)
	
	if #portalHorizontalFrame <= 1 then
		local blocksForwards = SearchForBlocksInDirection(blockTransform, Vec(0, 0, 1.6))
		local blocksBackwards = SearchForBlocksInDirection(blockTransform, Vec(0, 0, -1.6))
		
		portalVerticalFrameDirection = Vec(0, 0, 1)
		frameForward = Vec(1, 0, 0)
		
		--table.insert(blocksForwards, 1, starterBlock)
		table.insert(blocksBackwards, 1, starterBlock)
	
		portalHorizontalFrame = {}
		
		IndexBlocksAbove(blocksForwards, portalHorizontalFrame)
		upwardsDist = IndexBlocksAbove(blocksBackwards, portalHorizontalFrame)
	end
	
	if #portalHorizontalFrame <= 1 then
		return false, 0, 0, Vec()
	end
	
	local minCenter, maxCenter, horizontalCenter = GetCenterBetweenTwoBlocks(portalHorizontalFrame[1][1], portalHorizontalFrame[#portalHorizontalFrame][1])
	
	upwardsDist = upwardsDist - 1.6
	
	local steps = math.ceil(upwardsDist / 1.6)
	
	local portalVerticleFrame = {}
	
	local maxWidth = VecDist(minCenter, maxCenter) + 1.6 / 2
	
	local portalCenter = VecAdd(horizontalCenter, Vec(0, (upwardsDist + 0.8) / 2 + 0.8, 0))
	
	for i = 1, steps do
		local framePieces = FindBlocksLeftRight(VecAdd(horizontalCenter, Vec(0, 1.6 * i, 0)), portalVerticalFrameDirection, maxWidth)
		
		if framePieces == nil then
			portalFound = false
			break
		end
		
		portalVerticleFrame[#portalVerticleFrame + 1] = framePieces
	end
	
	-- Once bottom edge is found: use bottom edge via raycast to find top
	-- Use this data to find left and right
	
	--local blockRight = FindBlocksAt(Transform(blockCenter), Vec(gridModulo, 0, 0))
	--local blockUp = FindBlocksAt(Transform(blockCenter), Vec(gridModulo, 0, 0))
	--local blockDown = FindBlocksAt(Transform(blockCenter), Vec(gridModulo, 0, 0))
	
	if not portalFound then
		return false, 0, 0, Vec()
	end
	
	local framePieces = {}
	
	for i = 1, #portalHorizontalFrame do
		framePieces[#framePieces + 1] = portalHorizontalFrame[i][1]
		framePieces[#framePieces + 1] = portalHorizontalFrame[i][2]
	end
	
	for i = 1, #portalVerticleFrame do
		framePieces[#framePieces + 1] = portalVerticleFrame[i][1][1]
		framePieces[#framePieces + 1] = portalVerticleFrame[i][2][1]
	end
	
	return true, maxWidth + 0.8, upwardsDist + 0.8, portalCenter, framePieces, VecAdd(portalCenter, frameForward)
end

function startPortal(initialBlock)
	local frameFound, frameWidth, frameHeight, frameCenter, framePieces, frameForward = GetPortalFrame(initialBlock)
	
	if #portalSprites <= 0 then
		initPortalSprites()
	end

	if not frameFound then
		return false, nil
	end
	
	return true, {"Portal", frameWidth, frameHeight, frameCenter, framePieces, frameForward, 1}
end

function portalUpdate(itemData, dt)
	itemData[7] = itemData[7] + dt * 10
	
	if itemData[7] > 32 then
		itemData[7] = 1
	end
	
	local currentFrame = round(itemData[7])
	
	local currentFrame = portalSprites[currentFrame]
	
	
	
	local pos = itemData[4]
	local rot = QuatLookAt(pos, itemData[6])
	
	local transform = Transform(pos, rot)
	
	DrawSprite(currentFrame, transform, itemData[2], itemData[3], 1, 1, 1, 0.9, true, false, true)
	
	for i = 1, #itemData[5] do
		if IsShapeBroken(itemData[5][i]) then
			return false
		end
	end
	
	return true
end