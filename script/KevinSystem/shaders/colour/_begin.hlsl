#include "./_lib.hlsl"

struct vInOut
{
    float4 position : POSITION;
    float4 diffuse : COLOR0;
    float2 texCoord : TEXCOORD0;
};

sampler sampler0_ : register(s0);

float4x4 g_mWorld : WORLD : register(c0);
float4x4 g_mViewProj : VIEWPROJECTION : register(c4);
float4 g_vColor : ICOLOR : register(c9);