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
	PIDS.P1 : {
		'gradientPath' : 'res://Assets/planets/SulfurLava.tres', # If planet, goes on landmasses. If Gas Giant, goes on Giant Atmosphere
		'textures' : {
			'ocean' : 'res://entities/planet/p1/00001_Ocean.png',
			'ridge' : 'res://entities/planet/p1/00001_Ridge.png',
			'seed' : 'res://entities/planet/p1/00001_Seed.png',
			'bump' : 'res://entities/planet/p1/00001_Bump.png'
		},
		'landMasses' : {
			'starDirection' : Vector2( -1.0 , 0.0 ),
			'starLight' : Color( 0.522, 0.173 , 0.451 ),
			'starIntensity' : 2.0,
			'rotationSpeed' : 0.1,
			'hasCraters' : true,
			'craterOctave' : 1,
			'hasHydro' : true,
			'oceanDepth' : 0,
			'oceanColor' : Color(1.7 , 0.0 , 0.0 ),
			'iceCap' : 0.0,
			'iceColor' : Color( 0 , 0 , 0 )
		},
		'atmo' : {

		},
		'gasAtmo': null
	},
	PIDS.P2 : {
		'gradientPath' : 'res://Assets/planets/MarsLike.tres',
		'textures' : {
			'ocean' : 'res://entities/planet/p2/00002_Ocean.png',
			'ridge' : 'res://entities/planet/p2/00002_Ridge.png',
			'seed' : 'res://entities/planet/p2/00002_Seed.png',
			'bump' : 'res://entities/planet/p2/00002_Bump.png'
		},
		'landMasses' : {},
		'atmo' :{},
		'gasAtmo' : null,
	},
	PIDS.P3 : {
		'gradientPath' : 'res://Assets/planets/BasicTerran.tres',
		'textures' : {
			'ocean' : 'res://entities/planet/p3/00003_Ocean.png',
			'ridge' : 'res://entities/planet/p3/00003_Ridge.png',
			'seed' : 'res://entities/planet/p3/00003_Seed.png',
			'bump' : 'res://entities/planet/p3/00003_Bump.png'
		},
		'landMasses' : {},
		'atmo' :{},
		'gasAtmo' : null,
	},
	PIDS.P4 : {
		'gradientPath' : 'res://Assets/planets/DefaultIceGiant.tres',
		'landMasses' : null,
		'atmo' : null,
		'gasAtmo' : {}
	},
	PIDS.P5 : {
		'gradientPath' : 'res://Assets/planets/DefaultGasGiant.tres',
		'landMasses' : null,
		'atmo' : null,
		'gasAtmo' : {}
	},
	PIDS.P6 : {
		'gradientPath' : 'res://Assets/planets/BasicIceGradiant.tres',
		'textures' : {
			'ocean' : 'res://entities/planet/p6/00006_Ocean.png',
			'ridge' : 'res://entities/planet/p6/00006_Ridge.png',
			'seed' : 'res://entities/planet/p6/00006_Seed.png',
			'bump' : 'res://entities/planet/p6/00006_Bump.png'
		},
		'landMasses' : {},
		'atmo' :{},
		'gasAtmo' : null,
	},
}

static func get_shader_params( pid : String ) -> Dictionary:
	return P_VARS[pid]

static func get_gradient_texture( pid : String ) -> GradientTexture1D:
	var gradient = GradientTexture1D.new()
	var heightMap = load( P_VARS[pid].gradientPath )
	print(  P_VARS[pid].gradientPath )
	gradient.set_gradient( heightMap )
	return gradient

static func get_ocean_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.ocean )

static func get_ridge_texture( pid : String ) -> Texture:
	return  load( P_VARS[pid].textures.ridge )

static func get_seed_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.seed )

static func get_bump_texture( pid : String ) -> Texture:
	return load( P_VARS[pid].textures.bump )
