#include "datascripts/color4.lua"

function getMaxTextSize(text, fontSize, maxSize, minFontSize)
	minFontSize = minFontSize or 1
	UiPush()
		UiFont("regular.ttf", fontSize)
		
		local currentSize = UiGetTextSize(text)
		
		while currentSize > maxSize and fontSize > minFontSize do
			fontSize = fontSize - 0.1
			UiFont("regular.ttf", fontSize)
			currentSize = UiGetTextSize(text)
		end
	UiPop()
	return fontSize, fontSize > minFontSize
end


function c_UiColor(color4)
	UiColor(color4.r, color4.g, color4.b, color4.a)
end

function c_UiColorFilter(color4)
	UiColorFilter(color4.r, color4.g, color4.b, color4.a)
end

function c_UiTextOutline(color4, thickness)
	thickness = thickness or 0.1
	
	UiTextOutline(color4.r, color4.g, color4.b, color4.a, thickness)
end

function c_UiTextShadow(color4, distance, blur)
	distance = distance or 1.0
	blur = blur or 0.5
	
	UiTextShadow(color4.r, color4.g, color4.b, color4.a, distance, blur)
end

function c_UiButtonImageBox(path, borderWidth, borderHeight, color4)
	color4 = color4 or Color4.White
	
	UiButtonImageBox(path, borderWidth, borderHeight, color4.r, color4.g, color4.b, color4.a)
end

function c_UiButtonHoverColor(color4)
	UiButtonHoverColor(color4.r, color4.g, color4.b, color4.a)
end

function c_UiButtonPressColor(color4)
	UiButtonPressColor(color4.r, color4.g, color4.b, color4.a)
end

function drawToggle(label, value, callback, buttonWidth, buttonHeight)
	local enabledText = "Enabled"
	local disabledText = "Disabled"
	
	local fullLabel = label .. " " .. (value and enabledText or disabledText)
	
	local fontSize = getMaxTextSize(fullLabel, 26, buttonWidth, 15)
	
	buttonWidth = buttonWidth or 250
	buttonHeight = buttonHeight or 40
	
	local mouseInRect = false

	UiPush()
		UiButtonImageBox("MOD/sprites/square.png", 6, 6, 0, 0, 0, 0.5)
		UiFont("regular.ttf", fontSize)
		
		if UiTextButton(fullLabel, buttonWidth, buttonHeight) then
			callback(not value)
		end
		
		UiAlign("top left")
		UiTranslate(-buttonWidth / 2, -buttonHeight / 2)
		mouseInRect = UiIsMouseInRect(buttonWidth, buttonHeight)
	UiPop()
	
	return mouseInRect
end

function drawToggleBox(value, callback)
	local mouseInRect = false

	UiPush()
		local image = "ui/common/box-outline-6.png"
		
		if UiImageButton(image, 120, 120) then
			callback(not value)
		end
		
		if value then
			UiPush()
				UiColorFilter(0, 1, 0)
				UiImageBox("ui/terminal/checkmark.png", 25, 25, 0, 0)
			UiPop()
		end
		
		UiAlign("top left")
		UiTranslate(-60, -60)
		mouseInRect = UiIsMouseInRect(120, 120)
	UiPop()
	
	return mouseInRect
end

function drawStatusBox(label, status)
	UiPush()
		local boxYOffset = 2
		UiAlign("right middle")
		UiTranslate(0, boxYOffset)
		UiPush()
			if status then
				c_UiColor(Color4.Green)
			else
				c_UiColor(Color4.Red)
			end
			UiImageBox("ui/common/dot.png", 23, 23)
		UiPop()
		UiTranslate(0, -boxYOffset)
		UiAlign("left middle")
		UiText(label)
	UiPop()
end

function c_DrawBodyOutline(handle, color4)
	DrawBodyOutline(handle, color4.r, color4.g, color4.b, color4.a)
end

function c_DrawShapeOutline(handle, color4)
	DrawShapeOutline(handle, color4.r, color4.g, color4.b, color4.a)
end

function c_DebugCross(pos, color4)
	DebugCross(pos, color4.r, color4.g, color4.b, color4.a)
end

function c_DrawLine(a, b, color4)
	DrawLine(a, b, color4.r, color4.g, color4.b, color4.a)
end

function c_DebugLine(a, b, color4)
	DebugLine(a, b, color4.r, color4.g, color4.b, color4.a)
end

function selectionBox(index, keys, triggerChange, optionWidth, margin, maxIndex, displayKey)
	local currentSettingIndex = index
	
	triggerChange = triggerChange or true
	
	optionWidth = optionWidth or 175
	margin = margin or 10
	
	maxIndex = maxIndex or #keys
	
	local mouseInRect = false
	
	UiPush()
		UiFont("regular.ttf", 26)
		UiAlign("center middle")
		
		UiPush()
			UiColorFilter(0, 0, 0, 0.5)
			UiImageBox("MOD/sprites/square.png", optionWidth, 40, 6, 6)
			
			UiAlign("top left")
			UiTranslate(-optionWidth / 2, -20)
			mouseInRect = UiIsMouseInRect(optionWidth, 40)
		UiPop()
		
		UiPush()
			UiAlign("left middle")
			UiTranslate(-optionWidth / 2 + margin, 0)
			if UiImageButton("MOD/sprites/arrow-left.png", 60, 60) then
				currentSettingIndex = currentSettingIndex - 1
				if triggerChange then
					hasAValueBeenChanged = true
				end
				
				if currentSettingIndex < 1 then
					currentSettingIndex = maxIndex
				end
			end
		UiPop()
		
		if displayKey ~= nil then
			UiText(keys[currentSettingIndex][displayKey])
		else
			UiText(keys[currentSettingIndex])
		end
		
		UiPush()
			UiAlign("right middle")
			UiTranslate(optionWidth / 2 - margin, 0)
			if UiImageButton("MOD/sprites/arrow-right.png", 60, 60)	then
				currentSettingIndex = currentSettingIndex + 1
				if triggerChange then
					hasAValueBeenChanged = true
				end
				
				if currentSettingIndex > maxIndex then
					currentSettingIndex = 1
				end
			end
		UiPop()
	UiPop()
	
	return currentSettingIndex, mouseInRect
end