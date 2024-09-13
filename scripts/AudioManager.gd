extends Node

# Function to set the volume of a bus by name
func set_bus_volume(bus_name: String, volume_db: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, volume_db)
	else:
		print("Bus not found: " + bus_name)

# Function to get the volume of a bus by name
func get_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		return AudioServer.get_bus_volume_db(bus_index)
	else:
		print("Bus not found: " + bus_name)
		return 0

# Function to mute or unmute a bus by name
func set_bus_mute(bus_name: String, mute: bool):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_mute(bus_index, mute)
	else:
		print("Bus not found: " + bus_name)

# Function to play a sound on a specific bus
func play_sound(audio_stream: AudioStream, bus_name: String, volume_db: float = 0, loop: bool = false) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.volume_db = volume_db
	player.stream = audio_stream
	
	# Set the player to use the specified bus
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		player.bus = bus_name
	else:
		print("Bus not found: " + bus_name)
		return null
	
	# Add the player to the scene tree and play the sound
	add_child(player)
	player.play()

	# Connect the finished signal to remove the player after the sound finishes
	if loop:
		player.connect("finished", Callable(self, "_on_sound_loop").bind(player))
	else:
		player.connect("finished", Callable(self, "_on_sound_finished").bind(player))
	
	return player

# Function to clean up finished sound players
func _on_sound_finished(player: AudioStreamPlayer):
	if is_instance_valid(player):
		player.queue_free()
		
func _on_sound_loop(player: AudioStreamPlayer):
	if is_instance_valid(player):
		player.play()
		
func _ready() -> void:
	set_bus_volume("Effects", -10)
