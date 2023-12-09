shader_type canvas_item;

uniform sampler2D gradient;

uniform float rotationSpeed : hint_range( 0.1 , 1.0 ) = 0.1;

// Controls the cells and the layers
uniform float cellSize : hint_range( 5.0, 55.0 , 0.1 ) = 5.0;
uniform float wormCellSize : hint_range( 0.1 , 10.0 , 0.1 ) = 1.0;

uniform float vorCellSize : hint_range( 0.1 , 10.0 , 0.1 ) = 1.0;

uniform float convectionSpeed : hint_range( 0.1 , 5.0 , 0.1 ) = 1.0;
uniform float stretchFactor : hint_range( 0.1 , 5.0 ) = 1.8;
uniform float starSeed : hint_range( 0.1 , 10.0 ) = 1.0;
uniform float flowFactor : hint_range (0.01 , 1.0 , .01 ) = 0.1;

// If numbers get super big, you'll get banding. Best to keep coordinates very small for use of this function.
vec2 rand_vec_2( vec2 coord ) {	
	// prevents randomness decreasing from coordinates too large
	coord = mod(coord, 100.0);
	// returns "random" vec2 with x and y between 0 and 1
    return fract(sin( vec2( dot(coord,vec2(127.1,311.7)), dot(coord,vec2(269.5,183.3)) ) ) * 143758.5453 * starSeed);
}


float vornoi_noise( vec2 coord ){
	vec2 i = floor( coord );
	vec2 f = fract( coord );
	
	// Check the space around the chosen coordinate
	// Note this will check inside 9 squares
	
	float minDist = 2.0;
	for( float x = -1.0; x <= 1.0; x++){
		for( float y = -1.0; y <= 1.0; y++){
			// Generate a random point within that square.
			vec2 node = rand_vec_2( i + vec2( x, y )) + vec2(x , y );		
			// Now we get the distance between that point and the current point
			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y );
			minDist = min( minDist, dist );
		}
	}
	return minDist;
}

float rand(vec2 coord){
	// prevents randomness decreasing from coordinates too large
	coord = mod( coord, 100.0 );
		// returns "random" vec2 with x and y between 0 and 1
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.545312 * starSeed);
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

vec2 gradn(vec2 p)
{
	float ep = .09;
	float gradx = noise(vec2(p.x+ep,p.y))-noise(vec2(p.x-ep,p.y));
	float grady = noise(vec2(p.x,p.y+ep))-noise(vec2(p.x,p.y-ep));
	return vec2(gradx,grady);
}

mat2 makem2( in float theta ){
	float c = cos(theta);
	float s = sin(theta);
	return mat2(vec2(c,-s),vec2(s,c));
}

float wormNoise(vec2 p){
	// Create a very slow extra rotation in the wormy bits
    const float kF = 3.0;  // make 6 to see worms
    
    vec2 i = floor(p);
	vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(sin(kF*dot(p,rand_vec_2(i+vec2(0,0)))),
               	   sin(kF*dot(p,rand_vec_2(i+vec2(1,0)))),f.x),
               mix(sin(kF*dot(p,rand_vec_2(i+vec2(0,1)))),
               	   sin(kF*dot(p,rand_vec_2(i+vec2(1,1)))),f.x),f.y);
}

float vornoiFbm( vec2 coord ){
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 0.5;
	
	normalize_factor += scale;
	value += vornoi_noise( coord ) * scale;
	coord *= 2.0;
	scale *= 0.5;
	
	normalize_factor += scale;
	value += vornoi_noise( coord ) * scale;
	coord *= 2.0;
	scale *= 0.5;
	
	normalize_factor += scale;
	value += vornoi_noise( coord ) * scale;
	coord *= 2.0;
	scale *= 0.5;
	
	normalize_factor += scale;
	value += vornoi_noise( coord ) * scale;
	coord *= 2.0;
	scale *= 0.5;
	
	
	return value / normalize_factor;
}

float flow(in vec2 p){
	float z=2.;
	float rz = 0.;
	vec2 bp = p;
	
	float time = TIME * -flowFactor;
	
	for (float i= 1.;i < 6.0;i++ )
	{
		//primary flow speed
		p += vec2( time * 0.1 , 0 );
		
		//secondary flow speed (speed of the perceived flow)
		bp += time * 0.1;
		
		//bp += vec2( bp.x * time * 2.0  , bp.y );
		
		//displacement field (try changing time multiplier)
		vec2 gr = gradn(i*p*0.4+time * convectionSpeed );
		
		//rotation of the displacement field
		gr *= makem2( time * 10.0 -(0.1*p.x+0.03*p.y) *40. );
		
		//displace the system
		p += vec2( gr.x , gr.y );
		
		//add noise octave
		rz+= (cos(noise(p)* 7.0)*0.5+0.5)/z;
		
		//blend factor (blending displaced system with base system)
		//you could call this advection factor (.5 being low, .95 being high)
		p = mix(bp,p,.77);
		
		//intensity scaling
		z *= 1.4;
		//octave scaling
		p *= 2.;
		bp *= 1.9;
	}
	return rz;	
}

