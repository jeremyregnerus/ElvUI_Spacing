local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD") -- This ensures the UI is fully loaded

local function AdjustButtonSpacing()
    if not ElvUI then
        print("|cffff0000[CustomSpacing]: ElvUI not found!|r")
        return
    end

    local E, L, V, P, G = unpack(ElvUI)
    local AB = E:GetModule("ActionBars", true)

    if not AB then
        print("|cffff0000[CustomSpacing]: ActionBars module not found!|r")
        return
    end

    print("|cff00ff00[CustomSpacing]: Adjusting button spacing...|r")

    local function GetButtonSize(barIndex)
		return E.db and E.db.actionbar["bar" .. barIndex] and E.db.actionbar["bar" .. barIndex].buttonWidth or 36
    end

    local function GetButtonPadding(barIndex)
        return E.db and E.db.actionbar["bar" .. barIndex] and E.db.actionbar["bar" .. barIndex].buttonSpacing or 0
    end
	
	local function GetActualButtonSize(barIndex)
        local button = _G["ElvUI_Bar" .. barIndex .. "Button1"]
        return button and button:GetWidth() or 36
	end
	
	local function GetHorizontalDistance(button1, button2)
		if not button1 or not button2 then return nil end

		local left1 = select(1, button1:GetRect())
		local left2 = select(1, button2:GetRect())

		if left1 and left2 then
			local distance = math.abs(left2 - left1)
			return distance
		end
	end
	
	local function GetActualButtonPadding(barIndex)
		local b1 = _G["ElvUI_Bar" .. barIndex .. "Button1"]
		local b2 = _G["ElvUI_Bar" .. barIndex .. "Button2"]
			
		return GetHorizontalDistance(b1, b2) - GetActualButtonSize(1)
	end

	-- Adjust Action Bar 1
    if _G["ElvUI_Bar1"] then
	    local buttonWidth = GetActualButtonSize(1)
        local padding = GetActualButtonPadding(1)
			
		-- change the potion of button8 (Q) to be on a new row and offset half a button the right of button2 (1)
		local button2 = _G["ElvUI_Bar1Button2"]
		local button8 = _G["ElvUI_Bar1Button8"]
		
		if button2 and button8 then
			button8:ClearAllPoints()
			button8:SetPoint("TOPLEFT", button2, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
		
		-- add a space for the missing button (E) between button9 & button10
		local button9 = _G["ElvUI_Bar1Button9"]
        local button10 = _G["ElvUI_Bar1Button10"]

        if button9 and button10 then
            button10:ClearAllPoints()
            button10:SetPoint("LEFT", button9, "RIGHT", buttonWidth + padding, 0)
        end
    end

    -- Adjust spacing for Action Bar 2
    if _G["ElvUI_Bar2"] then
        local buttonWidth = GetActualButtonSize(2)
        local padding = GetActualButtonPadding(2)
		
		-- lock Bar2 button1 to Action Bar 1
		local button1 = _G["ElvUI_Bar2Button1"]
		local bar1Button8 = _G["ElvUI_Bar1Button8"]
		
		if button1 and bar1Button8 then
			button1:ClearAllPoints()
			button1:SetPoint("TOPLEFT", bar1Button8, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
		
		-- add a 3 button space between button1 & button2
        local button2 = _G["ElvUI_Bar2Button2"]

        if button1 and button2 then
            button2:ClearAllPoints()
            button2:SetPoint("LEFT", button1, "RIGHT", (buttonWidth + padding) * 3, 0)
        end
		
		-- create a second row, and locate Z to A half a button right
		local button4 = _G["ElvUI_Bar2Button4"]
		
		if button1 and button4 then
			button4:ClearAllPoints()
			button4:SetPoint("TOPLEFT", button1, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
    end
	
	-- Adjust Action Bar 3
    if _G["ElvUI_Bar3"] then
	    local buttonWidth = GetActualButtonSize(3)
        local padding = GetActualButtonPadding(3)
		
		-- lock the action bar to action bar 1
		local bar1Button7 = _G["ElvUI_Bar1Button7"]
		local button1 = _G["ElvUI_Bar3Button1"]
		
		if button1 and bar1Button7 then
			button1:ClearAllPoints()
			button1:SetPoint("LEFT", bar1Button7, "RIGHT", (buttonWidth + padding) * 1, 0)
		end
			
		-- change the potion of button8 (Q) to be on a new row and offset half a button the right of button2 (1)
		local button1 = _G["ElvUI_Bar3Button1"]
		local button7 = _G["ElvUI_Bar3Button7"]
		
		if button1 and button7 then
			button7:ClearAllPoints()
			button7:SetPoint("TOPLEFT", button1, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
		
		-- add a space for the missing button (E) between button9 & button10
		local button8 = _G["ElvUI_Bar3Button8"]
        local button9 = _G["ElvUI_Bar3Button9"]

        if button8 and button9 then
            button9:ClearAllPoints()
            button9:SetPoint("LEFT", button8, "RIGHT", buttonWidth + padding, 0)
        end
    end
	
    -- Adjust spacing for Action Bar 4
    if _G["ElvUI_Bar4"] then
        local buttonWidth = GetActualButtonSize(4)
        local padding = GetActualButtonPadding(4)
		
		-- lock Bar2 button1 to Action Bar 1
		local button1 = _G["ElvUI_Bar4Button1"]
		local bar3Button7 = _G["ElvUI_Bar3Button7"]
		
		if button1 and bar3Button7 then
			button1:ClearAllPoints()
			button1:SetPoint("TOPLEFT", bar3Button7, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
		
		-- add a 3 button space between button1 & button2
        local button2 = _G["ElvUI_Bar4Button2"]

        if button1 and button2 then
            button2:ClearAllPoints()
            button2:SetPoint("LEFT", button1, "RIGHT", (buttonWidth + padding) * 3, 0)
        end
		
		-- create a second row, and locate Z to A half a button right
		local button4 = _G["ElvUI_Bar4Button4"]
		
		if button1 and button4 then
			button4:ClearAllPoints()
			button4:SetPoint("TOPLEFT", button1, "BOTTOMLEFT", (buttonWidth / 2) + padding, -padding)
		end
    end
	
	-- Adjust the location of the stance bar
	if _G["ElvUI_StanceBar"] then
		local buttonWidth = GetButtonSize(1)
		local padding = GetButtonPadding(1)
		local stance1 = _G["ElvUI_StanceBarButton1"]
		local button1 = _G["ElvUI_Bar1Button2"]
		
		if stance1 and button1 then
			stance1:ClearAllPoints()
			stance1:SetPoint("BOTTOMLEFT", button1, "TOPLEFT", (buttonWidth / 2) + padding, padding)
		end
	end
end

-- Hook into ElvUI's settings update system
local function HookElvUI()
    if not ElvUI then return end
    local E = unpack(ElvUI)
    
    if not E then return end

    -- Hook into ElvUI's action bar updates
    if E.ActionBars then
		print("|cff00ff00Hooking Secure Function|r")
		
        hooksecurefunc(E, "UpdateActionBars", function()
            print("|cff00ff00ElvUI settings changed! Updating spacing...|r")
            AdjustButtonSpacing()
        end)
    end
end

local function OnEvent(self, event, addon)
	print("|cff00ff00[Event]: " .. event .. "|r")
	
    if event == "ADDON_LOADED" then
        print("|cff00ff00Addon Loaded: " .. addon .. "|r")
		
		if addon == "ElvUI" then
			print("|cff00ff00ElvUI detected, waiting for full load...|r")
			HookElvUI()
		end
    elseif event == "PLAYER_ENTERING_WORLD" then
        print("|cff00ff00World loaded!...|r")
        C_Timer.After(2, AdjustButtonSpacing) -- Add delay to ensure everything is loaded
		HookElvUI()
    end
end

frame:SetScript("OnEvent", OnEvent)
