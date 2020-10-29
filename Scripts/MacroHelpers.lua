
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

-- The following function checks whether the current song's group is NOT in ITG-Sync-Groups.txt.
-- If it is NOT "ITG," ITGGroupCheck() will set GlobalOffsetSeconds as DDROffset.
-- Otherwise, it will set GlobalOffsetSeconds as DDROffset minus 0.009. (See 99 SL-ThemePrefs.lua.)

ITGGroupCheck = function()
  if not FindInTable(GAMESTATE:GetCurrentSong():GetGroupName(), groups) then
    PREFSMAN:SetPreference('GlobalOffsetSeconds',GetThemePref('DDROffset'))
--    SM(GAMESTATE:GetCurrentSong():GetGroupName().." is the current group. GlobalOffsetSeconds is DDROffset, which is "..PREFSMAN:GetPreference('GlobalOffsetSeconds'))
  else
    PREFSMAN:SetPreference('GlobalOffsetSeconds',GetThemePref('DDROffset')-0.009)
--   SM(GAMESTATE:GetCurrentSong():GetGroupName().." is the current group. GlobalOffsetSeconds is "..GetThemePref('DDROffset').." minus 0.009, which is "..PREFSMAN:GetPreference('GlobalOffsetSeconds'))
  end
end
