define ['Directions', 'Room', 'Maze'], (Directions, Room, Maze) -> 

  class Solver

    constructor: (@maze) -> 

    solve: -> 

      solve_helper = (maze, position, path) -> 

        if position.equals maze.goal
          [path]
        else if (room = maze.get_room(position)) and room.contains('breadcrumb')
          []
        else
          room.add 'breadcrumb'
          paths = []
          for direction in room.doors when (new_pos = position.after_move direction) and maze.within_bounds new_pos
            new_path = path.slice()
            new_path.push(direction)
            paths = paths.concat solve_helper(maze, new_pos, new_path)

          paths

      solve_helper(@maze, @maze.start, [])
