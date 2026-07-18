# SWDark5 shot calculator page ("swd5_calc") - "chip stack" design.
# Target metrics centred on the left; dose/ratio as home-style adjuster chips
# (outer tap zones = ±1, inner = ±0.1); START is a big espresso chip.

set txt   $::swdark5(text)
set muted $::swdark5(text_muted)
set acc   $::swdark5(accent)
set gold  $::swdark5(chart_weight)
set blue  $::swdark5(chart_flow)

# ---- top bar -------------------------------------------------------------------
add_de1_text "swd5_calc" 80 90 -text [translate "shot calculator"] -font Helv_9_bold -fill $txt -anchor "w"
add_de1_variable "swd5_calc" 460 90 -font Helv_9 -fill $muted -anchor "w" -textvariable {$::settings(profile_title)}
swd5_scale_status "swd5_calc" 1500 90
add_de1_variable "swd5_calc" 2480 90 -font Helv_9_bold -fill $muted -anchor "e" -textvariable {[clock format [clock seconds] -format {%H:%M}]}

# ---- left: target metrics, centred ------------------------------------------------
add_de1_variable "swd5_calc" 620 720 -font Helv_30_bold -fill $txt -anchor "center" -justify "center" \
	-textvariable {[round_to_integer [expr {$::swd5_settings(swcoffeedose) * $::swd5_settings(swbrewratio)}]] g}
add_de1_text "swd5_calc" 620 850 -text [translate "target weight"] -font Helv_8 -fill $muted -anchor "center"
add_de1_variable "swd5_calc" 620 950 -font Helv_10_bold -fill $acc -anchor "center" -justify "center" \
	-textvariable {1:[round_to_one_digits $::swd5_settings(swbrewratio)]  @  [round_to_one_digits $::swd5_settings(swcoffeedose)] g}

swd5_pill "swd5_calc" 420 1330 820 1450 [translate "cancel"] {swd5_calc_cancel}

# ---- dose chip ---------------------------------------------------------------------
swd5_panel "swd5_calc" 1180 200 2500 400 70 "#161616"
add_de1_text "swd5_calc" 1290 300 -text "−" -font Helv_20_bold -fill $muted -anchor "center"
swd5_dot "swd5_calc" 1450 300 14 $gold
add_de1_text "swd5_calc" 1510 300 -text [translate "dose"] -font Helv_10_bold -fill $txt -anchor "w"
add_de1_variable "swd5_calc" 2140 300 -font Helv_16_bold -fill $gold -anchor "center" -justify "center" \
	-textvariable {[round_to_one_digits $::swd5_settings(swcoffeedose)] g}
add_de1_text "swd5_calc" 2390 300 -text "+" -font Helv_20_bold -fill $muted -anchor "center"
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swcoffeedose -1 1 30} 1180 200 1510 400
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swcoffeedose -0.1 1 30} 1510 200 1840 400
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swcoffeedose 0.1 1 30} 1840 200 2170 400
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swcoffeedose 1 1 30} 2170 200 2500 400

# ---- ratio chip --------------------------------------------------------------------
swd5_panel "swd5_calc" 1180 440 2500 640 70 "#161616"
add_de1_text "swd5_calc" 1290 540 -text "−" -font Helv_20_bold -fill $muted -anchor "center"
swd5_dot "swd5_calc" 1450 540 14 $blue
add_de1_text "swd5_calc" 1510 540 -text [translate "ratio"] -font Helv_10_bold -fill $txt -anchor "w"
add_de1_variable "swd5_calc" 2140 540 -font Helv_16_bold -fill $blue -anchor "center" -justify "center" \
	-textvariable {1 : [round_to_one_digits $::swd5_settings(swbrewratio)]}
add_de1_text "swd5_calc" 2390 540 -text "+" -font Helv_20_bold -fill $muted -anchor "center"
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swbrewratio -1 1 10} 1180 440 1510 640
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swbrewratio -0.1 1 10} 1510 440 1840 640
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swbrewratio 0.1 1 10} 1840 440 2170 640
add_de1_button "swd5_calc" {say "" $::settings(sound_button_in); swd5_calc_adjust swbrewratio 1 1 10} 2170 440 2500 640

# ---- ratio presets ------------------------------------------------------------------
swd5_pill "swd5_calc" 1180 700 1480 810 "1 : 1" {say "" $::settings(sound_button_in); swd5_calc_set_ratio 1}
swd5_pill "swd5_calc" 1520 700 1820 810 "1 : 2" {say "" $::settings(sound_button_in); swd5_calc_set_ratio 2}
swd5_pill "swd5_calc" 1860 700 2160 810 "1 : 2.5" {say "" $::settings(sound_button_in); swd5_calc_set_ratio 2.5}
swd5_pill "swd5_calc" 2200 700 2500 810 "1 : 3" {say "" $::settings(sound_button_in); swd5_calc_set_ratio 3}

# ---- start chip ----------------------------------------------------------------------
swd5_panel "swd5_calc" 1180 1240 2500 1520 70 "#161616"
swd5_dot "swd5_calc" 1300 1380 16 $acc
add_de1_text "swd5_calc" 1370 1380 -text [translate "start espresso"] -font Helv_12_bold -fill $txt -anchor "w"
add_de1_variable "swd5_calc" 2400 1380 -font Helv_12_bold -fill $acc -anchor "e" \
	-textvariable {[round_to_integer [expr {$::swd5_settings(swcoffeedose) * $::swd5_settings(swbrewratio)}]] g}
add_de1_button "swd5_calc" {swd5_calc_start} 1180 1240 2500 1520

unset -nocomplain txt muted acc gold blue
