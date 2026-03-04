#include "./_begin.hlsl"

struct vOutEx
{
	float4 position : POSITION;
	float4 diffuse : COLOR0;
	float2 texCoord : TEXCOORD0;

	float2 ratio : TEXCOORD1;
	float2 scale : TEXCOORD2;

	float number : DEPTH;
};

vOutEx vertex(vIn v_)
{
	vOutEx v;

	int rectAdd = (round(v_.i_z_ang_extra.y) - 1) * (v_.texCoord.x != 0);
	float ratio = v_.i_z_ang_extra.z / v_.i_z_ang_extra.w;

	v_.position.x += rectAdd * v_.i_z_ang_extra.z;
	v_.texCoord.x += rectAdd * ratio;

	v.diffuse = v_.diffuse * v_.i_color;
	v.texCoord = v_.texCoord;
	v.position = mul(mul(v_.position, imat(v_)), g_mWorldViewProj);

	v.position.z = 1.0f;

	v.ratio = float2(ratio, rcp(ratio));

	v.number = v_.i_xyz_pos_x_scale.z;
	v.scale = v_.i_yz_scale_xy_ang.y;

	return v;
}

float4 fragment(vOutEx v_) : COLOR0
{
    int number = round(v_.number);
    int ghost = v_.texCoord.x * v_.ratio.y;

    for (int i = 0; i < ghost; i++)
    {
    	number /= 8;
    }

    v_.texCoord.x += ((number % 8) - ghost) * v_.ratio.x;

    return tex2D(sampler0_, v_.texCoord) * v_.diffuse;
}

#include "./_end.hlsl"