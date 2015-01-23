define ['Directions', 'Room', 'Maze'], (Directions, Room, Maze) -> 

  class Solver

    constructor: (@maze) -> 

    solve_depth_first: -> 

      solve_helper = (maze, position, path) -> 

        if position.equals maze.goal
          return path
        else if (room = maze.get_room(position)) and room.contains('breadcrumb')
          return null
        else
          room.add 'breadcrumb'
          for direction in room.doors when (new_pos = position.after_move direction) and maze.within_bounds new_pos
            new_path = path.slice()
            new_path.push(direction)
            if (result = solve_helper maze, new_pos, new_path)
              return result

        return null


      solve_helper(@maze, @maze.start, [])

    solve_breadth_first: -> 

      path_queue = [{position: @maze.start, path: []}]

      while path_queue.length > 0 and {position,path} = path_queue.pop()
        if position.equals @maze.goal
          return path
        else
          room = @maze.get_room position

          if not room.contains 'breadcrumb'
            room.add 'breadcrumb'

            for direction in room.doors when (new_pos = position.after_move direction) and @maze.within_bounds new_pos
              new_path = path.slice()
              new_path.push direction

              path_queue.unshift {position: new_pos, path: new_path}

      return null

