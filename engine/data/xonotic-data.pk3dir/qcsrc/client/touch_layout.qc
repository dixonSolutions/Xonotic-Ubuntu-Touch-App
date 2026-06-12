#include "touch_layout.qh"

float Touch_ScreenMin(void)
{
	vector vf = getpropertyvec(VF_SIZE);
	return min(vf.x, vf.y);
}

float Touch_WidgetScale(void)
{
	float density = max(1, cvar("vid_touchscreen_density"));
	return autocvar_touch_scale * density * autocvar_touch_hud_scale;
}

float Touch_MirrorX(float nx, float nsize)
{
	if (!autocvar_touch_handedness)
		return nx;
	return 1.0 - nx - nsize;
}

vector Touch_WidgetCenter(float nx, float ny, float nsize)
{
	vector vf = getpropertyvec(VF_SIZE);
	float mx = Touch_MirrorX(nx, nsize);
	return mx * vf.x * eX + ny * vf.y * eY + eZ * (Touch_ScreenMin() * nsize * 0.5);
}

float Touch_WidgetRadius(float nsize)
{
	return Touch_ScreenMin() * nsize * 0.5 * Touch_WidgetScale();
}

bool Touch_PointInCircle(vector p, vector center, float radius)
{
	vector d = p - center;
	d.z = 0;
	return vlen(d) <= radius;
}

bool Touch_PointInNormRect(vector p, float nx, float ny, float nsize)
{
	vector vf = getpropertyvec(VF_SIZE);
	float mx = Touch_MirrorX(nx, nsize);
	float x0 = mx * vf.x;
	float y0 = ny * vf.y;
	float s = Touch_ScreenMin() * nsize * Touch_WidgetScale();
	return p.x >= x0 - s * 0.5 && p.x <= x0 + s * 0.5
		&& p.y >= y0 - s * 0.5 && p.y <= y0 + s * 0.5;
}

bool Touch_InEdgeDeadzone(vector p)
{
	vector vf = getpropertyvec(VF_SIZE);
	float dz = autocvar_touch_edge_deadzone_px;
	return p.x < dz || p.y < dz || p.x > vf.x - dz || p.y > vf.y - dz;
}

bool Touch_InLookZone(vector p)
{
	vector vf = getpropertyvec(VF_SIZE);
	float left = autocvar_touch_look_zone_left * vf.x;
	float right = autocvar_touch_look_zone_right * vf.x;
	if (autocvar_touch_handedness)
	{
		float t = 1.0 - right;
		right = 1.0 - left;
		left = t;
		left *= vf.x;
		right *= vf.x;
	}
	return p.x >= left && p.x <= right;
}

bool Touch_WidgetVisible(float nx, float ny)
{
	return nx > 0.001 && ny > 0.001;
}
