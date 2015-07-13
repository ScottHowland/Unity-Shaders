Shader "UnityCookie/Beginner/2.1 - Lambertian_Ambient" {
	Properties{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	Subshader{
		Pass{
			Tags{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			//pragmas
			#pragma vertex vert
			#pragma fragment frag

			//user-defined variables
			uniform half4 _Color;

			//unity-defined variables
			uniform half4 _LightColor0;

			//input structs
			struct vertexInput {
				half4 vertex : POSITION;
				half3 normal : NORMAL;
			};

			struct vertexOutput {
				half4 pos : SV_POSITION;
				half4 col : COLOR;
			};

			//vertex program
			vertexOutput vert(vertexInput input){
				vertexOutput output;

				half3 normalDirection = normalize(mul(half4(input.normal, 0.0), _World2Object).xyz);
				half3 lightDirection = _WorldSpaceLightPos0.xyz;
				half atten = 1.0;

				half3 diffuseLighting = atten * _LightColor0.xyz * _Color.xyz * max(0.0, dot(normalDirection, lightDirection));
				half3 lightFinal = diffuseLighting + UNITY_LIGHTMODEL_AMBIENT.xyz;

				output.col = half4(lightFinal, 1.0);
				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

				return output;
			}

			//fragment program
			half4 frag(vertexOutput input) : COLOR{
				return input.col;
			}

			ENDCG
		}
	}
}