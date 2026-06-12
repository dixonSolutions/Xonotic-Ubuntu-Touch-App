#include "touch_look.qh"

float touch_look_smooth_dx[4];
float touch_look_smooth_dy[4];
int touch_look_smooth_idx;

void Touch_Look_Reset(void)
{
	int i;
	for (i = 0; i < 4; ++i)
	{
		touch_look_smooth_dx[i] = 0;
		touch_look_smooth_dy[i] = 0;
	}
	touch_look_smooth_idx = 0;
}

void Touch_Look_ApplyDelta(float dx, float dy)
{
	float dead = autocvar_touch_look_deadzone_px;
	if (fabs(dx) < dead)
		dx = 0;
	if (fabs(dy) < dead)
		dy = 0;
	if (!dx && !dy)
		return;

	int smooth = autocvar_touch_look_smoothing;
	if (smooth > 0)
	{
		touch_look_smooth_dx[touch_look_smooth_idx & 3] = dx;
		touch_look_smooth_dy[touch_look_smooth_idx & 3] = dy;
		touch_look_smooth_idx += 1;
		float sdx = 0, sdy = 0;
		int n = min(smooth + 1, 4);
		int i;
		for (i = 0; i < n; ++i)
		{
			sdx += touch_look_smooth_dx[i];
			sdy += touch_look_smooth_dy[i];
		}
		dx = sdx / n;
		dy = sdy / n;
	}

	float dpi = max(160, cvar("vid_touchscreen_xdpi"));
	float sens = autocvar_touch_sens_base * (320.0 / dpi);
	float yaw = dx * sens * 0.022;
	float pitch = dy * sens * 0.022 * autocvar_touch_sens_y_mult;
	if (autocvar_touch_invert_y)
		pitch = -pitch;

	if (autocvar_touch_aim_assist > 0)
	{
		float pull = 0.002 * autocvar_touch_aim_assist;
		yaw *= (1.0 - pull);
		pitch *= (1.0 - pull);
	}

	vector ang = getpropertyvec(VF_CL_VIEWANGLES);
	ang.y -= yaw;
	ang.x += pitch;
	ang.x = bound(-89, ang.x, 89);
	setproperty(VF_CL_VIEWANGLES, ang);
}

void Touch_Look_Frame(void)
{
	// per-frame hook reserved for gyro / aim assist extensions
}
