-- --------------------------------------------------------
-- non-RainbowMode (normal) background

local file = ...

-- variables for Macro style adjustments
local strobescreens = {"ScreenAfterSelectProfile","ScreenSelectPlayMode","ScreenSelectPlayMode2","ScreenSelectStyle","ScreenSelectColor"}
local delay = 0.214285 -- (60 seconds/140 bpm)/2 = seconds per half-beat at 140bpm
local counter = 1
local speedswitch = false

local anim_data = {
	color_add = {0,1,1,0,0,0,1,1,1,1},
	diffusealpha = {0.05,0.2,0.1,0.1,0.1,0.1,0.1,0.05,0.1,0.1},
	xy = {0,40,80,120,200,280,360,400,480,560},
	texcoordvelocity = {{0.03,0.01},{0.03,0.02},{0.03,0.01},{0.02,0.02},{0.03,0.03},{0.02,0.02},{0.03,0.01},{-0.03,0.01},{0.05,0.03},{0.03,0.04}}
}

local t = Def.ActorFrame {
	InitCommand=function(self)
		self:visible(not ThemePrefs.Get("RainbowMode"))
	end,
	OnCommand=function(self) self:accelerate(0.8):diffusealpha(1):queuecommand("Loop") end,
	HideCommand=function(self) self:visible(false) end,

	BackgroundImageChangedMessageCommand=function(self)
		if not ThemePrefs.Get("RainbowMode") then
			self:visible(true):linear(0.6):diffusealpha(1)

			local new_file = THEME:GetPathG("", "_VisualStyles/" .. ThemePrefs.Get("VisualTheme") .. "/SharedBackground.png")
			self:RunCommandsOnChildren(function(child) child:Load(new_file) end)
		else
			self:linear(0.6):diffusealpha(0):queuecommand("Hide")
		end
	end,

	-- Macro loop command
	LoopCommand=function(self)
		if (GetThemePref("VisualTheme") == "Macro") and (FindInTable(SCREENMAN:GetTopScreen():GetName(), strobescreens)) then
			speedswitch = true
			if counter == 0 then counter = 1 else counter = 0 end
		else
			speedswitch = false
		end
		self:queuecommand("UpdateSpeed"):sleep(delay):queuecommand("Loop")
	end


}

for i=1,10 do
	t[#t+1] = Def.Sprite {
		Texture=file,
		InitCommand=function(self)
			self:diffuse(GetHexColor(SL.Global.ActiveColorIndex+anim_data.color_add[i], true))
		end,
		OnCommand=function(self)
			self:zoom(1.3):xy(anim_data.xy[i], anim_data.xy[i])
			:customtexturerect(0,0,1,1):texcoordvelocity(anim_data.texcoordvelocity[i][1], anim_data.texcoordvelocity[i][2])
			:diffusealpha(anim_data.diffusealpha[i])
		end,

		ColorSelectedMessageCommand=function(self)
			self:linear(0.5)
			:diffuse(GetHexColor(SL.Global.ActiveColorIndex+anim_data.color_add[i], true))
			:diffusealpha(anim_data.diffusealpha[i])
		end,

		-- Macro update command
		UpdateSpeedCommand=function(self)
			if ((speedswitch == true) and (counter == 0)) then
				self:texcoordvelocity(anim_data.texcoordvelocity[i][1] * 6, anim_data.texcoordvelocity[i][2] * 6)
			else
				self:texcoordvelocity(anim_data.texcoordvelocity[i][1], anim_data.texcoordvelocity[i][2])
			end
		end

	}
end

return t
