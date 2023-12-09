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
		'texture_path_frag' : "0001",
	},
	PIDS.P2 : {
		'texture_path_frag' : "0002",
	},
	PIDS.P3 : {
		'texture_path_frag' : "0003",
	},
	PIDS.P4 : {
		'texture_path_frag' : "0004",
	},
	PIDS.P5 : {
		'texture_path_frag' : "0005",
	},
	PIDS.P6 : {
		'texture_path_frag' : "0006",
	},
}

const OCEAN_PATH = "res://entities/planet/p1/%s_Ocean.png"
const RIDGE_PATH = "res://entities/planet/p1/%s_Ridge.png"
const SEED_PATH = "res://entities/planet/p1/%s_Seed.png"
const BUMP_PATH = "res://entities/planet/p1/%s_Bump.png"

static func get_ocean_texture( pid : String ) -> Texture:
	return ResourceLoader.load( OCEAN_PATH % P_VARS[pid].texture_path_frag )

static func get_ridge_texture( pid : String ) -> Texture:
	return ResourceLoader.load( RIDGE_PATH % pid )

static func get_seed_texture( pid : String ) -> Texture:
	return ResourceLoader.load( SEED_PATH % pid )

static func get_bump_texture( pid : String ) -> Texture:
	return ResourceLoader.load( BUMP_PATH % pid )
