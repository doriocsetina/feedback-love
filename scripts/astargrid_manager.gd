extends Node

class_name AStarManager

var astar_grid: AStarGrid2D = AStarGrid2D.new()

func initialize(obstacles: TileMapLayer):
    astar_grid.region = obstacles.get_used_rect()
    print("gridsize is: ", astar_grid.size)
    astar_grid.cell_size = Vector2i(128, 128)
    astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
    for x in range(astar_grid.region.position.x, astar_grid.region.position.x + astar_grid.region.size.x):
        for y in range(astar_grid.region.position.y, astar_grid.region.position.y + astar_grid.region.size.y):
            var tile_pos = Vector2i(x, y)
            if not obstacles.obstacle_tiles.has(tile_pos):
                astar_grid.set_point_solid(tile_pos, true)
            else:
                astar_grid.set_point_solid(tile_pos, false)
    astar_grid.update()
