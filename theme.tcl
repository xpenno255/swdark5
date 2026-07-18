# SWDark5 palette — premium dark, Wendougee E-Bar inspired:
# pure black canvas, thin pale ring gauge, pastel parameter cards with
# dark text and big numerals, blue action accent. SWDark4's signature
# green/blue lives on in the shot chart.

array set ::swdark5 {
	bg            "#000000"
	surface       "#141414"
	surface2      "#1F1F1F"
	outline       "#2A2A2A"
	text          "#F5F5F5"
	text_muted    "#8E8E93"
	ring          "#C7D8EA"
	accent        "#86C240"
	blue          "#4A9BFF"
	danger        "#E05A4E"

	card_yellow   "#F6EFA6"
	card_lavender "#CFC6F2"
	card_blue     "#B7D2F4"
	card_mint     "#CBE8CD"
	card_text     "#17181A"
	card_muted    "#55575C"
}

# Chart line colours (SWDark4 heritage, tuned for pure black)
set ::swdark5(chart_bg)            $::swdark5(bg)
set ::swdark5(chart_axis)          "#8E8E93"
set ::swdark5(chart_grid)          "#1C1C1C"
set ::swdark5(chart_step)          "#3A3A3A"
set ::swdark5(chart_pressure)      "#86C240"
set ::swdark5(chart_pressure_goal) "#B5DD8B"
set ::swdark5(chart_flow)          "#43B1E3"
set ::swdark5(chart_flow_goal)     "#87C6E3"
set ::swdark5(chart_weight)        "#C9A15E"
set ::swdark5(chart_temp)          "#E8734D"
set ::swdark5(chart_temp_goal)     "#F0A487"
# temperature uses its own y2 axis band (°C), since it lives far above the
# 0-12 pressure/flow range and would otherwise be off-screen.
set ::swdark5(temp_axis_min)       80
set ::swdark5(temp_axis_max)       100
