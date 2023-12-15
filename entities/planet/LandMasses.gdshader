shader_type canvas_item;

// Config inputs
uniform vec2 starDirection = vec2( 1.0 , 1.0 );
uniform vec3 starLight : source_color = vec3( 0.0 , 0.0 , 0.0 );
uniform float starIntensity : hint_range( 0.3 , 2.0 ) = 0.5; 

uniform float seed : hint_range( 0.0 , 1.0 ) = 0.5;
uniform bool isMap = true;
uniform float rotationSpeed : hint_range( 0.0 , 1.0 ) = 0.1;
uniform float axialTilt : hint_range( 0.0 , 6.28 ) = 3.14; // 2 PI

// Geological factors
// uniform bool hasCity = false;
uniform float cityFactor : hint_range( 0.0, 1.0 ) = 0.0;

uniform bool hasCrater = false;
uniform int craterOctave : hint_range( 1, 5 ) = 1;

uniform bool hasHydro = false;
uniform float oceanDepth : hint_range( 0.0 , 0.8 ) = 0.0;
uniform vec3 oceanColor : source_color = vec3( 0.0 , 0.0 , 1.0 );
uniform vec3 iceColor : source_color = vec3( 1.0 , 1.0 , 1.0 );
uniform float iceCap : hint_range( -0.1 , 0.6 ) = 0.0;

uniform sampler2D cityMap;
uniform sampler2D heightMap;
uniform sampler2D oceanColorMap;
uniform sampler2D seedTexture;
uniform sampler2D seedBumpMap;
uniform sampler2D ridgeBumpMap;

const mat2 rot = mat2( vec2(0.6,  0.2), vec2(-0.2,  0.6 ));

/* Random Values */
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    vec2 randOffsets = vec2(sin(seed), cos(seed));
    p += randOffsets;
    return fract(sin(vec2(dot(p, vec2(12.9898, 78.233)), dot(p, vec2(93.989, 67.345)))) * 43758.5453);
}

vec2 hash2( vec2 p){
	p = vec2(dot(p, vec2(664.1, 111.7)), dot(p, vec2(969.5, 383.3)));
    vec2 randOffsets = vec2(sin(seed), cos(seed));
    p += randOffsets;
    return fract(sin(vec2(dot(p, vec2(99.4728, 14.3423)), dot(p, vec2(97.2342, 99.123)))) * 12314.2123);
}

float hashFloat(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

vec2 hashVec2( float n ){
	float sn = sin(n);
    return fract( vec2( sn , sn * 42125.13 ) );
}

vec2 g( vec2 n ) { return sin(n.x*n.y+vec2(201.1212,11.571)); } // if you want the gradients to lay on a circle
float noise(vec2 p ){
	const float kF = 4.6;  // make 6 to see worms
    
    vec2 i = floor(p);
	vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(sin(kF*dot(p,g(i+vec2(0,0)))),
               	   sin(kF*dot(p,g(i+vec2(1,0)))),f.x),
               mix(sin(kF*dot(p,g(i+vec2(0,1)))),
               	   sin(kF*dot(p,g(i+vec2(1,1)))),f.x),f.y);
}

