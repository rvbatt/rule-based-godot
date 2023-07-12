@tool
class_name AreaDetectionMatch
extends AbstractMatch

@export_node_path("Area2D", "Area3D") var area_path
var _area # Area2D or Area3D
@export_group("Specific Colliders", "SC")
var SC_are_wildcard: bool = false:
	set(value):
		SC_are_wildcard = value
		notify_property_list_changed()

var SC_identifier: StringName
var SC_paths: Array[NodePath]

func _get_property_list():
	var properties = [{
		"name": "SC_are_wildcard",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "true, false"
	}]
	if SC_are_wildcard:
		properties.append(
			{
			"name": "SC_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "ID"
			}
		)
	else:
		properties.append(
			{
			"name": "SC_paths",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ARRAY_TYPE,
			"hint_string": "NodePath"
			}
		)
	return properties

func _init():
	_target_node = false

static func json_format() -> String:
	return '["Area Detection", "area_node", ?var|["colliders"]]'

func to_json_string() -> String:
	# Follows json_format
	var var_or_colliders = '?' + SC_identifier \
		if SC_are_wildcard \
		else SC_paths
	return JSON.stringify(["Area Detection", area_path, var_or_colliders])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	area_path = json_repr[1]
	if json_repr[2] is String:
		SC_are_wildcard = true
		SC_identifier = json_repr[2].trim_prefix('?')
		SC_paths = []
	else:
		SC_are_wildcard = false
		SC_identifier = ""
		SC_paths = []
		for path in json_repr[2]:
			SC_paths.append(NodePath(path))

func _node_satisfies_match(target_node: Node) -> bool:
	if _area == null: return false

	if target_node == null:
		print_debug("Invalid Area Detection node")
		return false

	if (target_node is Area2D or target_node is Area3D) and \
		_area.overlaps_area(target_node):
		return true

	if (target_node is PhysicsBody2D or target_node is PhysicsBody3D or
		target_node is TileMap or target_node is GridMap) \
		and _area.overlaps_body(target_node):
			return true

	return false

func is_satisfied(bindings: Dictionary) -> bool:
	_area = _system_node.get_node(area_path)
	if _area == null:
		print_debug("Invalid AreaDetection area")
		return false

	if SC_are_wildcard:
		var valid_candidates := []
		if bindings.has(SC_identifier):
			for collider in bindings.get(SC_identifier, []):
				if _area.overlaps_area(collider) or _area.overlaps_body(collider):
					valid_candidates.append(collider)
		else:
			valid_candidates.append_array(_area.get_overlapping_areas())
			valid_candidates.append_array(_area.get_overlapping_bodies())

		bindings[SC_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	if SC_paths.is_empty():
		return _area.has_overlapping_areas() or _area.has_overlapping_bodies()

	for collider_path in SC_paths:
		var collider = _system_node.get_node(collider_path)
		if collider == null: continue

		if (collider is Area2D or collider is Area3D) and \
			_area.overlaps_area(collider):
			return true

		if (collider is PhysicsBody2D or collider is PhysicsBody3D or 
			collider is TileMap or collider is GridMap) \
			and _area.overlaps_body(collider):
				return true

	return false
