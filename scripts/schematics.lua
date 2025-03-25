local box_test = { name = "Box Test", size = {5, 5, 5},
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

local clipboard = {name = "Clipboard", size = {0,0,0}, blocks = {{{}}}}

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
	local schematic_blocks = schematic.blocks
	local playerTf = GetPlayerTransform()
	
	hitpoint[2] = hitpoint[2] + math.ceil(schematic.size[2] / 2)
	
	--spawnDebugParticle(hitpoint, .25, Color4.Red)
	--spawnDebugParticle(VecAdd(hitpoint, schematic.size), .25, Color4.Green)
	
	--DebugPrint(#schematic)
	
	for x = 1, #schematic_blocks do
		for y = 1, #schematic_blocks[x] do
			for z = 1, #schematic_blocks[x][y] do
				if schematic_blocks[x][y][z] ~= nil then
					local blockPos = VecAdd(hitpoint, Vec(x * 1.6 - 0.8, y * 1.6 - 0.8, z * 1.6 - 0.8))
					
					blockPos[1] = blockPos[1] - blockPos[1] % 1.6 + 0.8
					blockPos[2] = blockPos[2] - blockPos[2] % 1.6 + 0.8
					blockPos[3] = blockPos[3] - blockPos[3] % 1.6 + 0.8
					
					spawnDebugParticle(blockPos, .25, Color4.Red)
					
					local lookAtPlayer = QuatLookAt(blockPos, playerTf.pos)
					DrawSprite(blockSprites[schematic_blocks[x][y][z]], Transform(blockPos, lookAtPlayer), 1.6, 1.6, 1, 1 ,1 ,1, true, false, false)
				end
			end
		end
	end
end

local function place_schematic(hitpoint, schematic)
	local schematic_blocks = schematic.blocks
	
	hitpoint[2] = hitpoint[2] + math.ceil(schematic.size[2] / 2) - 1.6
	
	for x = 1, #schematic_blocks do
		for y = 1, #schematic_blocks[x] do
			for z = 1, #schematic_blocks[x][y] do
				if schematic_blocks[x][y][z] ~= nil then
					local blockPos = VecAdd(hitpoint, Vec(x * 1.6 - 0.8, y * 1.6 - 0.8, z * 1.6 - 0.8))
					
					blockPos[1] = blockPos[1] - blockPos[1] % 1.6 + 0.8
					blockPos[2] = blockPos[2] - blockPos[2] % 1.6 + 0.8
					blockPos[3] = blockPos[3] - blockPos[3] % 1.6 + 0.8
					
					spawnDebugParticle(blockPos, 5.25, Color4.Yellow)
					
					PlaceBlock(schematic_blocks[x][y][z], blockPos)
				end
			end
		end
	end
end

local function GetPositionStepsForArray(a, b)

	a = round(a)
	b = round(b)
	
	if a < 0 then
		b = (b - a)
		
		if b == 0 then
			--zero distance, still needs to be the same as a.
			b = 1
		end
		
		a = 1
	elseif a == 0 then
		b = b + 1
		a = 1
	end
	
	return a, b
end

local function load_into_schematic(a, b, schematic_blocks, schematic_size)
	local lowestX, highestX = GetPositionStepsForArray(a[1], b[1])
	local lowestY, highestY = GetPositionStepsForArray(a[2], b[2])
	local lowestZ, highestZ = GetPositionStepsForArray(a[3], b[3])
	
	schematic_size[1] = math.abs(math.ceil(highestX / lowestX))
	schematic_size[2] = math.abs(math.ceil(highestY / lowestY))
	schematic_size[3] = math.abs(math.ceil(highestZ / lowestZ))
	
	DebugPrint("--")
	DebugPrint(lowestX .. ", ".. highestX)
	--DebugPrint(lowestY .. ", ".. highestY)
	--DebugPrint(lowestZ .. ", ".. highestZ)
	
	--TODO: Fix pos growing exponetially
	
	for x = lowestX, highestX do
		schematic_blocks[x] = {}
		local posX = a[1] + (x - 1) * 1.6
		for y = lowestY, highestY do
			local posY = a[2] + (y - 1) * 1.6
			schematic_blocks[x][y] = {}
			for z = lowestZ, highestZ do
				local posZ = a[3] + (z - 1) * 1.6
				spawnDebugParticle(Vec(posX, posY, posZ), 2, Color4.Green)
				local blocks = FindBlocksAt(Transform(Vec(posX, posY, posZ)), Vec(0, 0, 0))
				
				if #blocks > 0 then
					--DebugPrint(GetTagValue(blocks[1], "minecraftblockid"))
					schematic_blocks[x][y][z] = GetTagValue(blocks[1], "minecraftblockid")
					--DrawShapeHighlight(blocks[1], 1)
				else
					schematic_blocks[x][y][z] = nil
				end
			end
		end
	end

	--[[--TODO: make sure a < b
	for x = a[1] - 1.6, b[1] + 1.6, 1.6 do
		local tableX = math.abs(math.floor(x / 1.6))
		schematic_blocks[tableX] = {}
		for y = a[2] - 1.6, b[2] + 1.6, 1.6 do
			local tableY = math.abs(math.floor(y / 1.6))
			schematic_blocks[tableX][tableY] = {}
			for z = a[3] - 1.6, b[3] + 1.6, 1.6 do
				local tableZ = math.abs(math.floor(z / 1.6))
				DebugPrint(VecToString(Vec(tableX,tableY,tableZ)))
				local blocks = FindBlocksAt(Transform(Vec(x, y, z)), Vec(0, 0, 0))
				
				if #blocks > 0 then
					schematic_blocks[tableX][tableY][tableZ] = GetTagValue(blocks[1], "minecraftblockid")
				end
			end
		end
	end
	
	schematic_size[1] = math.abs(math.floor(b[1] / a[1]))
	schematic_size[2] = math.abs(math.floor(b[2] / a[2]))
	schematic_size[3] = math.abs(math.floor(b[3] / a[3]))]]--
	
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
		renderAabbZone(VecAdd(blockPos, Vec(-0.8, -0.8, -0.8)), VecAdd(blockPos, Vec(0.8, 0.8, 0.8)), 1, 1, 0, 0.25, true)
		if InputPressed(binds["Place"]) then
			currentSchematicState = SCHEMATIC_STATE.IDLE
		elseif InputPressed(binds["Mine"]) then
			copy_pos_a = VecCopy(blockPos)
		end
	elseif copy_pos_b == nil then
		renderAabbZone(VecAdd(copy_pos_a, Vec(-0.8, -0.8, -0.8)), VecAdd(blockPos, Vec(0.8, 0.8, 0.8)), 1, 1, 0, 0.25, true)
		if InputPressed(binds["Place"]) then
			copy_pos_a = nil
		elseif InputPressed(binds["Mine"]) then
			copy_pos_b = VecCopy(blockPos)
		end
	else
		renderAabbZone(VecAdd(copy_pos_a, Vec(-0.8, -0.8, -0.8)), VecAdd(copy_pos_b, Vec(0.8, 0.8, 0.8)), 1, 1, 0, 0.25, true)
		--load_into_schematic(copy_pos_a, copy_pos_b, clipboard.blocks, clipboard.size)
		if InputPressed(binds["Place"]) then
			copy_pos_b = nil
		elseif InputPressed(binds["Mine"]) then
			clipboard.blocks = {}
			clipboard.size = {0, 0, 0}
			load_into_schematic(copy_pos_a, copy_pos_b, clipboard.blocks, clipboard.size)
			copy_pos_a = nil
			copy_pos_b = nil
			selected_schematic = clipboard
			currentSchematicState = SCHEMATIC_STATE.PASTING
		end
	end
end

local function update_paste(hitpoint)
	render_schematic(hitpoint, selected_schematic)
	
	if InputPressed(binds["Mine"]) then
		place_schematic(hitpoint, selected_schematic)
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