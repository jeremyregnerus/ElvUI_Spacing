local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD") -- This ensures the UI is fully loaded

local function CreateBackdrops(padding)
	local backdropAnchors = {
		{"ElvUI_Bar2Button9", "ElvUI_Bar2Button12"},
		{"ElvUI_Bar1Button1", "ElvUI_Bar1Button7"},
		{"ElvUI_Bar1Button8", "ElvUI_Bar1Button12"},
		{"ElvUI_Bar2Button1", "ElvUI_Bar2Button3"},
		{"ElvUI_Bar2Button4", "ElvUI_Bar2Button8"},
		{"ElvUI_Bar4Button9", "ElvUI_Bar4Button12"},
		{"ElvUI_Bar3Button1", "ElvUI_Bar3Button6"},
		{"ElvUI_Bar3Button7", "ElvUI_Bar3Button11"},
		{"ElvUI_Bar4Button1", "ElvUI_Bar4Button3"},
		{"ElvUI_Bar4Button4", "ElvUI_Bar4Button8"}
		--{"ElvUI_Bar5Button1", "ElvUI_Bar5Button12"}
	}
	
	local function CreateBackdrop(anchor, padding)
	
		padding = padding / 2
	
		local panel = CreateFrame("Frame", "Backdrop" .. anchor[1] .. anchor[2], UIParent, "BackdropTemplate")
		panel:SetFrameStrata("BACKGROUND")
		panel:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = nil,
            tile = false, tileSize = 0, edgeSize = 0,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
		panel:SetBackdropColor(.10196, .10196, .10196, 1)
		panel:SetBackdropBorderColor(0, 0, 0, 0)
		
		panel:ClearAllPoints()
		panel:SetPoint("TOPLEFT", _G[anchor[1]], "TOPLEFT", -padding, padding)
		panel:SetPoint("BOTTOMRIGHT", _G[anchor[2]], "BOTTOMRIGHT", padding, -padding)
		panel:SetFrameLevel(100)
	
		local edge = CreateFrame("Frame", "Edge" .. anchor[1] .. anchor[2], UIParent, "BackdropTemplate")
		edge:SetFrameStrata("BACKGROUND")
        edge:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = nil,
            tile = false, tileSize = 0, edgeSize = 0,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        edge:SetBackdropColor(0, 0, 0, 1)

        edge:ClearAllPoints()
        edge:SetPoint("TOPLEFT", panel, "TOPLEFT", -.5, .5)
        edge:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", .5, -.5)
		edge:SetFrameLevel(0)
	end
	
	for i, anchor in pairs(backdropAnchors) do
		CreateBackdrop(anchor, padding)
	end
end

local function AnchorButton(buttonToMove, anchorFrom, buttonAnchor, anchorTo, horizontalSpacing, verticalSpacing)
	buttonToMove:ClearAllPoints()
	buttonToMove:SetPoint(anchorFrom, buttonAnchor, anchorTo, horizontalSpacing, verticalSpacing)
