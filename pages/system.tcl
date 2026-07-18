# SWDark5 system behaviors: screensaver wake-up.
# System pages (sleep, tankempty, cleaning, descaling, message, firmware...)
# come from skins/default/standard_includes.tcl; only the wake button is ours.

add_de1_button "saver" {say [translate {awake}] $::settings(sound_button_in); set_next_page off off; start_idle} 0 0 2560 1600
