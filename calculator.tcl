# SWDark5 shot calculator engine - ported from SWDark4's swdark_functions.tcl.
# Dose x Ratio = target weight, two-way synced with the app's stop-at-weight
# (final_desired_shot_weight / _advanced depending on profile type).
# State persists per-skin in userdata/swd5_usersettings.tdb; seeded from
# SWDark4's userdata on first run so existing tuning carries over.

proc swd5_settings_filename {} {
	return "[skin_directory]/userdata/swd5_usersettings.tdb"
}

proc save_swd5_settings {} {
	catch { file mkdir "[skin_directory]/userdata" }
	set data {}
	foreach k [lsort -dictionary [array names ::swd5_settings]] {
		append data [subst {[list $k] [list $::swd5_settings($k)]\n}]
	}
	write_file [swd5_settings_filename] $data
}

proc load_swd5_settings {} {
	array set ::swd5_settings {}
	catch { array set ::swd5_settings [encoding convertfrom utf-8 [read_binary_file [swd5_settings_filename]]] }

	# first run: seed dose/ratio from SWDark4's userdata if it exists
	if {![info exists ::swd5_settings(swcoffeedose)]} {
		set sw4 "[homedir]/skins/SWDark4/userdata/swdark_usersettings.tdb"
		if {[file exists $sw4]} {
			catch {
				array set sw4set [encoding convertfrom utf-8 [read_binary_file $sw4]]
				foreach k {swcoffeedose swbrewratio swbrewsettings} {
					if {[info exists sw4set($k)]} { set ::swd5_settings($k) $sw4set($k) }
				}
			}
		}
	}

	# defaults
	foreach {k v} {swcoffeedose 18.0 swbrewratio 2.0 swbrewsettings 1} {
		if {![info exists ::swd5_settings($k)]} { set ::swd5_settings($k) $v }
	}
	save_swd5_settings
}

# Current stop-at-weight, honouring standard vs advanced profile type.
proc swd5_target_weight {} {
	if {[ifexists ::settings(settings_profile_type)] == "settings_2c"} {
		return $::settings(final_desired_shot_weight_advanced)
	} else {
		return $::settings(final_desired_shot_weight)
	}
}

# dose/ratio changed -> push new target weight into the app settings
proc swd5_calc_apply {} {
	set target [expr {$::swd5_settings(swcoffeedose) * $::swd5_settings(swbrewratio)}]
	if {[ifexists ::settings(settings_profile_type)] == "settings_2c"} {
		set ::settings(final_desired_shot_weight_advanced) $target
	} else {
		set ::settings(final_desired_shot_weight) $target
	}
	save_swd5_settings
}

# weight changed elsewhere -> recompute ratio (SWDark4's updateswbrewratio2)
proc swd5_calc_ratio_from_weight {} {
	if {$::swd5_settings(swcoffeedose) > 0} {
		set ::swd5_settings(swbrewratio) [round_to_one_digits [expr {[swd5_target_weight] / $::swd5_settings(swcoffeedose)}]]
		save_swd5_settings
	}
}

# Adjust dose or ratio by delta, clamped, then apply.
proc swd5_calc_adjust {key delta min max} {
	set v [expr {$::swd5_settings($key) + $delta}]
	if {$v < $min} { set v $min }
	if {$v > $max} { set v $max }
	set ::swd5_settings($key) [round_to_one_digits $v]
	swd5_calc_apply
	update_onscreen_variables
}

proc swd5_calc_set_ratio {r} {
	set ::swd5_settings(swbrewratio) $r
	swd5_calc_apply
	update_onscreen_variables
}

# Espresso tap behaviour (SWDark4 heritage): with the calculator enabled AND a
# scale paired, tapping espresso opens the calculator; otherwise start the shot.
proc swd5_espresso_tap {} {
	if {$::swd5_settings(swbrewsettings) == 1 && $::settings(scale_bluetooth_address) != ""} {
		say [translate {shot calculator}] $::settings(sound_button_in)
		set_next_page off swd5_calc
		page_show swd5_calc
	} else {
		say [translate {espresso}] $::settings(sound_button_in)
		set_next_page off off
		start_espresso
	}
}

proc swd5_calc_start {} {
	say [translate {espresso}] $::settings(sound_button_in)
	save_settings
	set_next_page off off
	start_espresso
}

proc swd5_calc_cancel {} {
	say [translate {cancel}] $::settings(sound_button_in)
	set_next_page off off
	page_show off
}

load_swd5_settings
swd5_calc_ratio_from_weight
