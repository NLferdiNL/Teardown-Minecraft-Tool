function fireChargeInit(extraData)
	local playerCamera = GetPlayerCameraTransform()
	local lifetime = 100
	local pos = playerCamera.pos
	local dir = TransformToParentVec(playerCamera, Vec(0, 0, -1))
	local speed = 1
	
	return true, {"Fire Charge", lifetime, pos, dir, speed}, -1
end 

function fireChargeUpdate(itemData, dt)
	local lifetime = itemData[2]
	local pos = itemData[3]
	local dir = itemData[4]
	local speed = itemData[5]
	
	local hit, dist = QueryRaycast(pos, dir, speed)
	
	itemData[2] = itemData[2] - dt
	
	if not hit then
		itemData[3] = VecAdd(pos, VecScale(dir, speed))
		pos = itemData[3]
	else
		local hitPoint = VecAdd(pos, VecScale(dir, dist))
		Explosion(hitPoint, 0.5)
		lifetime = 0
	end
	
	if lifetime <= 0 then
		return false
	end
	
	local playerCamera = GetPlayerCameraTransform()
	
	local fireSprite = itemSprites[itemData[1]]
	
	DrawSprite(fireSprite, Transform(pos, QuatLookAt(pos, playerCamera.pos)), 1, 1, 1, 1, 1, 1, true, false)
	
	return true
end