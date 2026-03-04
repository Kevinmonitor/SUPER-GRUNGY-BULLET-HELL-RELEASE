technique render
{
    pass P0
    {
        VertexShader = compile vs_3_0 vertex();
        PixelShader = compile ps_3_0 fragment();
    }
}