extends Node
var score = 0
var eScore = 0
var time_format = 0
var time_bonus = 0
var base_score = 600

var music_sound = -2
var effect_sound = -7

var timeState = "day"

# why would we do that?! because this engine isn't python or other better!
var inventory = [[0,0,0]] # index 0,0 = wood , index 0,1 = stone , index 0,2 = rope
var inventory_chest = [[0,0,0]] # index 0,0 = wood , index 0,1 = stone , index 0,2 = rope

# tools
var hasPickaxe = false
var hasAxe = false
var hasShear = false

# enemy list
var list_enemy1 = []
var list_enemy2 = []
var list_enemy3 = []
# house position
var house_position = [0,0]

var health = 3

var openChestMenu = false
