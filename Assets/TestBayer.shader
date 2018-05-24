// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestBayer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		DitherRange ("float", float) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
            #pragma target 3.0
			
			#include "UnityCG.cginc"
			#include "BayerDither.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float depth : TEXCOORD1;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v, out float4 outpos : SV_POSITION)
			{
				v2f o;
				float4 pos = UnityObjectToClipPos(v.vertex);
				COMPUTE_EYEDEPTH(o.depth);
				#if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3)
				o.depth = 1 - o.depth; 
				#endif
				outpos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{
				ClipByBayerDither(i.depth, screenPos);
				fixed4 col = tex2D(_MainTex, i.uv);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
