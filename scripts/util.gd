class_name Util


static func find_health_component(node: Node) -> HealthComponent:
	for n in node.get_children():
		if n is HealthComponent:
			return n
	return null


static func clamped_range_mapping(value: float, min_threshold: float, max_threshold: float) -> float:
	# If value is below or at the minimum threshold, return 0
	if value <= min_threshold:
		return 0.0
	# If value is above or at the maximum threshold, return 1
	elif value >= max_threshold:
		return 1.0
	# Otherwise, map the value linearly between min_threshold and max_threshold
	else:
		return (value - min_threshold) / (max_threshold - min_threshold)

enum Spacing {
	EVEN,
	RANDOM,
	GROUPED
}
