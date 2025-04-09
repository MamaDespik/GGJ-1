shader_type canvas_item;

uniform bool active;

void fragment() {
	if (active){
	vec4 t = texture(TEXTURE, UV);
	if (t.a != 0.0){ 
		t.a = sin(TIME*15.0)/2.0 + 0.5;
		//t.a = .75;
	}
    COLOR = t; // Preserve the alpha value from the texture
	}
}