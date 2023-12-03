@tool
class_name HierarchyMatch
extends AbstractAtomicMatch

enum Relation {PARENT_OF, SIBLING_OF, CHILD_OF}

@export_node_path var source_path := ^""
var _source_node: Node
@export var relation: Relation = Relation.PARENT_OF

func _init():
	Data_Based_Node = false
	_preset_node_path("source_path", "_source_node")

func _get_candidates() -> Array[Node]:
	var candidates = []
	match relation:
		Relation.PARENT_OF:
			candidates = _system_node.get_children()
		Relation.SIBLING_OF:
			candidates = _system_node.get_parent().get_children()
			candidates.erase(_system_node)
		Relation.CHILD_OF:
			candidates = [_system_node.get_parent()]

	# Groups are filters, if none is provided take all candidates
	return candidates.filter(_is_in_search_groups)

func _node_satisfies_match(target_node: Node, bindings: Dictionary) -> bool:
	if _source_node == null or target_node == null:
		print_debug("Invalid node in HierarchyMatch")
		return false

	var relative_path = _source_node.get_path_to(target_node).get_concatenated_names()
	match relation:
		Relation.PARENT_OF:
			return relative_path == target_node.name
		Relation.SIBLING_OF:
			return relative_path == "../" + target_node.name
		Relation.CHILD_OF:
			return relative_path == ".."
		_:
			push_error("Invalid relation in HierarchyMatch")
			return false