float movingVornoi( vec2 uv ){
	
	float m = 0.0;
	float minDist = 100.0;
	float t = TIME * convectionSpeed;
	vec2 pos = vec2(0);
	
	vec2 grid = uv * 5.0;
	vec2 gridUv = fract(grid) - 0.5;
	vec2 id = floor(grid);
	
	for( float y = -1.0; y<=1.0; y++ ){
		for( float x = -1.0; x <= 1.0; x++){
			vec2 offset = vec2( x , y );
			vec2 r = rand_vec_2( id + offset );
			float randOffset = rand( id + offset );
			
			// Adding R again here to prevent a display error when T is near zero.
			pos = offset + sin( r * t + randOffset ) * 0.5;
			// Euclidian ( As the bird flies ) Distance
			float ed = distance( gridUv + r * 0.1 , pos );
			
			// Manhatten Distance - Creates a weird crystalized effect
			//pos -= gridUv;
			//float md = abs( pos.x ) + abs( pos.y );
			
			//float d = mix( ed , md , 0.0 );
			float d = ed;
			
			if( d < minDist ){
				minDist = d;
			}
		}
	} 
	
	return minDist;
}

float noise2(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

float wormFbm( vec2 coord ){
	int OCTAVES = 4;
	
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 0.5;
	
	for(int i = 0; i < OCTAVES; i++){
		
		normalize_factor += scale;
		value += wormNoise( coord ) * scale;
 
		coord *= 2.5;
		scale *= 0.6;
	}
	
	return value / normalize_factor;
}

float wormPattern( vec2 p ){
	return wormFbm( p + noise( p + noise( p * 2.0 ) * 1.5 ) );
}

void fragment(){
	float a = 0.0;
	
	// Making time smaller to make the time based transitions nicer
	float time	= TIME * 0.1;
	vec2 uv = UV * 1.0;
	float radius	= 0.248;
	float invRadius = 1.0 / radius;

	// Center the area first.
	vec2 p = -0.5 + uv;
	
	// Calculate this pixel's distance from center.
	float dist = length( p );
	vec3 starSphere = vec3( 0.0 );
	
	// Spherize the UVs
	vec2 sp = -1.0 + 2.0 * uv;
	sp *= ( 2.0 );
	float r = dot(sp,sp);
	float f = (1.0-sqrt(abs(1.0-r)))/(r);
	
	vec2 newUv = vec2(sp.x * f , sp.y * f);
	vec4 starSurface = vec4( 0 , 0 , 0, 0 );
	
	if( dist <= radius ){
		// # UV Rotation
		float offset = time * rotationSpeed;
		vec2 starUV = newUv + vec2( offset , 0.0 );
		// Adding 0.5 on the X axis to deal with an equtorial
		starUV.y *= stretchFactor;
		starUV *= cellSize;

		//float flow = flow( starUV );
		float flowyness = flow( starUV * wormCellSize ) * 0.9;
		float wormyness = wormPattern( starUV * wormCellSize ) * 0.9;
		wormyness = clamp( 0.0, 1.0 , wormyness);
		float noisyness = vornoiFbm( uv * 20.0 ) * 0.5;
		
		float vFbm = movingVornoi( starUV * vorCellSize + noisyness ) + 0.5;
		
		// Now cross mix all the surfaces so transitions aren't so jarring
		noisyness = mix( wormyness , noisyness , flowyness + vFbm ) - noisyness;
		wormyness = mix( noisyness , wormyness , flowyness + vFbm ) + vFbm * 0.2;
		
		float tOffset = noise2( sin( cos( TIME * starUV * 0.01 ) * starUV * 0.01 ) ) * 0.2;
		float surface = mix( wormyness , mix( flowyness, noisyness , wormyness ), flowyness + tOffset );
		//float surface = wFbm;
		
		//float wNoise = waveletNoise( starUV, time , 0.1 );
		vec4 baseTint = texture( gradient  , vec2( surface , 0.0 ) );

		starSphere = baseTint.rgb;
		a = 1.0;
	} else {
		discard;
	}
	
	// Calculate edge darking & multiply the brightness a bit.
	vec4 limbDarkening = vec4( 0 , 0 , 0 , 1 ) * dist * dist;
	
	vec3 color = mix( starSphere , limbDarkening.rgb , limbDarkening.a );
	
	COLOR = vec4( color , a );
}
