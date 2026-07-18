# SWDark5 drawing/widget helpers (all prefixed swd5_ to avoid clashes).

# Add already-created canvas items (by tag) to one or more page contexts.
proc swd5_add_to_contexts {contexts tags} {
	foreach context [split $contexts " "] {
		foreach tag [split $tags " "] {
			add_visual_item_to_context $context $tag
		}
	}
}

# Rounded rectangle panel in virtual 2560x1600 coordinates.
proc swd5_panel {contexts x1 y1 x2 y2 radius colour} {
	set x1 [rescale_x_skin $x1]
	set y1 [rescale_y_skin $y1]
	set x2 [rescale_x_skin $x2]
	set y2 [rescale_y_skin $y2]
	set radius [rescale_x_skin $radius]
	if {[info exists ::_swd5_panel_id] != 1} { set ::_swd5_panel_id 0 }
	set tag "swd5_panel_$::_swd5_panel_id"
	.can create oval $x1 $y1 [expr {$x1 + $radius}] [expr {$y1 + $radius}] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	.can create oval [expr {$x2 - $radius}] $y1 $x2 [expr {$y1 + $radius}] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	.can create oval $x1 [expr {$y2 - $radius}] [expr {$x1 + $radius}] $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	.can create oval [expr {$x2 - $radius}] [expr {$y2 - $radius}] $x2 $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	.can create rectangle [expr {$x1 + ($radius / 2.0)}] $y1 [expr {$x2 - ($radius / 2.0)}] $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	.can create rectangle $x1 [expr {$y1 + ($radius / 2.0)}] $x2 [expr {$y2 - ($radius / 2.0)}] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	swd5_add_to_contexts $contexts $tag
	incr ::_swd5_panel_id
	return $tag
}

# Thin ring gauge (circle outline) centered at cx,cy with radius r.
proc swd5_ring {contexts cx cy r width colour} {
	set x1 [rescale_x_skin [expr {$cx - $r}]]
	set y1 [rescale_y_skin [expr {$cy - $r}]]
	set x2 [rescale_x_skin [expr {$cx + $r}]]
	set y2 [rescale_y_skin [expr {$cy + $r}]]
	if {[info exists ::_swd5_ring_id] != 1} { set ::_swd5_ring_id 0 }
	set tag "swd5_ring_$::_swd5_ring_id"
	.can create oval $x1 $y1 $x2 $y2 -outline $colour -width [rescale_x_skin $width] -fill {} -tag $tag -state "hidden"
	swd5_add_to_contexts $contexts $tag
	incr ::_swd5_ring_id
	return $tag
}

# Pastel parameter card: caption top-left, live big value bottom-left, whole
# card is the button. This is the Wendougee-style building block.
proc swd5_card {contexts x1 y1 x2 y2 colour caption big_textvariable action} {
	swd5_panel $contexts $x1 $y1 $x2 $y2 70 $colour
	add_de1_text $contexts [expr {$x1 + 60}] [expr {$y1 + 80}] \
		-text $caption -font Helv_9_bold -fill $::swdark5(card_muted) -anchor "w"
	add_de1_variable $contexts [expr {$x1 + 60}] [expr {$y2 - 110}] \
		-font Helv_30_bold -fill $::swdark5(card_text) -anchor "w" -textvariable $big_textvariable
	add_de1_button $contexts $action $x1 $y1 $x2 $y2
}

# Blend a hex colour toward black: frac 1.0 = full colour, 0.0 = black.
# Tk has no alpha channel, but on a black background "colour at N% opacity"
# is exactly the colour scaled by N% - so this fakes transparency and glows.
proc swd5_blend {hex frac} {
	scan $hex "#%2x%2x%2x" r g b
	format "#%02x%02x%02x" [expr {int($r * $frac)}] [expr {int($g * $frac)}] [expr {int($b * $frac)}]
}

# Glowing ring: three concentric outlines, wide/dark to thin/bright.
proc swd5_glowring {contexts cx cy r colour} {
	swd5_ring $contexts $cx $cy $r 18 [swd5_blend $colour 0.30]
	swd5_ring $contexts $cx $cy $r 10 [swd5_blend $colour 0.60]
	swd5_ring $contexts $cx $cy $r 5 $colour
}

