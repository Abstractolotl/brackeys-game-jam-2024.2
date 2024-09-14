extends Resource
class_name DropPool

@export var drops: Array[Drop]

func drop_from_pool() -> Drop:
	if drops.size() == 0:
		return
		
	var total_weight = 0.0
	for drop in drops:
		total_weight += drop.weight

	var random = randf() * total_weight

	var current_weight = 0.0
	for drop in drops:
		current_weight += drop.weight
		if random <= current_weight:
			return drop

	return null
