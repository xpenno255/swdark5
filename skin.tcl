# SWDark5 - premium dark skin for the Decent DE1, successor to SWDark4.
# By Spencer Webb. Vector-drawn (no bitmap backgrounds), classic-API + DUI hybrid.

package require de1 1.0

source "[homedir]/skins/default/standard_includes.tcl"

set ::skindebug 0

source "[skin_directory]/theme.tcl"
source "[skin_directory]/framework.tcl"
source "[skin_directory]/calculator.tcl"
source "[skin_directory]/pages/home.tcl"
source "[skin_directory]/pages/calc_page.tcl"
source "[skin_directory]/pages/settings_page.tcl"
source "[skin_directory]/pages/live.tcl"
source "[skin_directory]/pages/system.tcl"

swd5_fix_zorder
