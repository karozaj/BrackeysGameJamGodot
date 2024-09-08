extends GridMap

var parent_nav_region:NavigationRegion3D

func _ready() -> void:
	if self.get_parent() is NavigationRegion3D:
		parent_nav_region=self.get_parent()
	
	parent_nav_region.bake_navigation_mesh()

func destroy_block(world_coordinate):
	print("destroy")
	var map_coordinate=local_to_map(world_coordinate)
	print(map_coordinate)
	set_cell_item(map_coordinate,-1)
	if parent_nav_region.is_baking()==false:
		parent_nav_region.bake_navigation_mesh()
	
func place_block(world_coordinate):
	
	var map_coordinate=local_to_map(world_coordinate)
	if get_cell_item_orientation(map_coordinate)==-1:
		print("place")
		print(map_coordinate)
		set_cell_item(map_coordinate,0)
		parent_nav_region.bake_navigation_mesh()

#func highlight(world_coordinate):
	#var map_coordinate=local_to_map(world_coordinate)
	#print(get_cell_item(map_coordinate))
