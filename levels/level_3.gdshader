shader_type canvas_item;

uniform float move_speed = 0.04;

void fragment() {
	COLOR = texture(TEXTURE,vec2(UV.x + TIME * move_speed, UV.y));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
