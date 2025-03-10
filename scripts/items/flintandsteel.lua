function flintAndSteelInit(extraData)
	local hit, hitPoint, distance, normal, shape = GetAimVariables()
	
	if HasTag(shape, "minecraftblockid") then
		local blockId = GetTagValue(shape, "minecraftblockid")
		
		if blockId == "TNT" then
			SetTag(shape, "minecrafttriggertnt", 1)
			return false, nil
		end
	end
	
	if hit and distance <= 5 then
		SpawnFire(hitPoint)
	end
	
	return false, nil
end 

function flintAndSteelUpdate(itemData, dt)

end