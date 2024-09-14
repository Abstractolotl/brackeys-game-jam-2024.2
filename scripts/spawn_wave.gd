extends Resource
class_name SpawnWave



@export var amount_min: int = 1
@export var amount_max: int = 1

@export var spacing: Util.Spacing = Util.Spacing.RANDOM

@export var enemy: PackedScene = preload("res://entities/enemy.tscn")

@export var min_wave: int = 0
@export var max_wave: int = -1

@export var weight: int = 1
