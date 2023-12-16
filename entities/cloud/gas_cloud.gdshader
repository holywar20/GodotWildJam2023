shader_type canvas_item;

uniform vec3 color = vec3( 0.35 , 0.55 , 0.53 );
uniform int octave = 3;
uniform float fogginess = 0.25;

uniform sampler2D base_texture;

uniform float alpha = 1.0;


float rand( vec2 coord ){
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

float hash(in vec2 p, in float scale)
{
	// This is tiling part, adjusts with the scale...
	p = mod(p, scale);
	return fract(sin(dot(p, vec2(27.16898, 38.90563))) * 5151.5473453);
}

float noise(in vec2 p, in float scale )
{
	vec2 f;
	
	p *= scale;

	
	f = fract(p);		// Separate integer from fractional
    p = floor(p);
	
    f = f*f*(3.0-2.0*f);	// Cosine interpolation approximation
	
    float res = mix(mix(hash(p, 				 scale),
						hash(p + vec2(1.0, 0.0), scale), f.x),
					mix(hash(p + vec2(0.0, 1.0), scale),
						hash(p + vec2(1.0, 1.0), scale), f.x), f.y);
    return res;
}

float pNoise( vec2 coord ){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	// Find the 4 corners
	float a = rand(i);
	float b = rand(i + vec2(1.0 , 0.0) );
	float c = rand(i + vec2(0.0 , 1.0) );
	float d = rand(i + vec2(1.0 , 1.0) );
	
	vec2 cubic = f * f * (3.0 - 2.0 * f);
	
	return mix( a , b, cubic.x) + ( c - a ) * cubic.y * ( 1.0 - cubic.x ) + (d - b) * cubic.x * cubic.y;
}

float tiledFbm( vec2 coord ){
	float f = 0.0;
	float scale = 10.0;
    coord = mod( coord, scale);
	float amp   = 0.6;
	
	for (int i = 0; i < octave; i++)
	{
		f += noise(coord, scale) * amp;
		amp *= .5;
		// Scale must be multiplied by an integer value...
		scale *= 2.0;
	}
	// Clamp it just in case....
	return min(f, 1.0);
}

float fbm( vec2 coord ){
	float value = 0.0;
	float scale = 0.5;

	for(int x = 0; x < octave; x++){
		value += pNoise(coord) * scale;
		coord *= 10.5;
		scale *= 0.5;
	}
	
	return value;
}

void fragment(){
	vec2 coord = UV;
	
	vec2 motion = vec2( tiledFbm(vec2( coord.x + TIME * 0.05 , coord.y + TIME * 0.05 ) ) ) * 0.05;
	vec4 t_pixel = texture(base_texture, coord );
	
	float final = tiledFbm(coord + motion);
	
	//COLOR = vec4( color , final * fogginess * t_pixel.a * 2.0 );
	COLOR = vec4( color , final * fogginess * t_pixel.a * alpha * 2.0 );
}