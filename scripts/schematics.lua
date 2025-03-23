local schematic_test = {{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}},
						{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}},
						{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}},
						{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Oak Planks", nil, nil, nil, "Oak Planks"},
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}},
						{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks", "Oak Planks"},
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}}}


function schematics_init()
	
end

function FindAndDeleteAtPos(pos)
	pos = getGridAlignedPos(pos)
	local toRemove = FindBlocksAt(Transform(pos), Vec(0, 0.2, 0))
	
	if toRemove ~= nil and #toRemove > 1 then
		RemoveBlock(toRemove[1])
	end
end

function PlaceSchematic(hitpoint, schematic)
	for x = 1, #schematic do
		for y = 1, #schematic[x] do
			for z = 1, #schematic[x][y] do
				if schematic[x][y][z] ~= nil then
					PlaceBlock(schematic[x][y][z], VecAdd(hitpoint, Vec(x * 1.6, y * 1.6, z * 1.6)))
				end
			end
		end
	end
end

function BuildPortal(hitpoint)
	PlaceSchematic(hitpoint, schematic_test)
	return
end--[[
	for i = 1, 3 do 
		local bottomBlockPos = VecAdd(hitpoint, Vec(i * 1.6, 0, 0))
		local topBlockPos = VecAdd(hitpoint, Vec(i * 1.6, 1.6 * 4, 0))
		local leftBlockPos = VecAdd(hitpoint, Vec(0, 1.6 * i, 0))
		local rightBlockPos = VecAdd(hitpoint, Vec(1.6 * 4, 1.6 * i, 0))
		
		--[FindAndDeleteAtPos(bottomBlockPos)
		FindAndDeleteAtPos(topBlockPos)
		FindAndDeleteAtPos(leftBlockPos)
		FindAndDeleteAtPos(rightBlockPos)]--
		
		PlaceBlock("Obsidian", bottomBlockPos)
		PlaceBlock("Obsidian", topBlockPos)
		
		PlaceBlock("Obsidian", leftBlockPos)
		PlaceBlock("Obsidian", rightBlockPos)
	end
end]]--