float createrNoise( vec2 uv , int scale ){
	vec2 SIZE = vec2( 20.0, 10.0 ) * ( 1.0 / float(scale) );
	// Dealing with floating point errors. Needs to be exact to prevent seams
	SIZE.x = round( SIZE.x );
	SIZE.y = round( SIZE.y );
	
	float CRATER_SIZE = 1.2;
	float CRATER_NOISE_FACTOR = 0.4;
	
	float c = 0.0;
	
	uv = uv * SIZE;
	
	float fractX = fract(uv.x);
	float fractY = fract(uv.y);
	float floorX = floor(uv.x);
	float floorY = floor(uv.y);
	
	vec2 gid = vec2( floorX , floorY );
	vec2 tPoint = vec2( fractX , fractY );
	
	vec2 randVec = hash( gid );
	float dist = hashFloat( gid ) * CRATER_SIZE;
	float mDist = dist - distance( randVec , tPoint );
	mDist = smoothstep( 0.0 , 1.0 , mDist ); // Remove negative values
	
	float thisPixel = mDist;
	
	for( float x = -1.0; x <= 1.0; x++ ){
		for( float y = -1.0; y <= 1.0; y++ ){
			vec2 offsetId = gid + vec2( x , y );
			
			// Wrap offset values for tiling
			if( offsetId.x < 0.0 ){ offsetId.x = SIZE.x - 1.0; }
			if( offsetId.x > SIZE.x - 1.0 ){ offsetId.x = 0.0; }
			if( offsetId.y < 0.0 ){ offsetId.y = SIZE.y - 1.0; }
			if( offsetId.y > SIZE.y - 1.0 ){ offsetId.y = 0.0; }
			
			vec2 offsetRandVec = hash( offsetId );
			float offsetDist = hashFloat( offsetId ) * CRATER_SIZE;
			float offsetMDist = offsetDist - distance( offsetRandVec + vec2(x,y) , tPoint );
			offsetMDist = smoothstep( 0.0 , 1.0 ,offsetMDist );
			
			thisPixel = max( thisPixel , offsetMDist );
		}
	}
	// multiply away the negative values.
	float filter = step( 0.0 , thisPixel );
	thisPixel *= filter;
	
	return thisPixel;
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
	// Sphereiphy and store the UVs.
	vec2 ogUV = UV;
	
	vec2 sphereUV = ogUV;
	float a = 1.0;
	float mapFactor = 1.0;
	
	if( !isMap ){
		a = step(distance(vec2(0.5), ogUV), 0.496 ); // Cut available area into a circle. Cutting a bit more than 0.5 to deal with a light artifact.
		sphereUV = spherify( ogUV );
		sphereUV = rotate( sphereUV , axialTilt );
		sphereUV = sphereUV + vec2( TIME * rotationSpeed * 0.1 , 0.0 );
		sphereUV = mod( sphereUV, vec2( 2.0 , 1.0 ) );
		
		mapFactor = 0.5;
	}

	// Get Normal Textures textures and calculate my normals
	
	vec3 ridgeHeight = texture( ridgeBumpMap , sphereUV * vec2( mapFactor, 1.0 ) ).rgb;
	vec3 ridgeNormal = ridgeHeight * 2.0 - vec3(1.0) / 1.0;
	
	vec3 normHeight = texture( seedBumpMap, sphereUV * vec2( mapFactor, 1.0 ) ).rgb;
	vec3 normal = normHeight * 2.0 - vec3(1.0) / 1.0;
	
	float height = texture( seedTexture , sphereUV * vec2( mapFactor, 1.0 ) ).r;

	// Calculate craters.

	// Calculate ocean and land base-textures
	float oceanModulation = texture( oceanColorMap , sphereUV * vec2( mapFactor, 1.0 ) ).r;
	
	float crater = 0.0;
	if( hasCrater ){
		for( int x = craterOctave; x >= 0; x-- ){
			crater += createrNoise( sphereUV * vec2( mapFactor, 1.0 ) , x ) * ( 1.0 / float( craterOctave ) * 3.0 );
		}
	}
	
	// Max ridges against a very slight value - to give plains some very light texture.
	ridgeNormal = max( ridgeNormal * 0.05 , ridgeNormal * height * height * height );
	vec3 trueNormal = ridgeNormal * 0.8 + normal + crater * 0.1;

	// Subtract the craters from the height.
	// Note with greater octaves, it should contribute less to total height change
	// So craters don't flatten a planet entirely.
	height -= crater * 0.2;
	vec3 landColor = texture( heightMap , vec2( height, 0.0 ) ).rgb;
	
	// Mix the two normals, with more emphesis given to ridges on places of high height.
	// Notice we add the height to the normal. This should brighten higher areas a bit, and make real mountins pop more.
	// Ridges & height don't actually line up, and this helps that a bit.
	float lightIntensity = dot( normalize( trueNormal - crater * 0.05 ), normalize( vec3( starDirection , 0.0 ) ) );
	
	// landColor is increased in area of high light intensity, but generally decreased by ocean slightly.
	// Ocean doesn't makes sense, but the noise is very potmarky, so it's useful for giving terrain some minor variations without
	// spinning up another noise texture.
	landColor = landColor + (  lightIntensity * 0.4 );
	
	float isIceCapPixel = 0.0;
	float isWetlandsPixel = 0.0;
	float isCityPixel = 0.0;
	
	// Mixing in Ocean color.
	if(hasHydro){
		// Create an ocean color with a bit of time modulation so it looks like water
		vec3 fOceanColor = oceanColor - sin( oceanModulation * 15.0 + TIME * 0.50 ) * 0.035;
		float hDiff = height - oceanDepth;
		// -0.2 represents minimum amount of allowed land. No planet can be pure oceans.
		if( hDiff <= -0.0 ){
			landColor = fOceanColor;
		}
		
		if( iceCap > 0.0 ){
			// Iceheight is negative
			height = max( height , 0.0 );
			float iceHeight = iceCap - abs( sphereUV.y - 0.5 ) + height * 0.1 - oceanModulation * 0.05;
			vec3 fIceColor = iceColor;
			
			if( iceHeight < 0.0 ){
				float iceBlend = clamp( 0.0 , 1.0 , -iceHeight * 10.0 );
				
				landColor = mix( landColor , fIceColor , iceBlend );
				// Now reapply normals to land color
				float iceNormal = dot( normalize( ( trueNormal ) * 0.5 ) * 0.1 , normalize( vec3( starDirection , 0.0 ) ) );
				// we are subtracting normal map to give subtle illusion that 'high' terrain has shallow ( dim ) ice.
				// We exagerate the normal dramatically to give what would otherwise be a flat color some depth.
				landColor -= lightIntensity * 0.7;
				landColor -= crater * lightIntensity * 0.2;
				
				isIceCapPixel = 1.0;
			}
		}
	}
	
	//if( hasCity ){
		//if( cityFactor > 0.0 && height > oceanDepth && height <= 0.5 && isIceCapPixel == 0.0 && isWetlandsPixel == 0.0 ){
			//float citySample = texture( cityMap , mod( sphereUV * vec2( mapFactor, 1.0 ) * 1.0 , vec2( 1.0 , 1.0 ) ) ).r;
		//}
	//}

	// Now we handle lighting
	float dirLight = 0.0;
	float dist = 0.0;
	if(!isMap){
		dist = distance( ogUV , vec2( 0.5 , 0.5 ) );
		dirLight = abs( distance( (ogUV - 0.5 ) * 2.0 , starDirection ) );
		// Increase contrast on far side
		dirLight = pow(dirLight, 2.0) * 0.4;
		
		// Frensal Ring - calculate this first, relying on darkness to remove it on planets far side.
		float frensalFactor = pow( dist, 10 ) * 1000.0;
		
		// Notice we are adding height to this. High areas should get 
		// darker  slower as planet rotates, cuz they Capture the sun
		landColor = mix( landColor * starIntensity + frensalFactor * starLight * 0.5, landColor * 0.05 , smoothstep( 0.0 , 1.0 + height * 0.1 , dirLight ) );
	}
	
	COLOR.rgba = vec4( landColor , a);
}
