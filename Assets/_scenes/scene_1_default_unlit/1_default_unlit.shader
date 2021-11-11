/*
This is the default unlit shader that Unity provides for any project (plus comments I've added)
It's created via the menu (Create > Shader > Unlit Shader)
*/
Shader "Shady Lab/1: Default unlit (with texture)"
{
    // Input data
    Properties
    {
        // Mesh, lighting data are automatically supplied by Unity. They exist but aren't shown here
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // Sorting data, rendering type, etc.
        Tags
        {
            "RenderType"="Opaque"
        }
        //You can set this for different subshaders, and it'll pick whichever one fits your settings
        // i.e. Higher graphics -> higher LOD
        LOD 100

        Pass
        {
            // Adds the UnityCG.cginc library
            CGPROGRAM
            // Tells the compiler which functions are the vertex and fragment shaders
            #pragma vertex vert     // Vertex shader is vert
            #pragma fragment frag   // Fragment shader is frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata // Per-vertex mesh data (rename: MeshData)
            {
                float4 vertex : POSITION;   // Vertex position (Position data)
                float2 uv : TEXCOORD0;      // UV coordinates (UV channel 0. Can have TEXCOORD1 and so forth. No differences - they're strictly defined by the user)
                // Extra properties:
                float3 normals : NORMAL;    // Normal directions
                float4 tangent : TANGENT;   // Tangent's direction (XYZ components are tangent direction, W is the sign information)
                float4 color : COLOR;       // Vertex color (RGBA)
            };

            // Data that gets interpolated from the vertex shader to the fragment shader (rename: Interpolator)
            struct v2f
            {
                float4 vertex : SV_POSITION; // Clip space position 
                float2 uv : TEXCOORD0;       // Does not refer to UV channel
                UNITY_FOG_COORDS(1)          // Fog related code
            };

            sampler2D _MainTex; // Represents the _MainTex property (defined above)
            float4 _MainTex_ST; // Contains texture data (x,y: texture scale; z,w: translation/offset)

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // Converts local space to clip space (Multiplies by the MVP matrix)
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);      // Takes the UV of the vertex and the tilting and offset of the shader to ensure that the scaling and offset settings in the shader are correct
                UNITY_TRANSFER_FOG(o,o.vertex);            // Fog related things
                return o;
            }

            // To understand fixed4, we must understand the following shader types:
            // bool                     (value either 0 or 1)
            // int                      (usually converted to float)
            // float                    (32 bit float)    - Works well for world space things
            // half                     (16 bit float)    - Usually best of both worlds; best for mobile
            // fixed                    (lower precision) - only useful between -1 to 1
            // float4, half4, fixed4    (like
            // float3, half3, fixed3
            // float4x4, half4x4
            /* swizzling:
                float4 myValue;
                float2 otherValue1 = myValue.xy;
                float2 otherValue2 = myValue.yx;
                float2 otherValue3 = myValue.rg;
             */
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}