function enderPearlInit(extraData)
	local playerCamera = GetPlayerCameraTransform()
	local lifetime = 100
	local pos = playerCamera.pos
	local dir = TransformToParentVec(playerCamera, Vec(0, 0, -1))
	local speed = 0.25
	
	return true, {"Ender Pearl", lifetime, pos, dir, speed}, -1
end 

function enderPearlUpdate(itemData, dt)
	local lifetime = itemData[2]
	local pos = itemData[3]
	local dir = itemData[4]
	local speed = itemData[5]
	
	local hit, dist, normal = QueryRaycast(pos, dir, speed)
	
	itemData[2] = itemData[2] - dt
	
	if not hit then
		--dir[1] = dir[1] * 0.99
		dir[2] = dir[2] - 0.005
		--dir[3] = dir[3] * 0.99
	
		itemData[3] = VecAdd(pos, VecScale(dir, speed))
		pos = itemData[3]
	else
		local hitPoint = VecAdd(pos, VecScale(dir, dist))
		
		local playerTransform = GetPlayerTransform()
		
		playerTransform.pos = VecAdd(hitPoint, VecScale(normal, 0.05))
		
		SetPlayerTransform(playerTransform)
		local hp = GetPlayerHealth()
		
		SetPlayerHealth(hp - 0.2)
		
		lifetime = 0
	end
	
	if lifetime <= 0 then
		return false
	end
	
	local playerCamera = GetPlayerCameraTransform()
	
	local pearlSprite = itemSprites[itemData[1]]
	
	DrawSprite(pearlSprite, Transform(pos, QuatLookAt(pos, playerCamera.pos)), 1, 1, 1, 1, 1, 1, true, false)
	
	return true
end