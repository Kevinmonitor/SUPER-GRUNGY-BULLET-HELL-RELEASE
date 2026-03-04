static const float3 RCPSQRT3 = (float3)(rsqrt(3.0f));

void lib_Grayscale(inout float3 rgb_, float x_, float normalize_ = rcp(3.0f))
{
	rgb_ = saturate(lerp(rgb_, (rgb_.r + rgb_.g + rgb_.b) * normalize_, x_));
}

void lib_Hueshift(inout float3 rgb_, float2 hue_)
{
	hue_ = hue_ * 2.0f - 1.0f;
	rgb_ = rgb_ * hue_.y + cross(RCPSQRT3, rgb_) * hue_.x + RCPSQRT3 * dot(RCPSQRT3, rgb_) * (1.0f - hue_.y);
}

void lib_BCLight(inout float3 rgb_, float bc_)
{
    rgb_ *= bc_;
    rgb_ += 1.0f - bc_;
}

void lib_Sepia(inout float3 rgb_, float x_, float normalize_ = rcp(3.0f))
{
	float gray = saturate((rgb_.r + rgb_.g + rgb_.b) * normalize_);
	float3 sepia = lerp(float3(0.15f, 0.0f, 0.25f), float3(1.0f, 1.0f, 0.8f), gray);
	rgb_ = lerp(rgb_, sepia, x_);
}

float3 lib_RGBtoHSV(float3 color_)
{
	float value = max(color_.r, max(color_.g, color_.b));

	float minv = min(color_.r, min(color_.g, color_.b));
	float delta = value - minv;

	float saturation = (value > 0.01f) ? (delta / value) : 0.0f;

	float hue = 0.0f;

	if (delta < 0.01f) return float3(hue, saturation, value);

	if (value == color_.r) hue = fmod((color_.g - color_.b) / delta, 6.0f);
	else if (value == color_.g) hue = 2.0f + (color_.b - color_.r) / delta;
	else hue = 4.0f + (color_.r - color_.g) / delta;

	return float3(hue / 6.0f, saturation, value);
}

float3 lib_HSVtoRGB(float3 hsv_)
{
	return lerp(1.0f, saturate(3.0f * abs(1.0f - 2.0f * frac(hsv_.r + float3(1.0f, -1.0f / 3.0f, 1.0f / 3.0f)))
		- 1.0f), hsv_.g) * hsv_.b;
}