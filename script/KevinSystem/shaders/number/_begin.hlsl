#include "./_lib.hlsl"

struct vIn
{
    float4 position : POSITION;
    float4 diffuse : COLOR0;
    float2 texCoord : TEXCOORD0;
    
    float4 i_color : COLOR1;
    float4 i_xyz_pos_x_scale : TEXCOORD1;
    float4 i_yz_scale_xy_ang : TEXCOORD2;
    float4 i_z_ang_extra : TEXCOORD3;
};

struct vOut
{
    float4 position : POSITION;
    float4 diffuse : COLOR0;
    float2 texCoord : TEXCOORD0;
};

sampler sampler0_ : register(s0);

float4x4 g_mWorldViewProj : WORLDVIEWPROJ : register(c0);

float4x4 imat(vIn v_)
{
    float3 t_scale = float3(v_.i_xyz_pos_x_scale.w, v_.i_yz_scale_xy_ang.xy);
    
    float2 ax; sincos(v_.i_yz_scale_xy_ang.z, ax.x, ax.y);
    float2 ay; sincos(v_.i_yz_scale_xy_ang.w, ay.x, ay.y);
    float2 az; sincos(v_.i_z_ang_extra.x, az.x, az.y);

    return float4x4(
        float4(
            t_scale.x * (ay.y * az.y - ax.x * ay.x * az.x),
            t_scale.x * (-ax.y * az.x),
            t_scale.x * (ay.x * az.y + ax.x * ay.y * az.x),
            0.0f
        ),
        float4(
            t_scale.y * (ay.y * az.x + ax.x * ay.x * az.y),
            t_scale.y * (ax.y * az.y),
            t_scale.y * (ay.x * az.x - ax.x * ay.y * az.y),
            0.0f
        ),
        float4(
            t_scale.z * (-ax.y * ay.x),
            t_scale.z * (ax.x),
            t_scale.z * (ax.y * ay.y),
            0.0f
        ),
        float4(
            v_.i_xyz_pos_x_scale.x,
            v_.i_xyz_pos_x_scale.y,
            v_.i_xyz_pos_x_scale.z,
            1.0f
        )
    );
}