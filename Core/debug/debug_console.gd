class_name DebugConsole
extends Control


const COMMAND_NAME_INDEX = 0
const COMMAND_SET_RESOURCE = "set_resource"
const CONSOLE_KEY = "`"


@onready var _console_display = $VBoxContainer/ConsoleDisplay
@onready var _command_entry = $VBoxContainer/HBoxContainer/CommandEntry


func _ready() -> void:
	EventBus.show_debug_console.connect(_on_show_debug_console)


func _on_show_debug_console() -> void:
	visible = not visible

	if visible:
		_command_entry.grab_focus()
		_set_command_entry_caret_to_end()
	else:
		if _command_entry.text.ends_with(CONSOLE_KEY):
			_command_entry.text = _command_entry.text.rstrip(CONSOLE_KEY)

		_command_entry.release_focus()


func _set_command_entry_caret_to_end() -> void:
	if not _command_entry.text.is_empty():
		_command_entry.caret_column = _command_entry.text.length()


func _on_command_entry_text_submitted(new_text: String):
	_parse_command(new_text.split(" ")) # possibly separate parsing and execution? fine as-is for now
	_update_console_display(new_text)
	_command_entry.text = ""


func _parse_command(command_details: Array) -> void:
	var command_name: String = command_details[COMMAND_NAME_INDEX]

	match command_name:
		COMMAND_SET_RESOURCE:
			if command_details.size() != 3:
				return
			EventBus.set_resource.emit(command_details[1], int(command_details[2]))


func _update_console_display(next_text: String) -> void:
	if _console_display.get_line_count() == 1:
		_console_display.insert_line_at(0, next_text)
	else:
		_console_display.insert_line_at(_console_display.get_line_count() - 1, next_text)
