shader_type canvas_item;

// Config inputs
uniform vec2 starDirection = vec2( 1.0 , 1.0 );
uniform vec3 starLight : source_color = vec3( 0.0 , 0.0 , 0.0 ); // Not Implimented
uniform float starIntensity : hint_range( 0.0 , 2.0 ) = 0.5;     // Not Implimented

uniform float seed : hint_range( 0.0 , 1.0 ) = 0.5;
uniform float axialTilt : hint_range( 0.0 , 6.28 ) = 3.14; // 2 PI
uniform float tSpeed : hint_range(0.1, 1.0) = 0.2;

uniform float cloudDensity : hint_range( 0.0 , 5.0 );
uniform float banding : hint_range( 1.0 , 5.0 ) = 1.0;
uniform int turbulence : hint_range( 0 , 20 ) = 3;
uniform sampler2D cloudColors;

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
    const float kF = 6.0;  // make 6 to see worms
    
    vec2 i = floor(p);
	vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(sin(kF*dot(p,g(i+vec2(0,0)))),
               	   sin(kF*dot(p,g(i+vec2(1,0)))),f.x),
               mix(sin(kF*dot(p,g(i+vec2(0,1)))),
               	   sin(kF*dot(p,g(i+vec2(1,1)))),f.x),f.y);
}

// Basic Nois
float rand(vec2 coord) {
	coord = mod( coord, vec2(1.0,1.0)*round( 3.0 ) );
	return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 1511.5453 * seed);
}

float bNoise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float circleNoise(vec2 uv) {
    float uv_y = floor(uv.y);
    uv.x += uv_y*.31;
    vec2 f = fract(uv);
	float h = rand(vec2(floor(uv.x),floor(uv_y)));
    float m = (length(f-0.25-(h*0.5)));
    float r = h*0.25;
    return smoothstep(0.0, r  , m*0.75);
}

float bFbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < 6; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.65;
	}
	return value;
}

float cloud_alpha(vec2 uv) {
	float c_noise = 0.0;
	
	// more iterations for more turbulence
	for (int i = 0; i < turbulence; i++) {
		c_noise += circleNoise( ( uv * 1.0 ) + (float(i)+100.) + (vec2(TIME * tSpeed * 0.3, 0.0)));
	}
	float fbm = bFbm( uv * 6.0 + c_noise * 0.3 + vec2( TIME * tSpeed * 0.5 , 0.0 ) );
	
	return fbm;//step(a_cutoff, fbm);
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

float cloudFbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 6; i++) {
		total += noise(n + TIME * 0.1 ) * amplitude;
		n = M * n;
		amplitude *= 0.35;
	}
	return total;
}

float cloudPattern( vec2 coord ){
	return 0.0;
}

// Utility and Geography
vec2 rotate(vec2 coord, float angle){
	coord -= 0.5;
	coord *= mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
	return coord + 0.5;
}

vec2 spherify(vec2 uv) {
	vec2 centered= uv *2.0-1.0;
	float z = sqrt(1.0 - dot(centered.xy, centered.xy));
	vec2 sphere = centered/(z + 1.0);
	return sphere * 0.5+0.5;
}

void fragment() {
	vec2 ogUV = UV;
	float a = step(distance(vec2(0.5), ogUV), 0.496 ); // Cut available area into a circle. Cutting a bit more than 0.5 to deal with a light artifact.
	
	vec2 uv = rotate( UV , axialTilt );
	vec2 sphereUV = spherify( uv ) * vec2( 1.0 , banding ) + vec2( TIME * tSpeed * 0.01 ,0.0 );
	// Add a cloud curve
	// Hard coded to remove a weird curve we don't want.
	//sphereUV.y += smoothstep(0.0, 2.0 , abs(uv.x - 0.4 ) );
	
	// Figure out base height of the clouds
	
	float secondaryHeight = wNoise( sphereUV * 5.0 + vec2( TIME * tSpeed *  0.4 , 0.0 ) ) * 0.5;
	float baseHeight = bFbm( sphereUV * 3.5 + vec2( TIME * tSpeed * 0.7 , 0.0 ) + secondaryHeight * 0.1 ) * 1.0;
	float trails = bFbm( sphereUV * 3.5 + vec2( TIME * tSpeed * 0.7 , 0.0 ) + secondaryHeight ) * 1.0;
	float mergedCHeight = baseHeight + secondaryHeight + trails * 0.1;
	
	// Figure out my Alpha value and cross multiply with height to make it a bit more realistic, 
	// and to give it a tiny bit of a liquid character
	float baseAlpha = cloud_alpha( sphereUV * vec2(1.0, banding ) + vec2( mergedCHeight * 0.04 , 0.0 ) ) + mergedCHeight * 1.0;
	
	// Now determine my color
	vec3 cloudColor = texture( cloudColors , vec2( mergedCHeight, 0.0 ) ).rgb + baseAlpha * 0.1;
	
	// Handle directional lighting
	float dirLight = abs( distance( (ogUV - 0.5 ) * 2.0 , starDirection ) );
	dirLight = pow(dirLight, 2.0) * 0.15;
	
	vec2 p = -0.5 + ogUV;
	float dist = length( p );
	vec3 fresnal = starLight * 55.0 * dist * dist * dist * dist * dist * dist;
	
	float lightMixFactor = smoothstep( 0.85 , 0.0 , dirLight );
	cloudColor = mix( cloudColor * 0.05 , cloudColor * starIntensity + fresnal  , lightMixFactor );
	a *= mix( baseAlpha * 0.05 , ( baseAlpha + mergedCHeight ) * cloudDensity + cloudDensity , lightMixFactor + 0.1 );
	// Dist is less than 1, but approaches 1 as it gets to the edge.
	// Multiplying it by itself will cause edges to move towards 1, while center stays close to zero and in fact gets smaller.
	
	
	
	COLOR = vec4( cloudColor, a );
}