# The SWDark5 live shot graph: glow lines over dark area fills.
proc swd5_shot_graph {contexts x y w h} {
	add_de1_widget $contexts graph $x $y {
		set sm $::settings(live_graph_smoothing_technique)
		set p $::swdark5(chart_pressure)
		set f $::swdark5(chart_flow)
		set w $::swdark5(chart_weight)
		set t $::swdark5(chart_temp)

		$widget element create fill_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth 1 -color [swd5_blend $p 0.10] -smooth $sm -pixels 0 -areapattern solid -areaforeground [swd5_blend $p 0.10]
		$widget element create fill_flow -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth 1 -color [swd5_blend $f 0.10] -smooth $sm -pixels 0 -areapattern solid -areaforeground [swd5_blend $f 0.10]

		$widget element create glow_pressure_outer -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 24] -color [swd5_blend $p 0.22] -smooth $sm -pixels 0
		$widget element create glow_flow_outer -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 24] -color [swd5_blend $f 0.22] -smooth $sm -pixels 0
		$widget element create glow_weight_outer -xdata espresso_elapsed -ydata espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 24] -color [swd5_blend $w 0.22] -smooth $sm -pixels 0
		$widget element create glow_pressure_inner -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 14] -color [swd5_blend $p 0.45] -smooth $sm -pixels 0
		$widget element create glow_flow_inner -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 14] -color [swd5_blend $f 0.45] -smooth $sm -pixels 0
		$widget element create glow_weight_inner -xdata espresso_elapsed -ydata espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 14] -color [swd5_blend $w 0.45] -smooth $sm -pixels 0

		# temperature on the secondary (y2) axis: glow halo + core + dashed goal
		$widget element create glow_temp_inner -xdata espresso_elapsed -ydata espresso_temperature_basket -symbol none -label "" -linewidth [rescale_x_skin 14] -color [swd5_blend $t 0.40] -smooth $sm -pixels 0 -mapy y2
		$widget element create line_temperature_goal -xdata espresso_elapsed -ydata espresso_temperature_goal -symbol none -label "" -linewidth [rescale_x_skin 3] -color $::swdark5(chart_temp_goal) -smooth $sm -pixels 0 -dashes {4 6} -mapy y2
		$widget element create line_temperature -xdata espresso_elapsed -ydata espresso_temperature_basket -symbol none -label "" -linewidth [rescale_x_skin 6] -color $t -smooth $sm -pixels 0 -mapy y2

		$widget element create line_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 3] -color $::swdark5(chart_pressure_goal) -smooth $sm -pixels 0 -dashes {4 6}
		$widget element create line_flow_goal -xdata espresso_elapsed -ydata espresso_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 3] -color $::swdark5(chart_flow_goal) -smooth $sm -pixels 0 -dashes {4 6}
		$widget element create line_state_change -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 3] -color $::swdark5(chart_step) -pixels 0
		$widget element create line_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 8] -color $p -smooth $sm -pixels 0
		$widget element create line_flow -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 8] -color $f -smooth $sm -pixels 0
		$widget element create line_flow_weight -xdata espresso_elapsed -ydata espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 8] -color $w -smooth $sm -pixels 0

		# BLT draws the display list first-to-last (bottom-to-top). Temperature
		# sits above the fills/glow but below the primary pressure/flow lines.
		$widget element show {fill_pressure fill_flow glow_pressure_outer glow_flow_outer glow_weight_outer glow_pressure_inner glow_flow_inner glow_weight_inner glow_temp_inner line_state_change line_temperature_goal line_temperature line_pressure_goal line_flow_goal line_flow_weight line_flow line_pressure}

		$widget axis configure x -color $::swdark5(chart_axis) -tickfont Helv_6 -linewidth [rescale_x_skin 1]
		$widget axis configure y -color $::swdark5(chart_axis) -tickfont Helv_6 -min 0.0 -max [expr {$::de1(max_pressure) + 0.01}] -subdivisions 5 -majorticks {2 4 6 8 10 12} -linewidth [rescale_x_skin 1]
		$widget axis configure y2 -color $::swdark5(chart_temp) -tickfont Helv_6 -min $::swdark5(temp_axis_min) -max $::swdark5(temp_axis_max) -majorticks {85 90 95} -hide 0 -linewidth [rescale_x_skin 1]
		catch { $widget grid configure -color $::swdark5(chart_grid) }
	} -plotbackground $::swdark5(chart_bg) -width [rescale_x_skin $w] -height [rescale_y_skin $h] -borderwidth 0 -background $::swdark5(chart_bg) -plotrelief flat
}

# Chart legend row.
proc swd5_chart_legend {contexts x y} {
	add_de1_text $contexts $x $y -text [translate "pressure"] -font Helv_7 -fill $::swdark5(chart_pressure) -anchor "w"
	add_de1_text $contexts [expr {$x + 340}] $y -text [translate "flow"] -font Helv_7 -fill $::swdark5(chart_flow) -anchor "w"
	add_de1_text $contexts [expr {$x + 600}] $y -text [translate "weight"] -font Helv_7 -fill $::swdark5(chart_weight) -anchor "w"
	add_de1_text $contexts [expr {$x + 900}] $y -text [translate "temp"] -font Helv_7 -fill $::swdark5(chart_temp) -anchor "w"
}

