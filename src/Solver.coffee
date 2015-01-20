define ['Directions', 'Room', 'Maze'], (Directions, Room, Maze) -> 

  class Solver

    constructor: (@maze) -> 

    solve: -> 

      solve_helper = (maze, position, path) -> 

        if position.x == maze.goal.x and position.y == maze.goal.y
          [path]
        else if (room = maze.room_at(position)) and room.contains('breadcrumb')
          []
        else
          room.add 'breadcrumb'
          paths = []
          for door in room.doors when (new_pos = maze.new_position(position, door))
            new_path = path.slice()
            new_path.push(door)
            paths = paths.concat solve_helper(maze, new_pos, new_path)

          paths

      solve_helper(@maze, @maze.start, [])
