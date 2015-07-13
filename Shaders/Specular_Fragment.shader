Shader "UnityCookie/Beginner/3 - Specular_Fragment" {
	Properties{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", Float) = 1.0
	}

	Subshader{
			Pass{
				Tags{ "LightMode" = "ForwardBase" }

				CGPROGRAM

				//pragmas
				#pragma vertex vert
				#pragma fragment frag

				//user-defined variables
				uniform half4 _Color;
				uniform half4 _SpecColor;
				uniform half _Shininess;

				//unity-defined variables
				uniform half4 _LightColor0;

				//input structs
				struct vertexInput {
					half4 vertex : POSITION;
					half3 normal : NORMAL;
				};

				struct vertexOutput {
					half4 pos : SV_POSITION;
					half4 worldPos : TEXCOORD0;
					half3 normalDir : TEXCOORD1;
				};

				//vertex function
				vertexOutput vert(vertexInput input) {
					vertexOutput output;

					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
					output.worldPos = mul(_Object2World, input.vertex);
					output.normalDir = normalize(mul(half4(input.normal, 0.0), _World2Object).xyz);

					return output;
				}

				//fragment function
				half4 frag(vertexOutput input) : COLOR {
					//lighting vectors
					half3 normalDirection = input.normalDir;
					half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.worldPos.xyz);
					half3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					half atten = 1.0;

					//lighting models
					half3 lambertian = saturate(dot(lightDirection, normalDirection));
					half3 diffuseLighting = atten * _LightColor0.xyz * lambertian;
					half3 specularLighting = atten * _SpecColor.xyz * lambertian * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
					half3 lightFinal = diffuseLighting + specularLighting + UNITY_LIGHTMODEL_AMBIENT.xyz;

					return half4(lightFinal * _Color.xyz, 1.0);
				}
				ENDCG
			}
		}
}