# ---- scale connection status ------------------------------------------------
# A tappable indicator: coloured dot + text, driven live by the variable update
# cycle (the textvariable script updates the dot colour as a side effect).
# Green = connected, amber = paired-but-off, grey = no scale. Tapping a
# paired-but-off scale triggers a reconnect; with no scale it opens settings.
proc swd5_scale_status_text {} {
	set connected [expr {[info exists ::de1(scale_device_handle)] && $::de1(scale_device_handle) != 0}]
	set paired [expr {[ifexists ::settings(scale_bluetooth_address)] ne ""}]
	if {$connected} {
		set col $::swdark5(chart_pressure)
		set txt [translate "scale ready"]
	} elseif {$paired} {
		set col $::swdark5(chart_temp)
		set txt [translate "tap to connect"]
	} else {
		set col $::swdark5(text_muted)
		set txt [translate "no scale"]
	}
	foreach tag [ifexists ::swd5_scale_dots] {
		catch { .can itemconfigure $tag -fill $col -outline $col }
	}
	return $txt
}

proc swd5_scale_tap {} {
	say "" $::settings(sound_button_in)
	if {[ifexists ::settings(scale_bluetooth_address)] ne ""} {
		catch { ble_connect_to_scale }
	} else {
		show_settings
	}
}

# Place the scale status indicator on a page at (x,y), left-anchored.
proc swd5_scale_status {contexts x y} {
	lappend ::swd5_scale_dots [swd5_dot $contexts [expr {$x + 20}] [expr {$y + 4}] 14 $::swdark5(text_muted)]
	add_de1_variable $contexts [expr {$x + 70}] $y -font Helv_8_bold -fill $::swdark5(text_muted) -anchor "w" -textvariable {[swd5_scale_status_text]}
	add_de1_button $contexts {swd5_scale_tap} [expr {$x - 20}] [expr {$y - 60}] [expr {$x + 520}] [expr {$y + 70}]
}

# Small coloured dot.
proc swd5_dot {contexts cx cy r colour} {
	if {[info exists ::_swd5_dot_id] != 1} { set ::_swd5_dot_id 0 }
	set tag "swd5_dot_$::_swd5_dot_id"
	.can create oval [rescale_x_skin [expr {$cx - $r}]] [rescale_y_skin [expr {$cy - $r}]] [rescale_x_skin [expr {$cx + $r}]] [rescale_y_skin [expr {$cy + $r}]] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	swd5_add_to_contexts $contexts $tag
	incr ::_swd5_dot_id
	return $tag
}

# Action chip: dark row with coloured dot, label left, live value right,
# whole row is the button. The concept-3 building block.
proc swd5_chip {contexts y1 y2 label colour value_textvariable action} {
	swd5_panel $contexts 1740 $y1 2500 $y2 70 "#161616"
	swd5_dot $contexts 1830 [expr {($y1 + $y2) / 2.0}] 14 $colour
	add_de1_text $contexts 1890 [expr {($y1 + $y2) / 2.0}] -text $label -font Helv_10_bold -fill $::swdark5(text) -anchor "w"
	add_de1_variable $contexts 2420 [expr {($y1 + $y2) / 2.0}] -font Helv_10_bold -fill $colour -anchor "e" -textvariable $value_textvariable
	add_de1_button $contexts $action 1740 $y1 2500 $y2
}

# Normalize z-order on our pages. dui's add_items raises each classic canvas
# item to just above the page background at registration time, which can leave
# later-created items (dots, lines) buried under earlier panels. Re-stack:
# dots above panels, text labels above everything, button hit areas on top.
# Call once at the end of skin.tcl, after all pages are built.
proc swd5_fix_zorder {} {
	foreach page {off espresso steam water hotwaterrinse steamrinse swd5_calc swd5_setts} {
		set items {}
		catch { set items [dui page items $page] }
		foreach id $items {
			if {[lsearch -glob [.can gettags $id] "swd5_dot_*"] >= 0} { .can raise $id }
		}
		foreach id $items {
			if {[.can type $id] eq "text"} { .can raise $id }
		}
		foreach id $items {
			if {[.can type $id] eq "rectangle" && [catch {.can itemcget $id -fill} f] == 0 && $f eq ""} { .can raise $id }
		}
	}
}

# Small dark pill button.
proc swd5_pill {contexts x1 y1 x2 y2 label action} {
	swd5_panel $contexts $x1 $y1 $x2 $y2 [expr {$y2 - $y1}] $::swdark5(surface2)
	add_de1_text $contexts [expr {($x1 + $x2) / 2.0}] [expr {($y1 + $y2) / 2.0}] \
		-text $label -font Helv_8_bold -fill $::swdark5(text) -anchor "center" -justify "center"
	add_de1_button $contexts $action $x1 $y1 $x2 $y2
}
