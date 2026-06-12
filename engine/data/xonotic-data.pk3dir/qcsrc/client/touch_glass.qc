#include "touch_glass.qh"

// OpenGL glass UI — layered drawfill_builtin circles and soft highlights (CSQC → engine GL)

void Touch_Glass_FillCircleScanlines(vector center, float radius, vector tint, float alpha)
{
	if (radius < 1)
		return;
	int y;
	float half_w;
	vector rowpos, rowsize;
	for (y = -radius; y <= radius; y += 1)
	{
		half_w = sqrt(max(0, radius * radius - y * y));
		rowpos = center + eY * y - eX * half_w;
		rowsize = eX * (2 * half_w) + eY;
		drawfill_builtin(rowpos, rowsize, tint, alpha, DRAWFLAG_NORMAL);
	}
}

void Touch_Glass_DrawDisc(vector center, float radius, vector tint, float alpha)
{
	Touch_Glass_FillCircleScanlines(center, radius, tint, alpha);
}

void Touch_Glass_DrawCircle(vector center, float radius, vector tint, float alpha)
{
	// Soft outer shadow
	Touch_Glass_FillCircleScanlines(center + '1 2 0', radius + 3, TOUCH_GLASS_SHADOW, alpha * 0.18);
	// Frosted body
	Touch_Glass_FillCircleScanlines(center, radius, tint, alpha * 0.42);
	// Inner glow
	Touch_Glass_FillCircleScanlines(center, radius * 0.88, TOUCH_GLASS_HIGHLIGHT, alpha * 0.08);
}

void Touch_Glass_DrawCircleOutline(vector center, float radius, vector tint, float alpha, float thickness)
{
	int i;
	float t = max(1, thickness);
	for (i = 0; i < t; i += 1)
	{
		float r0 = radius - i * 0.5;
		float r1 = r0 - 0.6;
		if (r1 < 1)
			break;
		// ring via outer minus inner approximation: draw thin scanline ring
		int y;
		for (y = -r0; y <= r0; y += 1)
		{
			float hw0 = sqrt(max(0, r0 * r0 - y * y));
			float hw1 = sqrt(max(0, r1 * r1 - y * y));
			if (hw0 - hw1 < 0.5)
				continue;
			drawfill_builtin(center + eY * y - eX * hw0, eX * (hw0 - hw1) + eY, tint, alpha, DRAWFLAG_NORMAL);
			drawfill_builtin(center + eY * y + eX * hw1, eX * (hw0 - hw1) + eY, tint, alpha, DRAWFLAG_NORMAL);
		}
	}
}

void Touch_Glass_DrawRoundedButton(vector center, float size, vector tint, float alpha, bool pressed)
{
	float r = size * 0.5;
	vector c = center;
	if (pressed)
		c = c + '0 1 0' * 2;
	Touch_Glass_DrawCircle(c, r, tint, alpha * (pressed ? 1.15 : 1.0));
	Touch_Glass_DrawCircleOutline(c, r, TOUCH_GLASS_HIGHLIGHT, alpha * 0.35, 1.5);
	if (pressed)
		Touch_Glass_FillCircleScanlines(c, r * 0.55, TOUCH_GLASS_ACCENT, alpha * 0.12);
}

void Touch_Glass_DrawJoystickBase(vector center, float radius, float alpha)
{
	Touch_Glass_DrawCircle(center, radius, TOUCH_GLASS_TINT, alpha);
	Touch_Glass_DrawCircleOutline(center, radius, TOUCH_GLASS_HIGHLIGHT, alpha * 0.45, 2);
	// Cardinal guide ticks
	drawfill_builtin(center - eX * (radius * 0.15) - eY * 0.5, eX * (radius * 0.3) + eY, TOUCH_GLASS_HIGHLIGHT, alpha * 0.12, DRAWFLAG_NORMAL);
	drawfill_builtin(center - eY * (radius * 0.15) - eX * 0.5, eY * (radius * 0.3) + eX, TOUCH_GLASS_HIGHLIGHT, alpha * 0.12, DRAWFLAG_NORMAL);
}

void Touch_Glass_DrawJoystickKnob(vector center, float radius, vector offset, float alpha, bool active)
{
	vector knob = center + offset;
	float kr = radius * 0.38;
	vector tint = active ? TOUCH_GLASS_ACCENT : TOUCH_GLASS_TINT;
	Touch_Glass_DrawCircle(knob, kr, tint, alpha * (active ? 1.1 : 0.95));
	Touch_Glass_DrawCircleOutline(knob, kr, TOUCH_GLASS_HIGHLIGHT, alpha * 0.55, 1.5);
	if (active)
	{
		drawfill_builtin(knob - eX * (kr * 0.55) - eY * 0.5, eX * (kr * 1.1) + eY, TOUCH_GLASS_HIGHLIGHT, alpha * 0.2, DRAWFLAG_NORMAL);
		drawfill_builtin(knob - eY * (kr * 0.55) - eX * 0.5, eY * (kr * 1.1) + eX, TOUCH_GLASS_HIGHLIGHT, alpha * 0.2, DRAWFLAG_NORMAL);
	}
}
