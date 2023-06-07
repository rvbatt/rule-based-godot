@icon("../ruler_icon.png")
extends Node

@export_enum("First Applicable", "Least Recently Used")
var rule_arbitration: String = "First Applicable":
	set(arbitration):
		_set_arbiter(arbitration)
		rule_arbitration = arbitration
	get:
		return rule_arbitration

@export var rules: Array[Rule]

var _arbiter: AbstractArbiter

func _ready():
	_set_arbiter(rule_arbitration)
	for rule in rules:
		rule.setup(self)

func test_rules():
	var satified_rules: Array[Rule] = []
	for rule in rules:
		if rule.condition.is_satisfied():
			satified_rules.append(rule)

	if not satified_rules.is_empty():
		_arbiter.select_rule_to_trigger(satified_rules).trigger_actions()

func _set_arbiter(arbitration: StringName):
	match arbitration:
		"First Applicable":
			_arbiter = FirstApplicableArbiter.new()
		"Least Recently Used":
			_arbiter = LeastRecentlyUsedArbiter.new()
