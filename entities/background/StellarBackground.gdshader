shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture , filter_linear_mipmap;

uniform int layers = 4;
uniform vec2 posOffset = vec2( 0 , 0 );

float hash21( vec2 id ){
   id = fract( id * vec2( 123.34 , 456.21 ) );
   id += dot( id , id + 45.321);
   return fract( id.x * id.y );
}
 
mat2 rotate( float a ){
    // Takes an angle in Radians
    float s = sin(a);
    float c = cos(a);
    
    // Returns a 2d Rotation Matrix
    return mat2( vec2( c, -s ), vec2(s , c) );
}
 
float star( vec2 uv , float flare , float rand ){
    // Simulating a light like shape
    float d = length(uv);
    float starLight = 0.02/d;
 
    vec2 rotUv = uv * rotate( 3.1415 / 4.0 );
    float rotRays = max( 0.0 , 1.0 - abs( rotUv.x * rotUv.y * 1000.0 ) ) * 0.05 * flare;
    
    float allLight =  starLight + rotRays;
    
    allLight *= smoothstep( 0.3 , 0.2 , d );
    return max( allLight , 0.0 );
}

vec3 starLayer( vec2 uv , float layerSeed ){
    vec2 id = floor(uv);
    vec2 gv = fract(uv);
    
    vec3 col = vec3( 0 );
    
    for( float y=-1.0; y<=1.0; y++ ) {
        for( float x=-1.0; x<=1.0; x++ ) {
            vec2 offset = vec2(x , y);
            vec2 thisId = offset + id;
            
            float starRand = hash21( thisId + layerSeed );
            float size = fract(starRand *405.32 );
            vec2 starPos = gv - offset - vec2( sin(starRand * 12.3423) * 0.5 + 0.5 , fract( starRand * 90.123 ) ) + 0.5;
            
            float thisStar = star( starPos , smoothstep( .9 , 1.0, 1.0 ) , starRand  );
            
            vec3 color = sin( vec3(0.6 , 0.3 , 0.9) * fract( starRand * 2342.2 ) * 123.2 ) * 0.5 + 0.5;
            color = max( color, vec3( 0.4 , 1.0 , 0.4 ) );
            
            color *= vec3(1.0 , 0.6 , 1.0 + size );
            
            col += thisStar * size * color;
        }
    }
    
    return col;
}
 
void fragment()
{
    // Center UV coordinate
    vec2 uv = UV - 0.5;
    float t = TIME * 0.5;
    
    float distFade = 1.0;
    vec3 col = vec3( 0 );
    for( float x = 0.0; x<1.0; x += 1.0 / float(layers) ){
        float depth = fract( x );
        float fade = depth;
        float scale = mix( 30.0 , 10.0 , depth );
		float layerRand = hash21( vec2(scale , depth) ) ;
        col += starLayer( uv * scale + posOffset , layerRand ) * fade;
    }
	float totCol = ( col.r + col.b + col.g );
	vec3 screenCol = texture( SCREEN_TEXTURE, uv ).rgb;
	vec3 finalCol = mix( screenCol , col , totCol );
    COLOR = vec4( col, ( col.r + col.b + col.g ) * 0.33 );
}
