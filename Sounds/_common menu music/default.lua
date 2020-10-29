local songs = {
	Hearts = "feel",
	Arrows = "cloud break",
	Bears  = "crystalis",
	Ducks  = "Xuxa fami VRC6",
	Cats   = "Beanmania IIDX",
	Spooky = "Spooky Scary Chiptunes",
	Gay    = "Mystical Wheelbarrow Journey",
	Stars  = "Shooting Star - faux VRC6 remix",
	Thonk  = "Da Box of Kardboard Too (feat Naoki vs ZigZag) - TaroNuke Remix",
}

-- retrieve the current VisualTheme from the ThemePrefs system
local style = ThemePrefs.Get("VisualTheme")

-- use the style to index the songs table (above)
-- and get the song associated with this VisualTheme
local file = songs[ style ]

-- if a song file wasn't defined in the songs table above
-- fall back on the song for Hearts as default music
-- (this sometimes happens when people are experimenting
-- with making their own custom VisualThemes)
-- if not file then file = songs.Hearts end

-- let's get a randomish song instead:
-- 1/3 chance of cloud break
-- 1/3 chance of crystalis
-- 1/3 chance of xuxa, mystical wheelbarrow, or shooting star
-- defining a local variable songrandomflip here causes song changes between menu screens...
-- so we'll re-roll every time we're at the title screen instead

if not file then
	if (songrandomflip <= 33) then
		file = songs.Arrows
	elseif ((songrandomflip > 33) and (songrandomflip <= 66)) then
		file = songs.Bears
	elseif ((songrandomflip > 66) and (songrandomflip <= 77)) then
		file = songs.Ducks
	elseif ((songrandomflip > 77) and (songrandomflip <= 88)) then
		file = songs.Gay
	elseif ((songrandomflip > 88) and (songrandomflip <= 99)) then
		file = songs.Stars
	end
end

-- annnnnd some EasterEggs
if PREFSMAN:GetPreference("EasterEggs") and style ~= "Thonk" then
	--  41 days remain until the end of the year.
	if MonthOfYear()==10 and DayOfMonth()==20 then file = "20" end
	-- the best way to spread holiday cheer is singing loud for all to hear
	if MonthOfYear()==11 then file = "HolidayCheer" end
end

return THEME:GetPathS("", "_common menu music/" .. file)
