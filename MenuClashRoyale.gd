extends Control


onready var scroller : ScrollContainer = $VBoxContainer/ScrollContainer
onready var animation_tree : AnimationTree = $AnimationTree
var is_scrolling : bool = false
var is_manual_scrolling : bool = false
var scroll_to : float = 0
var scroll_to_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree(), "idle_frame")
	scroller.scroll_horizontal = rect_size.x * 2
	pass # Replace with function body.

func _on_ScrollContainer_scroll_started() -> void:
	is_scrolling = true
	set_process(true)


func _on_ScrollContainer_scroll_ended() -> void:
	is_scrolling = false

func _process(delta: float) -> void:
	
	if is_manual_scrolling:
		if abs(int(round(scroll_to))-scroller.scroll_horizontal) > 5:
			animation_tree["parameters/blend_position"] = lerp(animation_tree["parameters/blend_position"],int(round(scroll_to/rect_size.x)),0.1)
			scroller.scroll_horizontal = lerp(scroller.scroll_horizontal,scroll_to, 0.2)
		else:
			animation_tree["parameters/blend_position"] = scroll_to_index
			scroller.scroll_horizontal = scroll_to
			is_manual_scrolling = false
			set_process(false)
	else:
		var scroll = scroller.scroll_horizontal/rect_size.x
		
		if is_scrolling:
			animation_tree["parameters/blend_position"] = scroll
		elif abs(int(round(scroll))-scroll) > 0.01:
			animation_tree["parameters/blend_position"] = lerp(animation_tree["parameters/blend_position"],int(round(scroll)),0.1)
			scroller.scroll_horizontal = lerp(scroller.scroll_horizontal,rect_size.x * int(round(scroll)), 0.2)
		else:
			animation_tree["parameters/blend_position"] = int(round(scroll))
			scroller.scroll_horizontal = rect_size.x * int(round(scroll))
			set_process(false)
		

func _on_Button_pressed(extra_arg_0: int) -> void:
	scroll_to = (rect_size.x * extra_arg_0)
	scroll_to_index = extra_arg_0
	is_manual_scrolling = true
	set_process(true)
	pass # Replace with function body.
