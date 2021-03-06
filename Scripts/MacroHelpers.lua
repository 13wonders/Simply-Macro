
-- much of this comes from ../BGAnimations/ScreenSelectMusicCasual/Setup.lua
-- define groups that are synced to ITG +9 ms in ../Other/ITG-Sync-Groups.txt
-- for all other groups, SM will assume DDROffset is applicable

---------------------------------------------------------------------------
-- helper function used by GetGroups() and GetDefaultSong()
-- returns the contents of a txt file as an indexed table, split on newline

local GetFileContents = function(path)
	local contents = ""

	if FILEMAN:DoesFileExist(path) then
		-- create a generic RageFile that we'll use to read the contents
		local file = RageFileUtil.CreateRageFile()
		-- the second argument here (the 1) signifies
		-- that we are opening the file in read-only mode
		if file:Open(path, 1) then
			contents = file:Read()
		end

		-- destroy the generic RageFile now that we have the contents
		file:destroy()
	end

	-- split the contents of the file on newline
	-- to create a table of lines as strings
	local lines = {}
	for line in contents:gmatch("[^\r\n]+") do
		lines[#lines+1] = line
	end

	return lines
end

---------------------------------------------------------------------------
-- parse ../Other/ITG-Sync-Groups.txt for groups with songs synced to ITG +9 ms
-- returns an indexed table of group names as strings

local GetGroups = function()
	local path = THEME:GetCurrentThemeDirectory() .. "Other/ITG-Sync-Groups.txt"
	local groups = GetFileContents(path)
	local preliminary_groups = GetFileContents(path)
	local groups = {}
-- add only uncommented lines to the final group table
	for prelim_group in ivalues(preliminary_groups) do
		if not string.match(prelim_group, '^#') then
			groups[#groups+1] = prelim_group
		end
	end

  return groups
end

---------------------------------------------------------------------------

local groups = GetGroups()

-- debugging code to print all detected groups to log
-- for i,line in ipairs(groups) do
--	Trace(line)
-- end

-- ITGGroupCheck() is called at ScreenGameplay in.
-- The following function checks whether the current song's group is NOT in ITG-Sync-Groups.txt.
-- If it is NOT "ITG," ITGGroupCheck() will set GlobalOffsetSeconds as DDROffset, divided by 1000, because DDROffset is in milliseconds, whereas GlobalOffsetSeconds is in seconds.
-- Otherwise, it will set GlobalOffsetSeconds as DDROffset (again, divided by 1000) minus 0.009. (See 99 SL-ThemePrefs.lua.)

ITGGroupCheck = function()
	local DDROffsetSeconds = GetThemePref('DDROffset')/1000
  if not FindInTable(GAMESTATE:GetCurrentSong():GetGroupName(), groups) then
    PREFSMAN:SetPreference('GlobalOffsetSeconds',DDROffsetSeconds)
--	SM(GAMESTATE:GetCurrentSong():GetGroupName().." is the current group. GlobalOffsetSeconds is DDROffsetSeconds, which is "..DDROffsetSeconds)
  else
    PREFSMAN:SetPreference('GlobalOffsetSeconds',DDROffsetSeconds-0.009)
--	SM(GAMESTATE:GetCurrentSong():GetGroupName().." is the current group. GlobalOffsetSeconds is "..DDROffsetSeconds.." minus 0.009, which is "..PREFSMAN:GetPreference('GlobalOffsetSeconds'))
  end
end


-- ResetToDDROffset() is called at ScreenSelectMusic in (and ScreenSelectMusicCasual in).
-- It's used for resetting GlobalOffsetSeconds back to the DDROffset before/between/after songs.
-- Without this, if you play an "ITG" song in Simply Macro, and then switch themes, your GlobalOffsetSeconds will remain at the "ITG" offset.
-- This can be a problem particularly if your Simply Macro prefs get reset, and the default DDROffset gets set to your most recent GlobalOffsetSeconds.
-- This doesn't switch things back if a user closes the game in the middle of a song, but I'm not sure there's anything that can be done about that.

ResetToDDROffset = function()
	local DDROffsetSeconds = GetThemePref('DDROffset')/1000
	PREFSMAN:SetPreference('GlobalOffsetSeconds',DDROffsetSeconds)
end