end

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

    local function GetButtonSizeSetting()
		return E.db and E.db.actionbar["bar1"] and E.db.actionbar["bar1"].buttonWidth or 36
    end

    local function GetButtonPaddingSetting()
        return E.db and E.db.actionbar["bar1"] and E.db.actionbar["bar1"].buttonSpacing or 0
    end
	
	local function GetHorizontalDistance(button1, button2)
		if not button1 or not button2 then return nil end

		local left1 = select(1, button1:GetRect())
		local left2 = select(1, button2:GetRect())
		
		return math.abs(left2 - left1)
	end
	
	local function GetButtonSize()
		return _G["ElvUI_Bar1Button1"]:GetWidth()
	end
	
	local function GetButtonPadding()
		local b1 = _G["ElvUI_Bar1Button1"]
		local b2 = _G["ElvUI_Bar1Button2"]
			
		return GetHorizontalDistance(b1, b2) - GetButtonSize(1)
	end

	local width = GetButtonSize()
	local padding = GetButtonPadding()
	
	--print("|cffff0000Width: " .. GetButtonSize() .. " | Setting: " .. GetButtonSizeSetting() .. "|r")
	--print("|cffff0000Padding: " .. GetButtonPadding() .. " | Setting: " .. GetButtonPaddingSetting() .. "|r")
	
	-- create the Q row by anchoring Q to 1
	AnchorButton(_G["ElvUI_Bar1Button8"], "TOPLEFT", _G["ElvUI_Bar1Button2"], "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- add a 1 button space between W & R
	AnchorButton(_G["ElvUI_Bar1Button10"], "LEFT", _G["ElvUI_Bar1Button9"], "RIGHT", width + padding, 0)
	
	-- create the A row by anchoring A to Q
	AnchorButton(_G["ElvUI_Bar2Button1"], "TOPLEFT", _G["ElvUI_Bar1Button8"], "BOTTOMLEFT", (width / 2) + padding, -padding)

	-- add a 3 button space between A & G
	AnchorButton(_G["ElvUI_Bar2Button2"], "LEFT", _G["ElvUI_Bar2Button1"], "RIGHT", (width + padding) * 3, 0)
	
	-- create the Z row by anchoring Z to A
	AnchorButton(_G["ElvUI_Bar2Button4"], "TOPLEFT", _G["ElvUI_Bar2Button1"], "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- create the second keyboard layout (shift modifiers) by anchoring S1 to 6
	AnchorButton(_G["ElvUI_Bar3Button1"], "LEFT", _G["ElvUI_Bar1Button7"], "RIGHT", (width + padding) * 1, 0)
		
	-- create the SQ row by anchoring SQ to S1
	AnchorButton(_G["ElvUI_Bar3Button7"], "TOPLEFT", _G["ElvUI_Bar3Button1"], "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- add a 1 button space between SW & SR
	AnchorButton(_G["ElvUI_Bar3Button9"], "LEFT", _G["ElvUI_Bar3Button8"], "RIGHT", width + padding, 0)
	
    -- create the SA row by anchoring SA to SQ
	AnchorButton(_G["ElvUI_Bar4Button1"], "TOPLEFT", _G["ElvUI_Bar3Button7"], "BOTTOMLEFT", (width / 2) + padding, -padding)

	-- add a 3 button space between SA & SG
	AnchorButton(_G["ElvUI_Bar4Button2"], "LEFT", _G["ElvUI_Bar4Button1"], "RIGHT", (width + padding) * 3, 0)
		
	-- create the SZ row by anchoring SZ to SA
	AnchorButton(_G["ElvUI_Bar4Button4"], "TOPLEFT", _G["ElvUI_Bar4Button1"], "BOTTOMLEFT", (width / 2) + padding, -padding)
	
	-- Adjust the location of the stance bar
	--AnchorButton(_G["ElvUI_StanceBarButton1"], "BOTTOMLEFT", _G["ElvUI_Bar1Button2"], "TOPLEFT", (width / 2) + padding, padding)
	
	-- add the F1 - F4 keys using the remaining 4 keys from Action Bar 2
	AnchorButton(_G["ElvUI_Bar2Button9"], "BOTTOMLEFT", _G["ElvUI_Bar1Button2"], "TOPLEFT", (width / 2) + padding, padding)
	
	-- add the F5 - F8 buttons using the remaining 4 keys from Action Bar 4
	AnchorButton(_G["ElvUI_Bar4Button9"], "BOTTOMLEFT", _G["ElvUI_Bar1Button7"], "TOPLEFT", (width / 2) + padding, padding)
	
	-- anchor bar 13 to the number row
	AnchorButton(_G["ElvUI_Bar5Button1"], "LEFT", _G["ElvUI_Bar3Button6"], "RIGHT", (width + padding) * 2, 0)
	
	CreateBackdrops(padding)
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
