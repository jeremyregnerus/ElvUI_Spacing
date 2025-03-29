local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD") -- This ensures the UI is fully loaded

local function AdjustSpacing()
    if not ElvUI then
        print("|cffff0000ElvUI not found!|r")
        return
    end

    local E, L, V, P, G = unpack(ElvUI)
    local AB = E:GetModule("ActionBars", true)

    if not AB then
        print("|cffff0000ActionBars module not found!|r")
        return
    end

    print("|cff00ff00Adjusting button spacing...|r")

    local function GetButtonSizeSetting(barIndex)
		return E.db and E.db.actionbar["bar" .. barIndex] and E.db.actionbar["bar" .. barIndex].buttonWidth or 36
    end

    local function GetButtonPaddingSetting(barIndex)
        return E.db and E.db.actionbar["bar" .. barIndex] and E.db.actionbar["bar" .. barIndex].buttonSpacing or 0
    end
	
	local function GetHorizontalDistance(button1, button2)
		if not button1 or not button2 then return nil end

		local left1 = select(1, button1:GetRect())
		local left2 = select(1, button2:GetRect())
		
		return math.abs(left2 - left1)
	end
	
	local function GetButtonSize(barIndex)
		return _G["ElvUI_Bar" .. barIndex .. "Button1"]:GetWidth()
	end
	
	local function GetButtonPadding(barIndex)
		local b1 = _G["ElvUI_Bar" .. barIndex .. "Button1"]
		local b2 = _G["ElvUI_Bar" .. barIndex .. "Button2"]
			
		return GetHorizontalDistance(b1, b2) - GetButtonSize(1)
	end

	local width = GetButtonSize(1)
	local padding = GetButtonPadding(1)
	
	-- create the Q row of keys
	local buttonQ = _G["ElvUI_Bar1Button8"]
	local buttonQAnchor = _G["ElvUI_Bar1Button2"]
	
	buttonQ:ClearAllPoints()
	buttonQ:SetPoint("TOPLEFT", buttonQAnchor, "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- add a 1 button space between W & R
	local buttonW = _G["ElvUI_Bar1Button9"]
	local buttonR = _G["ElvUI_Bar1Button10"]
	
	buttonR:ClearAllPoints()
	buttonR:SetPoint("LEFT", buttonW, "RIGHT", width + padding, 0)
	
	-- lock Action Bar 2 to Action Bar 1 creating the A row of keys
	local buttonA = _G["ElvUI_Bar2Button1"]

	buttonA:ClearAllPoints()
	buttonA:SetPoint("TOPLEFT", buttonQ, "BOTTOMLEFT", (width / 2) + padding, -padding)

	-- add a 3 button space between A & G
	local buttonG = _G["ElvUI_Bar2Button2"]

	buttonG:ClearAllPoints()
	buttonG:SetPoint("LEFT", buttonA, "RIGHT", (width + padding) * 3, 0)
	
	-- create the Z row of Keys
	local buttonZ = _G["ElvUI_Bar2Button4"]
	
	buttonZ:ClearAllPoints()
	buttonZ:SetPoint("TOPLEFT", buttonA, "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- create the second keyboard layout (shift modifiers) starting with Action Bar 3 for the Numeric keys
	local button6 = _G["ElvUI_Bar1Button7"]
	local buttonS1 = _G["ElvUI_Bar3Button1"]

	buttonS1:ClearAllPoints()
	buttonS1:SetPoint("LEFT", button6, "RIGHT", (width + padding) * 1, 0)
		
	-- create the Q row of keys for the second keyboard layout
	local buttonSQ = _G["ElvUI_Bar3Button7"]
	
	buttonSQ:ClearAllPoints()
	buttonSQ:SetPoint("TOPLEFT", buttonS1, "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- add a 1 button gap between W & R on the second keyboard
	local buttonSW = _G["ElvUI_Bar3Button8"]
	local buttonSR = _G["ElvUI_Bar3Button9"]

	buttonSR:ClearAllPoints()
	buttonSR:SetPoint("LEFT", buttonSW, "RIGHT", width + padding, 0)
	
    -- Anchor Action Bar 4 to Action Bar 3
	local buttonSA = _G["ElvUI_Bar4Button1"]
	local buttonSQ = _G["ElvUI_Bar3Button7"]
	
	buttonSA:ClearAllPoints()
	buttonSA:SetPoint("TOPLEFT", buttonSQ, "BOTTOMLEFT", (width / 2) + padding, -padding)

	-- add a 3 button space between A & G on the second keyboard layout
	local buttonSG = _G["ElvUI_Bar4Button2"]

	buttonSG:ClearAllPoints()
	buttonSG:SetPoint("LEFT", buttonSA, "RIGHT", (width + padding) * 3, 0)
		
	-- create the Z button row on the second keyboard layout
	local buttonSZ = _G["ElvUI_Bar4Button4"]
	
	buttonSZ:ClearAllPoints()
	buttonSZ:SetPoint("TOPLEFT", buttonSA, "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- Adjust the location of the stance bar
	local stance1 = _G["ElvUI_StanceBarButton1"]
	local button1 = _G["ElvUI_Bar1Button2"]
	
	stance1:ClearAllPoints()
	stance1:SetPoint("BOTTOMLEFT", button1, "TOPLEFT", (width / 2) + padding, padding)
end

-- Hook into ElvUI's settings update system
local function HookElvUI()
    if not ElvUI then return end
    
	local E = unpack(ElvUI)
    if not E then return end
	
	local AB = E:GetModule("ActionBars")
	if not AB then return end

	hooksecurefunc(AB, "PositionAndSizeBar", function()
		AdjustSpacing()
	end)
end

local function OnEvent(self, event, addon)
    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(2, AdjustSpacing) -- Add delay to ensure everything is loaded
		HookElvUI()
    end
end

frame:SetScript("OnEvent", OnEvent)
