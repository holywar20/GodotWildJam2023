shader_type canvas_item;

uniform vec2 starDirection = vec2( 1.0 , 1.0 );
uniform vec3 starLight : source_color = vec3( 0.0 , 0.0 , 0.0 ); // Not Implimented
uniform float starIntensity : hint_range( 0.1 , 2.0 ) = 0.5;     // Not Implimented

uniform float seed : hint_range( 0.0 , 1.0 ) = 0.5;
uniform float axialTilt : hint_range( 0.0 , 6.28 ) = 3.14; // 2 PI
uniform float rotationSpeed : hint_range (0.0 , 4.0 ) = 1.0;
uniform float tSpeed : hint_range(0.1, 1.0) = 0.2;

uniform bool isMap = false;

uniform sampler2D colorBands;

const mat2 M = mat2( vec2(1.6,  1.2), vec2(-1.2,  1.6 ) );

vec2 hashVec2Vec2( vec2 p ) {
	p = vec2(dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)));
	return -1.0 + 2.0*fract( sin(p) * 43758.5453123 + seed );
}

vec2 hashFloatVec2( float n ){
	float sn = sin(n);
    return fract( vec2( sn , sn * 42125.13 * seed ) );
}

float hash( float n ){ return fract(sin(n)*43758.5453); }
float noise2( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

// Noise from here https://www.shadertoy.com/view/4tdSWr
float noise( in vec2 p ) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;
	vec2 i = floor(p + (p.x+p.y)*K1);	
    vec2 a = p - i + (i.x+i.y)*K2;
    vec2 o = (a.x>a.y) ? vec2(1.0,0.0) : vec2(0.0,1.0); //vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
    vec2 b = a - o + K2;
	vec2 c = a - 1.0 + 2.0*K2;
    vec3 h = max(0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	vec3 n = h*h*h*h*vec3( dot(a,hashVec2Vec2(i+0.0)), dot(b,hashVec2Vec2(i+o)), dot(c,hashVec2Vec2(i+1.0)));
    return dot(n, vec3(70.0));	
}

vec2 g( vec2 n ) { return sin(n.x*n.y+vec2(201.1212,11.571)); } // if you want the gradients to lay on a circle
float wNoise(vec2 p)
{
    const float kF = 2.0;  // make 6 to see worms
    
    vec2 i = floor(p);
	vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(sin(kF*dot(p,g(i+vec2(0,0)))),
               	   sin(kF*dot(p,g(i+vec2(1,0)))),f.x),
               mix(sin(kF*dot(p,g(i+vec2(0,1)))),
               	   sin(kF*dot(p,g(i+vec2(1,1)))),f.x),f.y);
}


// Smooth Noise 
float random(float x) {return fract(sin(x) * 10000.);}
float rNoise(vec2 p) {return random(p.x + p.y * 10000.);}
vec2 sw(vec2 p) { return vec2(floor(p.x), floor(p.y)); }
vec2 se(vec2 p) { return vec2(ceil(p.x), floor(p.y)); }
vec2 nw(vec2 p) { return vec2(floor(p.x), ceil(p.y)); }
vec2 ne(vec2 p) { return vec2(ceil(p.x), ceil(p.y)); }
float smoothNoise(vec2 p) {
	vec2 interp = smoothstep(0., 1., fract(p));
    float s = mix(rNoise(sw(p)), rNoise(se(p)), interp.x);
    float n = mix(rNoise(nw(p)), rNoise(ne(p)), interp.x);
    return mix(s, n, interp.y);
}

float warpedNoise(vec2 p) { 
    vec2 m = vec2( sin(TIME*0.05), cos(TIME*0.05) );
    float x = smoothNoise(p + m);
    float y = smoothNoise(p + m.yx + x);
    float z = smoothNoise(p - m - x + y);
    return smoothNoise(p + vec2(x, y) + vec2(y, z) + vec2(z, x) + length(vec3(x, y, z))*0.25);
    
}

vec2 spherify(vec2 uv) {
	vec2 centered = uv *2.0-1.0;
	float z = sqrt(1.0 - dot(centered.xy, centered.xy));
	vec2 sphere = centered/(z + 1.0);
	
	return sphere * 0.5+0.5;
}

vec2 rotate(vec2 coord, float angle){
	coord -= 0.5;
	coord *= mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
	return coord + 0.5;
}

void fragment() {
	vec2 ogUV = UV;
	vec2 sphereUV = vec2( 0.0 ,0.0 );
	float a = 0.0;
	
	if( !isMap ){
		a = step(distance(vec2(0.5), UV ), 0.496 ); // Cut available area into a circle. Cutting a bit more than 0.5 to deal with a light artifact.
		sphereUV = spherify( ogUV );
		sphereUV = rotate( sphereUV , axialTilt );
		
		float baseRotation = TIME * rotationSpeed * 0.1;
		sphereUV.x = sphereUV.x + baseRotation;
	}
	
	float flowDirection = sin( sphereUV.y * 5.0 );
	//\flowDirection = smoothstep( -1.0 , 1.0 , flowDirection );
	
	float cloudMotion1 = warpedNoise( sphereUV * vec2( 1.0 , 3.0 ) * 20.0 + vec2( TIME * tSpeed * 0.5, 0.0 ) ) * 0.005;
	float cloudMotion2 = warpedNoise( sphereUV * vec2( 1.0 , 3.0 ) * 20.0 + vec2( TIME * tSpeed * 10.0, 0.0 ) ) * 0.005 * flowDirection * 2.0;
	
	// Band color starts a simple 1 to 1 match before fancy math
	float bandColor = sphereUV.y + cloudMotion1 + cloudMotion2;
	
	vec3 color = texture( colorBands , vec2( bandColor  , 0.0 ) ).rgb;
	
	float mixNoise = noise( sphereUV * 1.0 + vec2( TIME * tSpeed * 1.0 , 0.0 ) );
	float highClouds = mix( cloudMotion1, cloudMotion2 , mixNoise );
	//color -= cloudMotion2;
	//color -= cloudMotion1;
	
	color = mix( color , vec3( 0.0 ), highClouds * 10.0 ) + smoothNoise( vec2( cloudMotion1 , cloudMotion2 ) ) * 100.0;
	
	COLOR = vec4( color , a );
}


