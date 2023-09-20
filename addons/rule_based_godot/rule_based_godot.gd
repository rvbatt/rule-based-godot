@tool
extends EditorPlugin

const BOTTOM_PANEL_PATH: String = "res://addons/rule_based_godot/interface/rules_edit_panel.tscn"
const INSPECTOR_PATH: String = "res://addons/rule_based_godot/interface/rules_inpector_plugin.gd"

var rules_edit_panel: Control
var inspector_plugin: EditorInspectorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("RuleBasedSystem", "Timer",
		preload("system/rule_based_system.gd"),
		preload("ruler_icon.png"))

	rules_edit_panel = preload(BOTTOM_PANEL_PATH).instantiate()
	var button = add_control_to_bottom_panel(rules_edit_panel, "Rules Editor")

	inspector_plugin = preload(INSPECTOR_PATH).new()
	inspector_plugin.set_rules_editor(rules_edit_panel, button)
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("RuleBasedSystem")

	remove_inspector_plugin(inspector_plugin)

	remove_control_from_bottom_panel(rules_edit_panel)
	rules_edit_panel.queue_free()
