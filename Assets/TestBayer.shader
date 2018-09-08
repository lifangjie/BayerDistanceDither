Shader "Custom/TestBayer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		_DisappearRange ("Disappear Range", float) = 2
		_DisappearDistance ("Disappear Distance", float) = 2
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
				float disappearAlpha : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
            uniform float _DisappearRange;
            uniform float _DisappearDistance;

			v2f vert (appdata v, out float4 pos : SV_POSITION)
			{
				v2f o;
				pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				float viewDistance = length(mul(unity_ObjectToWorld, v.vertex).xyz - _WorldSpaceCameraPos);
				o.disappearAlpha = saturate((_DisappearDistance - viewDistance) * _DisappearRange);
				return o;
			}
			
			fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				ClipByBayerDither(i.disappearAlpha, screenPos);
				return col;
			}
			ENDCG
		}
	}
}
