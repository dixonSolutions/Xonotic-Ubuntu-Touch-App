#include "dialog_settings_touch.qh"

#include "touch_menu_layout.qh"
#include "textlabel.qh"
#include "slider.qh"
#include "checkbox.qh"
#include "commandbutton.qh"
#include "button.qh"
#include "mixedslider.qh"

void TouchMenu_SaveLayout_Click(entity me, entity other)
{
	TouchMenu_WriteLayoutFile("touch.layout.cfg");
	localcmd("saveconfig\n");
}

void TouchMenu_Export_Click(entity me, entity other)
{
	TouchMenu_WriteLayoutFile("touch_export.cfg");
}

void TouchMenu_Import_Click(entity me, entity other)
{
	TouchMenu_WriteLayoutFile("touch.layout.bak");
	localcmd("exec touch.layout.cfg\nmenu_cmd sync\n");
}

void TouchMenu_ResetPreset_Click(entity me, entity other)
{
	localcmd(strcat("exec touch/profiles/", cvar_string("touch_preset"), ".cfg\nmenu_cmd sync\n"));
}

entity makeXonoticTouchSettingsTab()
{
	entity me = NEW(XonoticTouchSettingsTab);
	me.configureDialog(me);
	return me;
}

void XonoticTouchSettingsTab_fill(entity me)
{
	entity e;

	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticHeaderLabel(_("Preset")));
	me.TR(me);
		me.TD(me, 1, 2, e = makeXonoticCommandButton(_("Standard"), '0 0 0', "exec touch/profiles/standard.cfg; menu_cmd sync", 0));
		me.TD(me, 1, 1, e = makeXonoticCommandButton(_("Casual"), '0 0 0', "exec touch/profiles/casual.cfg; menu_cmd sync", 0));
	me.TR(me);
		me.TD(me, 1, 2, e = makeXonoticCommandButton(_("Competitive"), '0 0 0', "exec touch/profiles/competitive.cfg; menu_cmd sync", 0));
		me.TD(me, 1, 1, e = makeXonoticCommandButton(_("Left hand"), '0 0 0', "exec touch/profiles/left.cfg; menu_cmd sync", 0));
	me.TR(me);
		me.TD(me, 1, 2, e = makeXonoticCommandButton(_("Minimal"), '0 0 0', "exec touch/profiles/minimal.cfg; menu_cmd sync", 0));
		me.TD(me, 1, 1, e = makeXonoticButton(_("Reset preset"), '0 0 0'));
			e.onClick = TouchMenu_ResetPreset_Click;

	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticHeaderLabel(_("Look & move")));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticTextLabel(0, _("Touch sensitivity:")));
		me.TD(me, 1, 2, e = makeXonoticSlider_T(1.5, 5.0, 0.1, "touch_sens_base", _("DPI-normalized look speed")));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticTextLabel(0, _("Vertical mult:")));
		me.TD(me, 1, 2, e = makeXonoticSlider_T(0.5, 1.5, 0.05, "touch_sens_y_mult", _("Vertical look multiplier")));
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCheckBox_T(0, "touch_invert_y", _("Invert look"), string_null));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticTextLabel(0, _("Stick deadzone:")));
		me.TD(me, 1, 2, e = makeXonoticSlider_T(0, 0.35, 0.01, "touch_stick_deadzone", _("Movement stick drift prevention")));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticTextLabel(0, _("Aim assist:")));
		me.TD(me, 1, 2, e = makeXonoticMixedSlider_T("touch_aim_assist", string_null));
			e.addText(e, _("Off"), 0);
			e.addText(e, _("Light"), 1);
			e.addText(e, _("Strong"), 2);
			e.configureXonoticMixedSliderValues(e);

	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticHeaderLabel(_("Buttons & layout")));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticTextLabel(0, _("Overlay opacity:")));
		me.TD(me, 1, 2, e = makeXonoticSlider_T(0.3, 1.0, 0.05, "touch_opacity", string_null));
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCheckBox_T(0, "touch_handedness", _("Left-handed layout"), string_null));
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCheckBox_T(0, "touch_dodge_visible", _("Show dodge button"), string_null));
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCommandButton(_("Customize layout (in game)"), '0 0 0', "touch_customize 1; togglemenu 0", COMMANDBUTTON_CLOSE));

	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticHeaderLabel(_("Advanced")));
	me.TR(me);
		me.TD(me, 1, 1, e = makeXonoticButton(_("Save layout"), '0 0 0'));
			e.onClick = TouchMenu_SaveLayout_Click;
		me.TD(me, 1, 1, e = makeXonoticButton(_("Export"), '0 0 0'));
			e.onClick = TouchMenu_Export_Click;
		me.TD(me, 1, 1, e = makeXonoticButton(_("Import"), '0 0 0'));
			e.onClick = TouchMenu_Import_Click;
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCommandButton(_("Re-run touch setup"), '0 0 0', "menu_cmd directmenu TouchSetup", 0));
	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCommandButton(_("Apply & refresh menu"), '0 0 0', "menu_cmd sync", COMMANDBUTTON_APPLY));
}
