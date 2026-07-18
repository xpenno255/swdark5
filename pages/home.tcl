# SWDark5 home ("off") page - "Shot Deck": the glowing shot chart is the hero,
# with a rail of action chips on the right. SWDark4's charts-always-visible
# identity in the new package.

set bg     $::swdark5(bg)
set txt    $::swdark5(text)
set muted  $::swdark5(text_muted)
set accent $::swdark5(accent)

set steam_col "#C9A7F5"
set water_col $::swdark5(chart_flow)
set flush_col "#9FD8A4"

# ---- pages ------------------------------------------------------------------
dui page add "off" -bg_color $bg -theme none
dui page add "espresso" -bg_color $bg -theme none
dui page add "steam" -bg_color $bg -theme none
dui page add "water" -bg_color $bg -theme none
dui page add "hotwaterrinse steamrinse" -bg_color $bg -theme none
dui page add "swd5_calc" -bg_color $bg -theme none

# ---- top bar ------------------------------------------------------------------
add_de1_text "off" 80 90 -text "SWDark5" -font Helv_9_bold -fill $txt -anchor "w"
add_de1_variable "off" 320 90 -font Helv_9 -fill $muted -anchor "w" -textvariable {$::settings(profile_title)}
add_de1_variable "off" 2480 90 -font Helv_9_bold -fill $muted -anchor "e" -textvariable {[clock format [clock seconds] -format {%H:%M}]}

# ---- hero: last shot chart -----------------------------------------------------
add_de1_text "off" 100 250 -text [translate "last shot"] -font Helv_7 -fill $muted -anchor "w"
add_de1_variable "off" 100 330 -font Helv_12_bold -fill $txt -anchor "w" -textvariable {[espresso_elapsed_timer] s}
swd5_shot_graph "off" 100 420 1580 940
swd5_chart_legend "off" 100 1440

# ---- right rail -----------------------------------------------------------------
add_de1_variable "off" 2120 320 -font Helv_30_bold -fill $txt -anchor "center" -justify "center" -textvariable {[round_to_one_digits $::de1(head_temperature)]°}
add_de1_variable "off" 2120 430 -font Helv_8 -fill $muted -anchor "center" -justify "center" -textvariable {[translate "group"] · [de1_substate_text]}

swd5_chip "off" 520 660 [translate "espresso"] $accent \
	{[round_to_integer [swd5_target_weight]] g} \
	{swd5_espresso_tap}
swd5_chip "off" 700 840 [translate "steam"] $steam_col \
	{[round_to_integer $::settings(steam_temperature)] °C} \
	{say [translate {steam}] $::settings(sound_button_in); start_steam}
swd5_chip "off" 880 1020 [translate "water"] $water_col \
	{[round_to_integer $::settings(water_volume)] mL} \
	{say [translate {water}] $::settings(sound_button_in); start_water}
swd5_chip "off" 1060 1200 [translate "flush"] $flush_col \
	{[round_to_integer $::settings(flush_seconds)] s} \
	{say [translate {flush}] $::settings(sound_button_in); start_flush}

# dose - ratio - target chip (always opens the calculator)
swd5_panel "off" 1740 1240 2500 1340 50 "#101010"
add_de1_variable "off" 2120 1290 -font Helv_8_bold -fill $accent -anchor "center" -justify "center" \
	-textvariable {[round_to_one_digits $::swd5_settings(swcoffeedose)] g · 1:[round_to_one_digits $::swd5_settings(swbrewratio)] · [round_to_integer [swd5_target_weight]] g}
add_de1_button "off" {say [translate {shot calculator}] $::settings(sound_button_in); page_show swd5_calc} 1740 1240 2500 1340

swd5_pill "off" 1740 1380 2100 1500 [translate "settings"] \
	{say [translate {settings}] $::settings(sound_button_in); set_next_page off swd5_setts; page_show swd5_setts}
swd5_pill "off" 2140 1380 2500 1500 [translate "sleep"] \
	{say [translate {sleep}] $::settings(sound_button_in); start_sleep}

unset -nocomplain bg txt muted accent steam_col water_col flush_col
