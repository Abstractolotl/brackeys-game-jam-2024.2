extends Button

func _ready():
	if self.visible:
		focus_button()

func _on_visibility_changed() -> void:
	focus_button()

func focus_button():
	self.grab_focus()
