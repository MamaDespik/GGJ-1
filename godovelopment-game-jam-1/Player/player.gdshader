shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform bool active;
uniform bool cloaked;
uniform sampler2D cloak_noise: repeat_enable;
uniform float cloak_strength: hint_range(-1.,1.) = .1;
void fragment() {
	vec4 t = texture(TEXTURE, UV);
	if (active){
		if (t.a != 0.0){
			t.a = sin(TIME*15.0)/2.0 + 0.5;
		}
	}
	if (cloaked){
		vec4 noise = texture(cloak_noise, UV);
		vec4 screen_color = texture(screen_texture, SCREEN_UV + (noise.r*cloak_strength));
		t.rgb = screen_color.rgb;
	}
    COLOR = t; // Preserve the alpha value from the texture
}