# SWDark5 live pages: espresso (chart + timer), steam / water / flush.

set txt    $::swdark5(text)
set muted  $::swdark5(text_muted)
set accent $::swdark5(accent)

# ---- espresso: full-bleed chart left, data column right ----------------------
add_de1_text "espresso" 80 90 -text [translate "espresso"] -font Helv_9_bold -fill $txt -anchor "w"
add_de1_variable "espresso" 320 90 -font Helv_9 -fill $muted -anchor "w" -textvariable {$::settings(profile_title)}
add_de1_variable "espresso" 2480 90 -font Helv_9_bold -fill $muted -anchor "e" -textvariable {[clock format [clock seconds] -format {%H:%M}]}

swd5_shot_graph "espresso" 60 200 1680 1240
swd5_chart_legend "espresso" 100 1490

# right data column
add_de1_variable "espresso" 2140 400 -font Helv_30_bold -fill $txt -anchor "center" -justify "center" -textvariable {[espresso_elapsed_timer]s}
add_de1_variable "espresso" 2140 540 -font Helv_10 -fill $accent -anchor "center" -justify "center" -textvariable {[de1_substate_text]}

swd5_panel "espresso" 1840 660 2440 1180 70 $::swdark5(surface)
add_de1_variable "espresso" 1900 780 -font Helv_9 -fill $muted -anchor "w" -textvariable {[espresso_preinfusion_timer]s [translate "preinfusion"]}
add_de1_variable "espresso" 1900 900 -font Helv_9 -fill $muted -anchor "w" -textvariable {[espresso_pour_timer]s [translate "pouring"]}
add_de1_variable "espresso" 1900 1020 -font Helv_9 -fill $txt -anchor "w" -textvariable {[round_to_one_digits $::de1(scale_weight)] g}
add_de1_variable "espresso" 1900 1120 -font Helv_9 -fill $txt -anchor "w" -textvariable {[round_to_one_digits $::de1(volume)] mL}

swd5_panel "espresso" 1840 1260 2440 1520 70 $::swdark5(danger)
add_de1_text "espresso" 2140 1390 -text [translate "STOP"] -font Helv_16_bold -fill $::swdark5(text) -anchor "center" -justify "center"
add_de1_button "espresso" {say [translate {stop}] $::settings(sound_button_in); start_idle} 1840 1260 2440 1520
# tapping the chart also stops the shot
add_de1_button "espresso" {say [translate {stop}] $::settings(sound_button_in); start_idle} 0 0 1800 1600

# ---- steam / water / flush ----------------------------------------------------
proc swd5_live_page {context title} {
	add_de1_text $context 80 90 -text $title -font Helv_9_bold -fill $::swdark5(text) -anchor "w"
	add_de1_variable $context 2480 90 -font Helv_9_bold -fill $::swdark5(text_muted) -anchor "e" -textvariable {[clock format [clock seconds] -format {%H:%M}]}
	swd5_ring $context 1280 760 420 8 $::swdark5(ring)
	add_de1_text $context 1280 700 -text $title -font Helv_30_bold -fill $::swdark5(text) -anchor "center" -justify "center"
	add_de1_variable $context 1280 860 -font Helv_10 -fill $::swdark5(accent) -anchor "center" -justify "center" -textvariable {[de1_substate_text]}
	add_de1_text $context 1280 1420 -text [translate "tap anywhere to stop"] -font Helv_8 -fill $::swdark5(text_muted) -anchor "center"
}

swd5_live_page "steam" [translate "steam"]
add_de1_button "steam" {say [translate {stop}] $::settings(sound_button_in); start_idle; check_if_steam_clogged} 0 0 2560 1600

swd5_live_page "water" [translate "water"]
add_de1_button "water" {say [translate {stop}] $::settings(sound_button_in); start_idle} 0 0 2560 1600

swd5_live_page "hotwaterrinse steamrinse" [translate "flush"]
add_de1_button "hotwaterrinse steamrinse" {say [translate {stop}] $::settings(sound_button_in); start_idle} 0 0 2560 1600

unset -nocomplain txt muted accent
