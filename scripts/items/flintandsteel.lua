function flintAndSteelInit()
	local hit, hitPoint, distance, normal, shape = GetAimVariables()
	
	if hit and distance <= 5 then
		SpawnFire(hitPoint)
	end
	
	return false, nil
end 

function flintAndSteelUpdate(itemData, dt)

end