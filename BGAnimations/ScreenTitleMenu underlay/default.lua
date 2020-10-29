local TextColor = (ThemePrefs.Get("RainbowMode") and (not HolidayCheer()) and Color.Black) or Color.White

-- randomflip is for random song selection if Macro is set
songrandomflip = math.random(99)

-- generate a string like "7741 songs in 69 groups, 10 courses"
local SongStats = ("%i %s %i %s, %i %s"):format(
	SONGMAN:GetNumSongs(),
	THEME:GetString("ScreenTitleMenu", "songs in"),
	SONGMAN:GetNumSongGroups(),
	THEME:GetString("ScreenTitleMenu", "groups"),
	#SONGMAN:GetAllCourses(PREFSMAN:GetPreference("AutogenGroupCourses")),
	THEME:GetString("ScreenTitleMenu", "courses")
)

-- - - - - - - - - - - - - - - - - - - - -
local game = GAMESTATE:GetCurrentGame():GetName();
if game ~= "dance" and game ~= "pump" then
	game = "techno"
end

-- - - - - - - - - - - - - - - - - - - - -
-- People commonly have multiple copies of SL installed – sometimes different forks with unique features
-- sometimes due to concern that an update will cause them to lose data, sometimes accidentally, etc.

-- It is important to display the current theme's name to help users quickly assess what version of SL
-- they are using right now.  THEME:GetCurThemeName() provides the name of the theme folder from the
-- filesystem, so we'll show that.  It is guaranteed to be unique and users are likely to recognize it.
local sl_name = THEME:GetCurThemeName()

-- - - - - - - - - - - - - - - - - - - - -
-- ProductFamily() returns "StepMania"
-- ProductVersion() returns the (stringified) version number (like "5.0.12" or "5.1.0")
-- so, start with a string like "StepMania 5.0.12" or "StepMania 5.1.0"
local sm_version = ("%s %s"):format(ProductFamily(), ProductVersion())

-- GetThemeVersion() is defined in ./Scripts/SL-Helpers.lua and returns the SL version from ThemeInfo.ini
local sl_version = GetThemeVersion()

-- "git" appears in ProductVersion() for non-release builds of StepMania.
-- If a non-release executable is being used, append date information about when it
-- was built to potentially help non-technical cabinet owners submit bug reports.
if ProductVersion():find("git") then
	local date = VersionDate()
	sm_version = (sm_version..", built "..date)
end

-- - - - - - - - - - - - - - - - - - - - -
local style = ThemePrefs.Get("VisualTheme")
local image = "TitleMenu"

-- see: watch?v=wxBO6KX9qTA etc.
if FILEMAN:DoesFileExist("/Themes/"..sl_name.."/Graphics/_VisualStyles/"..ThemePrefs.Get("VisualTheme").."/TitleMenuAlt (doubleres).png") then
	if math.random(1,100) <= 10 then image="TitleMenuAlt" end
end

local af = Def.ActorFrame{
	InitCommand=function(self)
		--see: ./Scripts/SL_Init.lua
		InitializeSimplyLove()

		self:Center()
	end,
	OffCommand=function(self) self:linear(0.5):diffusealpha(0) end,
}

-- default SL values for the logo, arrows, etc.
local logo_x = 2
local logo_y = 0
local logo_zoom = 0.7
local logo_shadow = 0.75
local arrows_y = -16
local arrows_zoom = (game=="pump" and 0.2 or 0.205)
local versiontext_y = -120
local holiday_zoom = 0.225
local holiday_x = 130
local holiday_y = -110

-- if visual theme is Macro, change those values.
if GetThemePref("VisualTheme") == "Macro" then
	logo_x = 0
	logo_y = -55
	logo_zoom = 0.7
	logo_shadow = 0
	arrows_y = -42
	arrows_zoom = 0.14
	versiontext_y = -210
	holiday_zoom = 0.12
	holiday_x = 108
	holiday_y = -178
end

-- time to draw things!
-- a. logo
af[#af+1] = LoadActor(THEME:GetPathG("", "_VisualStyles/"..style.."/"..image.." (doubleres).png"))..{
	InitCommand=function(self) self:x(logo_x):y(logo_y):zoom(logo_zoom):shadowlength(logo_shadow) end,
	OffCommand=function(self) self:linear(0.5) end
}

-- b. arrows -- with a diffuse effect if we're in rainbow mode and Macro style
if (ThemePrefs.Get("RainbowMode") and (GetThemePref("VisualTheme") == "Macro")) then
	af[#af+1] = LoadActor(THEME:GetPathG("", "_logos/" .. game))..{
		InitCommand=function(self)
			self:x(0):y(arrows_y):zoom(arrows_zoom)
			self:diffuseshift()
			self:effectcolor1(color("#000000"))
			self:effectperiod(15)
		end
	 }
else
	af[#af+1] = LoadActor(THEME:GetPathG("", "_logos/" .. game))..{
		InitCommand=function(self)
			self:x(0):y(arrows_y):zoom(arrows_zoom)
		end
	}
end

-- c. SM version, SL version, song stats
af[#af+1] = Def.ActorFrame{
	InitCommand=function(self) self:zoom(0.8):y(versiontext_y):diffusealpha(0) end,
	OnCommand=function(self) self:sleep(0.2):linear(0.4):diffusealpha(1) end,

	LoadFont("Common Normal")..{
		Text=sm_version .. "       " .. sl_name .. (sl_version and (" v" .. sl_version) or ""),
		InitCommand=function(self) self:y(-20):diffuse(TextColor) end,
	},
	LoadFont("Common Normal")..{
		Text=SongStats,
		InitCommand=function(self) self:diffuse(TextColor) end,
	}
}

-- d. the best way to spread holiday cheer is singing loud for all to hear
if HolidayCheer() then
	af[#af+1] = Def.Sprite{
		Texture=THEME:GetPathB("ScreenTitleMenu", "underlay/hat.png"),
		InitCommand=function(self) self:zoom(holiday_zoom):xy(holiday_x, -self:GetHeight()/2 ):rotationz(15):queuecommand("Drop") end,
		DropCommand=function(self) self:decelerate(1.333):y(holiday_y) end,
	}
end


return af
