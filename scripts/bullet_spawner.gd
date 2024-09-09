extends Node2D

func spawn_bullet(bullet: Bullet):
	get_parent().add_child(bullet)
