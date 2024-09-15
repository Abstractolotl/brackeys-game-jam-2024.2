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


static func interpolate(value, start_input=30, end_input=300, start_output=5, end_output=2):
	if value <= start_input:
		return start_output
	elif value >= end_input:
		return end_output
	else:
		# Linear interpolation formula
		return start_output + (end_output - start_output) * (value - start_input) / (end_input - start_input)

enum Spacing {
	EVEN,
	RANDOM,
	GROUPED,
	IN_FRONT
}
