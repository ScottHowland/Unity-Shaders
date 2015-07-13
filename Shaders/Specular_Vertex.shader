Shader "UnityCookie/Beginner/3 - Specular_Vertex" {
	Properties{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", Float) = 1.0
	}

	Subshader{
			Pass{
				Tags{ "LightMode" = "ForwardBase" }

				CGPROGRAM

				//Pragmas
				#pragma vertex vert
				#pragma fragment frag

				//User-defined variables
				uniform half4 _Color;
				uniform half4 _SpecColor;
				uniform float _Shininess;

				//Unity-defined variables
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

				//vertex function
				vertexOutput vert(vertexInput input) {
					vertexOutput output;

					//Vectors
					half4 worldPos = mul(_Object2World, input.vertex);
					half3 normalDirection = normalize(mul(half4(input.normal, 0.0), _World2Object).xyz);
					half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
					half3 lightDirection = _WorldSpaceLightPos0.xyz;
					half atten = 1.0;

					//Lighting Models
					half3 lambertianModel = saturate(dot(lightDirection, normalDirection));
					half3 diffuseLighting = atten * _LightColor0.xyz * lambertianModel;
					half3 specularLighting = atten * _SpecColor.xyz * lambertianModel * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
					half3 lightFinal = diffuseLighting + specularLighting + UNITY_LIGHTMODEL_AMBIENT.xyz;
						
					output.col = half4(lightFinal * _Color.xyz, 1.0);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

					return output;
				}

				//fragment function
				half4 frag(vertexOutput input) : COLOR {
					return input.col;
				}

				ENDCG
			}
		}
}