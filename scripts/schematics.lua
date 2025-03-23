local box_test = { name = "Box Test",
			  blocks = {{{"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"},
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
						 {"Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone", "Cobblestone"}}}}
						 
local built_in_schematics = {box_test}

local clipboard = {name = "Clipboard", blocks = {{{}}}}

local copy_pos_a = nil
local copy_pos_b = nil

local selected_schematic = box_test


SCHEMATIC_STATE = {
	IDLE = "IDLE",
	COPYING = "COPYING",
	PASTING = "PASTING",
}

local currentSchematicState = SCHEMATIC_STATE.IDLE

function getCurrentSchematicState()
	return currentSchematicState
end

function schematics_init()
	-- Load schematics
end

local function render_schematic(hitpoint, schematic)
	local playerTf = GetPlayerTransform()
	
	--DebugPrint(#schematic)
	
	for x = 1, #schematic do
		DebugPrint("X")
		for y = 1, #schematic[x] do
			DebugPrint("Y")
			for z = 1, #schematic[x][y] do
				if schematic[x][y][z] ~= nil then
					DebugPrint("Z")
					local blockPos = VecAdd(hitpoint, Vec(x * 1.6 - 0.8, y * 1.6 - 0.8, z * 1.6 - 0.8))
					
					blockPos[1] = blockPos[1] - blockPos[1] % 1.6 + 0.8
					blockPos[2] = blockPos[2] - blockPos[2] % 1.6 + 0.8
					blockPos[3] = blockPos[3] - blockPos[3] % 1.6 + 0.8
					
					local lookAtPlayer = QuatLookAt(blockPos, playerTf.pos)
					DrawSprite(blockSprites[schematic[x][y][z]], Transform(blockPos, lookAtPlayer), 1.6, 1.6, 1, 1 ,1 ,1, true, false, false)
				end
			end
		end
	end
end

local function place_schematic(hitpoint, schematic)
	for x = 1, #schematic do
		for y = 1, #schematic[x] do
			for z = 1, #schematic[x][y] do
				if schematic[x][y][z] ~= nil then
					local blockPos = VecAdd(hitpoint, Vec(x * 1.6 - 0.8, y * 1.6 - 0.8, z * 1.6 - 0.8))
					
					blockPos[1] = blockPos[1] - blockPos[1] % 1.6 + 0.8
					blockPos[2] = blockPos[2] - blockPos[2] % 1.6 + 0.8
					blockPos[3] = blockPos[3] - blockPos[3] % 1.6 + 0.8
					
					PlaceBlock(schematic[x][y][z], blockPos)
				end
			end
		end
	end
end

local function load_into_schematic(a, b, schematic_blocks)
	--TODO: make sure a < b
	for x = a[1], b[1] + 1.6, 1.6 do
		schematic_blocks[math.floor(x / 1.6)] = {}
		DebugPrint(math.floor(x / 1.6))
		
		for y = a[2], b[2] + 1.6, 1.6 do
			schematic_blocks[math.floor(x / 1.6)][math.floor(y / 1.6)] = {}
			for z = a[3], b[3] + 1.6, 1.6 do
				local blocks = FindBlocksAt(Transform(Vec(x, y , z)), Vec(0, 0, 0))
				
				if #blocks > 0 then
					schematic_blocks[math.floor(x / 1.6)][math.floor(y / 1.6)][math.floor(z / 1.6)] = GetTagValue(blocks[1], "minecraftblockid")
					
					DrawShapeHighlight(blocks[1], 1)
				end
			end
		end
	end
end

--renderAabbZone(minPos, maxPos, red, green, blue, alpha, renderFaces)

local function update_copy(hitpoint)
	local blockPos = VecCopy(hitpoint)
					
	blockPos[1] = blockPos[1] - blockPos[1] % 1.6 + 0.8
	blockPos[2] = blockPos[2] - blockPos[2] % 1.6 + 0.8
	blockPos[3] = blockPos[3] - blockPos[3] % 1.6 + 0.8
	
	if InputPressed(binds["Schematic_Start_Copy"]) then
		copy_pos_a = nil
		copy_pos_b = nil
		currentSchematicState = SCHEMATIC_STATE.IDLE
		return
	end
	
	--TODO: make sure b can be lower than a.
	
	if copy_pos_a == nil then
		renderAabbZone(VecAdd(blockPos, Vec(-0.8, -0.8, -0.8)), VecAdd(blockPos, Vec(0.8, 0.8, 0.8)), 0, 0, 1, 0.5, true)
		if InputPressed(binds["Place"]) then
			currentSchematicState = SCHEMATIC_STATE.IDLE
		elseif InputPressed(binds["Mine"]) then
			copy_pos_a = VecCopy(blockPos)
		end
	elseif copy_pos_b == nil then
		renderAabbZone(VecAdd(copy_pos_a, Vec(-0.8, -0.8, -0.8)), VecAdd(blockPos, Vec(0.8, 0.8, 0.8)), 0, 0, 1, 0.5, true)
		if InputPressed(binds["Place"]) then
			copy_pos_a = nil
		elseif InputPressed(binds["Mine"]) then
			copy_pos_b = VecCopy(blockPos)
		end
	else
		renderAabbZone(VecAdd(copy_pos_a, Vec(-0.8, -0.8, -0.8)), VecAdd(copy_pos_b, Vec(0.8, 0.8, 0.8)), 0, 0, 1, 0.5, true)
		if InputPressed(binds["Place"]) then
			copy_pos_b = nil
		elseif InputPressed(binds["Mine"]) then
			clipboard.blocks = {}
			load_into_schematic(copy_pos_a, copy_pos_b, clipboard.blocks)
			copy_pos_a = nil
			copy_pos_b = nil
			selected_schematic = clipboard
			currentSchematicState = SCHEMATIC_STATE.PASTING
		end
	end
end

local function update_paste(hitpoint)
	render_schematic(hitpoint, selected_schematic.blocks)
	
	if InputPressed(binds["Mine"]) then
		place_schematic(hitpoint, selected_schematic.blocks)
		currentSchematicState = SCHEMATIC_STATE.IDLE
	elseif InputPressed(binds["Place"]) then
		currentSchematicState = SCHEMATIC_STATE.IDLE
	end
end

function schematics_update(hitpoint)
	DebugWatch("state", currentSchematicState)

	if currentSchematicState == SCHEMATIC_STATE.COPYING then
		update_copy(hitpoint)
	elseif currentSchematicState == SCHEMATIC_STATE.PASTING then
		update_paste(hitpoint, selected_schematic)
	end
end

function schematics_start_copy()
	currentSchematicState = SCHEMATIC_STATE.COPYING
end

local function FindAndDeleteAtPos(pos)
	pos = getGridAlignedPos(pos)
	local toRemove = FindBlocksAt(Transform(pos), Vec(0, 0.2, 0))
	
	if toRemove ~= nil and #toRemove > 1 then
		RemoveBlock(toRemove[1])
	end
end

function BuildPortal(hitpoint)
	for i = 1, 3 do 
		local bottomBlockPos = VecAdd(hitpoint, Vec(i * 1.6, 0, 0))
		local topBlockPos = VecAdd(hitpoint, Vec(i * 1.6, 1.6 * 4, 0))
		local leftBlockPos = VecAdd(hitpoint, Vec(0, 1.6 * i, 0))
		local rightBlockPos = VecAdd(hitpoint, Vec(1.6 * 4, 1.6 * i, 0))
		
		--[[FindAndDeleteAtPos(bottomBlockPos)
		FindAndDeleteAtPos(topBlockPos)
		FindAndDeleteAtPos(leftBlockPos)
		FindAndDeleteAtPos(rightBlockPos)]]--
		
		PlaceBlock("Obsidian", bottomBlockPos)
		PlaceBlock("Obsidian", topBlockPos)
		
		PlaceBlock("Obsidian", leftBlockPos)
		PlaceBlock("Obsidian", rightBlockPos)
	end
end