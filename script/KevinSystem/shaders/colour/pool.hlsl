#include "./_begin.hlsl"

vInOut vertex(vInOut v_)
{    
    v_.diffuse *= g_vColor;

    v_.position = mul(v_.position, g_mWorld);
    v_.position = mul(v_.position, g_mViewProj);
    v_.position.z = 1.0f;

    return v_;
}

float4 fragment(vInOut v_) : COLOR0
{
	float4 color = tex2D(sampler0_, v_.texCoord);

    float3 monochrome = lerp(color.ggg, color.rrr, v_.diffuse.r);

    lib_Hueshift(color.rgb, v_.diffuse.rg);

    color.rgb = lerp(color.rgb, monochrome, v_.diffuse.b);

    color.a *= v_.diffuse.a;

    return color;
}

#include "./_end.hlsl"