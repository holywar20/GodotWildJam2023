shader_type canvas_item;

uniform vec3 color : source_color = vec3( 0.8, 0.65, 0.3 );
uniform float colorBalance : hint_range( 0.1 , 0.9 ) = 0.1;
uniform float timeFactor : hint_range( 0.01 , 1.00 , 0.01 ) = 0.1;

// Deals with primary corona shape
uniform float flareAmount : hint_range( 10 , 50.0 , 1.0 ) = 10.0; // Must be integer value, causes shader to crystalize without.
uniform float size : hint_range( 1.0 , 5.0 , 0.1 ) = 1.0;
uniform float spiky : hint_range( 0.1 , 50.0 , 0.1 ) = 50.0;
uniform float gas : hint_range( 0.1 , 5.0  , 0.1 ) = 1.0; 
uniform float starSeed : hint_range( 0.1 , 10.0 )  = 1.0;

// If numbers get super big, you'll get banding. Best to keep coordinates very small for use of this function.
float rand(vec2 coord){
	// prevents randomness decreasing from coordinates too large
	coord = mod( coord, 10000.0 );
		// returns "random" vec2 with x and y between 0 and 1
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453 * starSeed);
}

float snoise(vec3 uv, float res)
{
	const vec3 s = vec3(1e0, 1e2, 1e3);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      	  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-1)*1e3);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-1.;
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
		
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

vec2 spherify(vec2 uv) {
	vec2 centered = uv *2.0-1.0;
	float z = sqrt(1.0 - dot(centered.xy, centered.xy));
	vec2 sphere = centered/(z + 1.0);
	
	return sphere * 0.5+0.5;
}

float ring( vec2 uv ){
    float r = 0.125;   								// radius
    float dr = 0.01; 								// delta radius (thickness)
    						
    float d = length(uv);							// distance of this pixel from origin
    float c = smoothstep(0.0, dr / 2.0, abs(d - r)); 	// ring parameters
    return c;
	
	// To invert, call like float glow = 1.0 - ring( UV - vec2(0.5) );
}



void fragment(){
	float a = 0.0;
	float time		= TIME * timeFactor;
	
	// Always white. This is meant to be the center color each column.
	vec3 coronaColor = vec3( 1.0 , 1.0 , 1.0 );
	
	vec2 uv = spherify( UV );
	vec2 p = uv - 0.50;
	
	float dist = length(p);
	float radius = 0.0625;// Hardcoded to match the edge of the star.
	float angle		= atan( p.x, p.y ) / 6.2832;
	
	// Provides a semi-random gradiant varient, that when it gets very large rapidly accelerates parts of the corona
	float reverberationNoise =  noise( sin( uv + -time * 0.05 + angle) ) * 0.0;

	// vec3 ( rotation , zoom )
	// Use of negative time noise will make it appear to 'push' stuff out.
	vec3 coord = vec3( 0 , length(p)*.4, .5) * spiky;
	vec3 cFlow = vec3( -angle * 1.0 , -time * 0.1 + reverberationNoise , -time * 0.1 + reverberationNoise );
	
	// Controls flow direction and speed
	float coronaTiming	= abs(snoise( cFlow + coord * 0.07, flareAmount ) ) * gas;
	float coronaTiming2 = abs(snoise( cFlow + coord * 0.03, flareAmount ) ) * gas;
	float corona	= pow(1.0 - ( coronaTiming * 0.1 + coronaTiming2 * 0.3 ), 6.0 );
	corona			-= abs(dist * 1.0 - radius ) * size * 10.0; // Trim both in the negative and positive direction, the amount of glow
	
	coronaColor.rgb = mix( color.rgb , coronaColor.rgb, colorBalance );
	float glow = ( 1.0 - ring( ( UV - vec2(0.5) ) ) ) * 0.5;
	
	a = clamp( corona + glow  , 0.0 , 1.0 ) - radius / 1.0;
	COLOR = vec4( coronaColor + (coronaColor * glow ) , a );
}
