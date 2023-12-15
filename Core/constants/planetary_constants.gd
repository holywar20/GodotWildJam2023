extends Resource
class_name PlanetaryConstants

const PIDS = {
	"P1" : "P1",
	"P2" : "P2",
	"P3" : "P3",
	"P4" : "P4",
	"P5" : "P5",
	"P6" : "P6"
}

const P_VARS = {
	# Ocean should grow as temp increases
	# Atmosphere should disappear as temp increases
	PIDS.P1 : {
		'gradientPath' : 'res://Assets/planets/SulfurLava.tres', # If planet, goes on landmasses. If Gas Giant, goes on Giant Atmosphere
		'cloudGradientPath' : 'res://entities/planet/p1/cloudgradient.tres',
		'textures' : {
			'ocean' : 'res://entities/planet/p1/00001_Ocean.png',
			'ridge' : 'res://entities/planet/p1/00001_Ridge.png',
			'seed' : 'res://entities/planet/p1/00001_Seed.png',
			'bump' : 'res://entities/planet/p1/00001_Bump.png'
		},
		'landMasses' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'rotationSpeed' : 0.15,
			'hasCrater' : true,
			'craterOctave' : 1,
			'hasHydro' : true,
			'oceanDepth' : 0.1,
			'oceanColor' : Color(1.7 , 0.0 , 0.0 ),
			'iceCap' : -0.1,
			'iceColor' : Color( 0 , 0 , 0 )
		},
		'atmo' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'seed' : 0.453,
			'tSpeed' : 0.1,
			'cloudDensity' : 0.404,
			'banding' : 1.59,
		},
		'gasAtmo': null
	},
	PIDS.P2 : {
		'gradientPath' : 'res://Assets/planets/BasicTerran.tres',
		'cloudGradientPath' : null,
		'textures' : {
			'ocean' : 'res://entities/planet/p2/00002_Ocean.png',
			'ridge' : 'res://entities/planet/p2/00002_Ridge.png',
			'seed' : 'res://entities/planet/p2/00002_Seed.png',
			'bump' : 'res://entities/planet/p2/00002_Bump.png'
		},
			'landMasses' : {
				'starDirection' : Vector2( -1.0 , 0.0 ),
				'starLight' : Color( 0.522, 0.173 , 0.451 ),
				'starIntensity' : 0.5,
				'rotationSpeed' : 0.152,
				'hasCrater' : false,
				'craterOctave' : 1,
				'hasHydro' : true,
				'oceanDepth' : .523,
				'oceanColor' : Color( 0.059 , 0.115 , 1.0 ),
				'iceCap' : -0.1,
				'iceColor' : Color( 0.675 , 1 , 1 )
			},
			'atmo' :{
				'starDirection' : Vector2( -1.0 , 0.0 ),
				'starLight' : Color( 0.522, 0.173 , 0.451 ),
				'starIntensity' : 0.6,
				'seed' : 0.111,
				'tSpeed' : 0.1,
				'cloudDensity' : 0.594,
				'banding' : 1.0,
			},
			'gasAtmo' : {},
		},
	PIDS.P3 : {
		'gradientPath' : 'res://Assets/planets/MarsLike.tres',
		'cloudGradientPath' : 'res://entities/planet/p1/cloudgradient.tres',
		'textures' : {
			'ocean' : 'res://entities/planet/p3/00003_Ocean.png',
			'ridge' : 'res://entities/planet/p3/00003_Ridge.png',
			'seed' : 'res://entities/planet/p3/00003_Seed.png',
			'bump' : 'res://entities/planet/p3/00003_Bump.png'
		},
		'landMasses' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'rotationSpeed' : 0.05,
			'hasCrater' : true,
			'craterOctave' : 3,
			'hasHydro' : true,
			'oceanDepth' : 0.0,
			'oceanColor' : Color(1.0 , 1.0 , 1.0 ),
			'iceCap' : .109,
			'iceColor' : Color( 1.0 , 1.0 , 1.0 )
		},
		'atmo' :{
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'seed' : 0.453,
			'tSpeed' : 0.1,
			'cloudDensity' : 0.0,
			'banding' : 0.0,
		},
		'gasAtmo' : null,
	},
	PIDS.P4 : {
		'gradientPath' : null,
		'cloudGradientPath' : 'res://Assets/planets/DefaultGasGiant.tres' ,
		'landMasses' : null,
		'atmo' : null,
		'gasAtmo' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.1,
			'seed' : 0.123,
			'rotationSpeed' : 0.1,
			'tSpeed' : 0.118
		}
	},
	PIDS.P5 : {
		'gradientPath' : null,
		'cloudGradientPath' : 'res://Assets/planets/DefaultIceGiant.tres' ,
		'landMasses' : null,
		'atmo' : null,
		'gasAtmo' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.1,
			'seed' : 0.123,
			'rotationSpeed' : 0.1,
			'tSpeed' : 0.118
		}
	},
	PIDS.P6 : {
		'gradientPath' : 'res://Assets/planets/BasicIceGradiant.tres',
		'cloudGradientPath' : null ,
		'textures' : {
			'ocean' : 'res://entities/planet/p6/00006_Ocean.png',
			'ridge' : 'res://entities/planet/p6/00006_Ridge.png',
			'seed' : 'res://entities/planet/p6/00006_Seed.png',
			'bump' : 'res://entities/planet/p6/00006_Bump.png'
		},
		'landMasses' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'rotationSpeed' : 0.152,
			'hasCrater' : true,
			'craterOctave' : 2,
			'hasHydro' : true,
			'oceanDepth' : .313,
			'oceanColor' : Color( 1.0 , 1.0 , 1.0 ),
			'iceCap' : 0.069,
			'iceColor' : Color( 0.675 , 1 , 1 )
		},
		'atmo' :{
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 0.5,
			'seed' : 0.453,
			'tSpeed' : 0.1,
			'cloudDensity' : 0.0,
			'banding' : 0.0,
		},
		'gasAtmo' : null,
	},
}

static func get_shader_params( pid : String ) -> Dictionary:
	return P_VARS[pid]

static func get_gradient_texture( pid : String ) -> GradientTexture1D:
	var gradient = GradientTexture1D.new()
	var heightMap = load( P_VARS[pid].gradientPath )
	gradient.set_gradient( heightMap )
	return gradient

static func get_cloud_gradient( pid : String ):
	var gradient = GradientTexture1D.new()

	var path = P_VARS[pid].cloudGradientPath
	
	if( path != null ):
		var heightMap = load( P_VARS[pid].cloudGradientPath )
		gradient.set_gradient( heightMap )
		return gradient

	return null

static func get_ocean_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.ocean )

static func get_ridge_texture( pid : String ) -> Texture:
	return  load( P_VARS[pid].textures.ridge )

static func get_seed_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.seed )

static func get_bump_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.bump )
