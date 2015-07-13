Shader "UnityCookie/Beginner/2- Lambertian" {
	Properties {
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	
	Subshader {
		Pass {
			Tags{
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			//pragmas
			#pragma vertex vert
			#pragma fragment frag


			//user-defined variables
			uniform half4 _Color; //Editor-defined color

			//unity-defined variables
			uniform half4 _LightColor0; //Color of the light 

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

				half3 normalDirection = normalize(mul(half4(input.normal, 0.0), _World2Object).xyz); //Convert normals to object space
				half3 lightDirection = _WorldSpaceLightPos0.xyz;
				float atten = 1.0;

				half3 diffuseLighting = atten * _LightColor0.xyz * _Color.xyz * max(0.0, dot(normalDirection, lightDirection));

				output.col = half4(diffuseLighting, 1.0);
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
	//Fallback "Diffuse"
}