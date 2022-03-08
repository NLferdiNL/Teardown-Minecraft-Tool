function GetValue(name)
	if savedVars[name] == nil then
		DebugPrint(toolReadableName.. " Get Error: " .. name .. " value not found!")
		return
	end
	
	return savedVars[name].current
end

function SetValue(name, value)
	if savedVars[name] == nil then
		DebugPrint(toolReadableName.. " Set Error: " .. name .. " value not found!")
		return
	end
	
	savedVars[name].current = value
end

function ResetValueToDefault(name)
	if savedVars[name] == nil then
		DebugPrint(toolReadableName.. " Reset Error: " .. name .. " value not found!")
		return
	end
	
	savedVars[name].current = savedVars[name].default
end

function ResetValuesToDefault()
	for varName, varData in pairs(savedVars) do
		ResetValueToDefault(varName)
	end
end