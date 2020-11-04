if not (GetThemePref("VisualTheme") == "Macro") then
	-- normal SL behavior for non-Macro style; does not show animated background in non-Rainbow song select
	if not ThemePrefs.Get("RainbowMode") then return Def.Actor{ InitCommand=function(self) self:visible(false) end } end

	return Def.ActorFrame{
		Def.Quad{
			InitCommand=function(self) self:FullScreen():Center():diffuse( Color.White ) end
		},

		LoadActor( THEME:GetPathB("", "_shared background") ),

		Def.Quad{
			InitCommand=function(self)
				self:diffuse(Color.White):Center():FullScreen()
					:sleep(0.6):linear(0.5):diffusealpha(0)
					:queuecommand("Hide")
			end,
			HideCommand=function(self) self:visible(false) end
		}

	}
else
	-- Macro style shows animated background during song select
	-- and has no white-flash effect going into song select for non-Rainbow Mode
	return Def.ActorFrame{
		Def.Quad{
			InitCommand=function(self) self:FullScreen():Center():diffuse( Color.White ) end
		},

		LoadActor( THEME:GetPathB("", "_shared background") )
	}
end
