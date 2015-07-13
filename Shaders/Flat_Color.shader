Shader "UnityCookie/Beginner/1 - Flat_Color" {
	Properties { //Properties that can be interacted with in the Unity editor
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	Subshader { //Subshader designed to run on a particular platform
		Pass { //Defines a single pass
			CGPROGRAM //CG Code goes here
			//pragmas
			#pragma vertex vert
			#pragma fragment frag
				
			//user-defined variables
			uniform half4 _Color;
			
			//input structs
			struct vertexInput { //Assigns values from the object in the GPU to in-shader variables
				half4 vertex : POSITION; //Grabs position from the GPU's model
			};

			struct vertexOutput { //Assigned variables will be returned to Unity to aid rendering
				half4 pos : SV_POSITION; //will write pos into SV_POSITION
			};
			
			//vertex function
			vertexOutput vert(vertexInput input) {
				vertexOutput output;

				//UNITY_MATRIX_MVP = Model View Projection Matrix
				//Multiply the vertex position into ViewSpace so it can be rendered
				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

				return output;
			}

			//fragment function
			half4 frag(vertexOutput input) : COLOR {
				return _Color; //Every pixel will have its color defined by the editor-defined color
			}
			ENDCG
		}
	}
	Fallback "Diffuse" //In case something breaks
}