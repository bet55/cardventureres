extends Node2D

#слой уровня в котором находятся карты, чтобы класть последнюю карту сверху за счет перемещения ноды в дереве
func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)
	GlobalStuff.current_card_holder = self


func _on_child_entered_tree(node: Node) -> void:
	node.card_picked_up.connect(_on_card_picked_up)
	node.card_layed_down.connect(_on_card_layed_down)


func _on_child_exiting_tree(node: Node) -> void:
	node.card_picked_up.disconnect(_on_card_picked_up)
	node.card_layed_down.disconnect(_on_card_layed_down)


func _on_card_picked_up(node):
	move_child(node, get_child_count())


func _on_card_layed_down(node):
	pass
