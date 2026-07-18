# SWDark5 machine settings page ("swd5_setts"): adjuster cards for the
# steam / water / flush values shown on the home chips, the shot-calculator
# toggle, and a link through to the core app settings.

dui page add "swd5_setts" -bg_color $::swdark5(bg) -theme none

# Adjust an ::settings key by delta, clamped to [min, max], integers.
proc swd5_setting_adjust {key delta min max} {
	set v [expr {round($::settings($key) + $delta)}]
	if {$v < $min} { set v $min }
	if {$v > $max} { set v $max }
	set ::settings($key) $v
	update_onscreen_variables
}

proc swd5_toggle_calc {} {
	set ::swd5_settings(swbrewsettings) [expr {!$::swd5_settings(swbrewsettings)}]
	save_swd5_settings
	update_onscreen_variables
}

proc swd5_setts_back {} {
	say [translate {done}] $::settings(sound_button_in)
	save_settings
	set_next_page off off
	page_show off
}

# Adjuster card: label + live value, edge tap zones (outer = ±big, inner = ±small).
proc swd5_adjust_card {contexts x1 y1 x2 y2 colour label value_tv key dsmall dbig min max} {
	swd5_panel $contexts $x1 $y1 $x2 $y2 70 $colour
	set cx [expr {($x1 + $x2) / 2.0}]
	set cy [expr {($y1 + $y2) / 2.0}]
	add_de1_text $contexts [expr {$x1 + 110}] $cy -text "−" -font Helv_30_bold -fill $::swdark5(card_muted) -anchor "center"
	add_de1_text $contexts $cx [expr {$y1 + 90}] -text $label -font Helv_9_bold -fill $::swdark5(card_muted) -anchor "center"
	add_de1_variable $contexts $cx [expr {$cy + 50}] -font Helv_20_bold -fill $::swdark5(card_text) -anchor "center" -justify "center" -textvariable $value_tv
	add_de1_text $contexts [expr {$x2 - 110}] $cy -text "+" -font Helv_30_bold -fill $::swdark5(card_muted) -anchor "center"
	set q [expr {($x2 - $x1) / 4.0}]
	add_de1_button $contexts "say {} \$::settings(sound_button_in); swd5_setting_adjust $key -$dbig $min $max" $x1 $y1 [expr {$x1 + $q}] $y2
	add_de1_button $contexts "say {} \$::settings(sound_button_in); swd5_setting_adjust $key -$dsmall $min $max" [expr {$x1 + $q}] $y1 [expr {$x1 + 2*$q}] $y2
	add_de1_button $contexts "say {} \$::settings(sound_button_in); swd5_setting_adjust $key $dsmall $min $max" [expr {$x1 + 2*$q}] $y1 [expr {$x2 - $q}] $y2
	add_de1_button $contexts "say {} \$::settings(sound_button_in); swd5_setting_adjust $key $dbig $min $max" [expr {$x2 - $q}] $y1 $x2 $y2
}

# ---- top bar -------------------------------------------------------------------
add_de1_text "swd5_setts" 80 90 -text [translate "machine settings"] -font Helv_9_bold -fill $::swdark5(text) -anchor "w"
add_de1_variable "swd5_setts" 2480 90 -font Helv_9_bold -fill $::swdark5(text_muted) -anchor "e" -textvariable {[clock format [clock seconds] -format {%H:%M}]}

# ---- adjuster cards ---------------------------------------------------------------
swd5_adjust_card "swd5_setts" 180 200 1220 560 $::swdark5(card_lavender) [translate "steam temperature"] \
	{[round_to_integer $::settings(steam_temperature)] °C} steam_temperature 1 5 130 170
swd5_adjust_card "swd5_setts" 1340 200 2380 560 $::swdark5(card_lavender) [translate "steam auto-off"] \
	{[round_to_integer $::settings(steam_timeout)] s} steam_timeout 5 30 10 600

swd5_adjust_card "swd5_setts" 180 600 1220 960 $::swdark5(card_blue) [translate "water volume"] \
	{[round_to_integer $::settings(water_volume)] mL} water_volume 1 10 10 500
swd5_adjust_card "swd5_setts" 1340 600 2380 960 $::swdark5(card_blue) [translate "water temperature"] \
	{[round_to_integer $::settings(water_temperature)] °C} water_temperature 1 5 20 95

swd5_adjust_card "swd5_setts" 180 1000 1220 1360 $::swdark5(card_mint) [translate "flush duration"] \
	{[round_to_integer $::settings(flush_seconds)] s} flush_seconds 1 5 1 60

# calculator toggle card
swd5_panel "swd5_setts" 1340 1000 2380 1360 70 "#161616"
add_de1_text "swd5_setts" 1860 1090 -text [translate "espresso tap opens calculator"] -font Helv_9_bold -fill $::swdark5(text_muted) -anchor "center"
add_de1_variable "swd5_setts" 1860 1230 -font Helv_20_bold -fill $::swdark5(accent) -anchor "center" -justify "center" \
	-textvariable {[expr {$::swd5_settings(swbrewsettings) == 1 ? [translate "ON"] : [translate "OFF"]}]}
add_de1_text "swd5_setts" 1860 1320 -text [translate "needs a paired scale"] -font Helv_7 -fill $::swdark5(text_muted) -anchor "center"
add_de1_button "swd5_setts" {say "" $::settings(sound_button_in); swd5_toggle_calc} 1340 1000 2380 1360

# ---- bottom row --------------------------------------------------------------------
swd5_pill "swd5_setts" 180 1420 540 1540 [translate "done"] {swd5_setts_back}
swd5_pill "swd5_setts" 580 1420 1040 1540 [translate "app settings"] \
	{say [translate {settings}] $::settings(sound_button_in); show_settings}
