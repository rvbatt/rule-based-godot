extends Node2D

func _on_line_edit_text_submitted(_new_text):
	$RuleBasedSystem.test_rules()
