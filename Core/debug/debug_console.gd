class_name DebugConsole
extends Control


const COMMAND_NAME_INDEX = 0
const COMMAND_SET_RESOURCE = "set_resource"


@onready var _console_display = $VBoxContainer/ConsoleDisplay
@onready var _command_entry = $VBoxContainer/HBoxContainer/CommandEntry


var _command_regex = RegEx.new()


func _ready() -> void:
	EventBus.show_debug_console.connect(_on_show_debug_console)


func _on_show_debug_console() -> void:
	_command_entry.grab_focus()
	visible = not visible


func _on_command_entry_text_submitted(new_text: String):
	var command_entry_split = new_text.split(" ")

	# TODO: Parse/process the command in a separate method. Just need something quick and dirty.
	# Also need to do some basic error handling.
	if command_entry_split[COMMAND_NAME_INDEX] == COMMAND_SET_RESOURCE:
		EventBus.set_resource.emit(command_entry_split[1], int(command_entry_split[2]))
	
	_command_entry.text = ""

	if _console_display.get_line_count() == 1:
		_console_display.insert_line_at(0, new_text)
	else:
		_console_display.insert_line_at(_console_display.get_line_count() - 1, new_text)


func _parse_command(command: String) -> void:
	pass
