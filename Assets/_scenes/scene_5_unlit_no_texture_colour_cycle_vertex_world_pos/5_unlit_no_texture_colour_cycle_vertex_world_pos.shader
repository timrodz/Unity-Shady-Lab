// Draws an unlit texture with cycling colours multiplied by the Y-position
Shader "Shady Lab/5: Unlit (no texture), colour cycle multiplied by Y-world position"
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
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            float4 frag (Interpolators i) : SV_Target {
                // float4: r,g,b,a
                float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
                float time = _Time * 10;
                float channelSin = sin(worldPos.x);
                float channelCos = cos(worldPos.y);
                float channelTan = tan(worldPos.z);
                return float4(
                    channelSin,    // Red channel
                    channelCos,    // Green channel
                    channelTan,    // Blue channel
                    1              // Alpha channel
                );             
            }
            ENDCG
        }
    }
}