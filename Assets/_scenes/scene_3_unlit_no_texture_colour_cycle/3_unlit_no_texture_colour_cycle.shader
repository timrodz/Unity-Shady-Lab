// Draws an unlit texture with cycling colours
Shader "Shady Lab/3: Unlit (no texture), colour cycle"
{
    Properties
    {
        _Value("Value", Float) = 1.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            float _Value;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                //float2 uv : TEXCOORD0;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            float4 frag (Interpolators i) : SV_Target {
                // float4: r,g,b,a
                float time = _Time * 10;
                float channelSin = sin(time);
                float channelCos = cos(time);
                float channelTan = tan(time);
                return float4(
                    channelSin,    // Red channel
                    channelCos,    // Green channel
                    channelTan,    // Blue channel
                    1);             // Alpha channel
            }
            ENDCG
        }
    }
}