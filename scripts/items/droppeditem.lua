function droppedInit(blockId)
	local currBlockData = blocks[blockId]
	
	local blockName = currBlockData[1]
	
	local itemSprite = itemSprites[blockName]
	
	if itemSprite == nil then
		itemSprite = LoadSprite("MOD/sprites/blocks/" .. blockName .. ".png")
		itemSprites[blockName] = itemSprite
	end
	
	local playerCamera = GetPlayerCameraTransform()
	local lifetime = 300
	local pos = playerCamera.pos
	local dir = TransformToParentVec(playerCamera, Vec(0, 0.1, -0.2))
	local speed = 0.25
	local justDroppedTimer = 1.5
	
	return true, {"Dropped Item", lifetime, pos, dir, speed, itemSprite, blockId, justDroppedTimer}, -1
end 

function droppedUpdate(itemData, dt)
	local lifetime = itemData[2]
	local pos = itemData[3]
	local dir = itemData[4]
	local speed = itemData[5]
	
	lifetime = lifetime - dt
	
	if lifetime <= 0 then
		return false
	end
	
	if itemData[8] > 0 then
		itemData[8] = itemData[8] - dt
	end
	
	--Todo: awake when block below removed.
	if speed ~= 0 then
		local currDir = dir
		
		if dir[2] <= 1 then
			currDir = VecAdd(dir, Vec(0, -dt, 0))
			
			if currDir[2] > 1 then
				currDir[2] = 1
			end
			
			itemData[4] = VecCopy(currDir)
		end
		
		local hit, dist, normal = QueryRaycast(pos, currDir, speed)
		
		itemData[2] = itemData[2] - dt
		
		if not hit then
			itemData[3] = VecAdd(pos, VecScale(currDir, speed))
			pos = itemData[3]
		else
			if currDir[1] ~= round(0) or currDir[3] ~= round(0) then
				local invNormal = Vec(-normal[1], 0, -normal[3])
				itemData[4] = VecSub(currDir, invNormal)
			--[[else
				speed = 0
				DebugPrint("HIT")
				itemData[3] = VecAdd(pos, VecScale(normal, 5))
				pos = itemData[3] ]]--
			end
		end
	end
	
	
	local playerCamera = GetPlayerCameraTransform()
	local lookAtPos = playerCamera.pos
	lookAtPos[2] = pos[2]
	
	if itemData[8] <= 0 then
		local playerTransform = GetPlayerTransform()
		
		if VecDist(playerTransform.pos, pos) <= 0.8 then
			local emptySpot = -1
			local foundFreeDuplicateSpot = -1
			
			for i = 9 * 4, 9 * 3, -1 do
				if inventory[i][1] == "" or inventory[i][2] <= 0 then
					emptySpot = i
				elseif inventory[i][1] == itemData[7] and inventory[i][2] <= 63 then
					foundFreeDuplicateSpot = i
				end
			end
			
			if foundFreeDuplicateSpot > 0 then
				inventory[foundFreeDuplicateSpot][2] = inventory[foundFreeDuplicateSpot][2] + 1
				return false
			elseif emptySpot > 0 then
				inventory[emptySpot][1] = itemData[7]
				inventory[emptySpot][2] = 1
				return false
			end
		end
	end
	
	local spriteSize = 0.5
	
	DrawSprite(itemData[6], Transform(VecAdd(pos, Vec(0, spriteSize / 2, 0)), QuatLookAt(pos, lookAtPos)), spriteSize, spriteSize, 1, 1, 1, 1, true, false)
	
	return true
end