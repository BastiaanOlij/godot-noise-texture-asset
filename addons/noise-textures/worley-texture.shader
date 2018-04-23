shader_type canvas_item;
render_mode unshaded;

uniform float max_z = 1.0;
uniform float max_distance = 0.5;
uniform sampler2D worley_points;
uniform int number_of_points = 0;

float worley_distance(vec3 point, vec3 worley_point, float p_max) {
	float value = p_max;
	
	for (float z = -1.0; z < 1.1; z += 1.0) {
		for (float y = -1.0; y < 1.1; y += 1.0) {
			for (float x = -1.0; x < 1.1; x += 1.0) {
				vec3 delta = worley_point - point + vec3(x,y,z);
				float distance = length(delta);
				if (distance < value) {
					value = distance;
				}
			}
		}
	}
	
	return value;
}

float worley_value(vec3 pos) {
	float value = max_distance;
	vec3 fpos = mod(pos, 1.0);
	
	if (number_of_points == 0) {
		// just some test data
		value = worley_distance(fpos, vec3(0.2, 0.5, 0.1), value);
		value = worley_distance(fpos, vec3(0.8, 0.3, 0.4), value);
		value = worley_distance(fpos, vec3(0.4, 0.7, 0.3), value);
		value = worley_distance(fpos, vec3(0.6, 0.4, 0.2), value);
		value = worley_distance(fpos, vec3(0.1, 0.9, 0.5), value);
		value = worley_distance(fpos, vec3(0.8, 0.2, 0.4), value);
	} else {
		for (int p = 0; p < number_of_points; p++) {
			float x = float(p) / float(number_of_points);
			vec3 wp = texture(worley_points, vec2(x, 0.0)).rgb;
			value = worley_distance(fpos, wp, value);
		}
		
	}
	
	
	return clamp(value / max_distance, 0.0, 1.0);
}

void fragment() {
	float z = floor(UV.y * max_z);
	float y = (UV.y * max_z) - z;
	vec3 pos = vec3(UV.x, y, z / max_z);
	vec4 result = vec4(0.0, 0.0, 0.0, 1.0);

	result.r = worley_value(pos);
	result.g = worley_value(pos * 2.0);
	result.b = worley_value(pos * 4.0);
	
	COLOR = result;
}