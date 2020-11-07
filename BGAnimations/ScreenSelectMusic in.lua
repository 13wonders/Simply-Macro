-- If UseDDROffset is enabled, make sure the GlobalOffsetSeconds gets reset before/after songs.
if GetThemePref("UseDDROffset") == true then ResetToDDROffset() end
-- SM('DDROffset is '..GetThemePref('DDROffset')..' and GlobalOffsetSeconds is '..PREFSMAN:GetPreference("GlobalOffsetSeconds"))
