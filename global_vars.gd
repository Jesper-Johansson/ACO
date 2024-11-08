extends Node

var CITY_SIZE: float = 50.0;
var CITY_COUNT: int = 8;
#const MAX_CITIES: int = 30;

var ANT_AMOUNT = 10;

var BASE_WEIGHT: float = 10.0
var BASE_PHEROMONE_STRENGTH: float = 5.0

var PAUSED: bool = false
var SIM_SPEED: float = 10

var PHEROMONE_DECAY = 0.4

var ACS: bool = false
var EXPLOITATION_RATE = 0.90 # q0 in ACS
var HEURISTIC_IMPORTANCE = 2.0
var INITIAL_PHEROMONES_ACS = 0.0
