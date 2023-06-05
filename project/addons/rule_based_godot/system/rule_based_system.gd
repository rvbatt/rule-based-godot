@tool
@icon("../ruler_icon.png")
extends Node

@export var rules: Array[Rule]

func _ready():
	for rule in rules:
		rule.setup(self)

func test_rules():
	for rule in rules:
		if rule.condition.is_satisfied():
			rule.trigger_actions()
			break
