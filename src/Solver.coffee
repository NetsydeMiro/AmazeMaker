define ['Directions', 'Room', 'Maze'], (Directions, Room, Maze) -> 

  class Solver

    constructor: (@maze) -> 

    solveDepthFirst: -> 

      solveHelper = (maze, position, path) -> 

        if position.equals maze.goal
          return path
        else if (room = maze.getRoom position) and room.contains 'breadcrumb'
          return null
        else
          room.add 'breadcrumb'
          for direction in room.doors when (newPos = position.afterMove direction) and maze.withinBounds newPos
            newPath = path.slice()
            newPath.push direction
            if (result = solveHelper(maze, newPos, newPath))
              return result

        return null

      solveHelper @maze, @maze.start, []

    solveBreadthFirst: -> 

      pathQueue = [{position: @maze.start, path: []}]

      while pathQueue.length > 0 and {position,path} = pathQueue.pop()
        if position.equals @maze.goal
          return path
        else
          room = @maze.getRoom position

          if not room.contains 'breadcrumb'
            room.add 'breadcrumb'

            for direction in room.doors when (newPos = position.after_move direction) and @maze.withinBounds newPos
              newPath = path.slice()
              newPath.push direction

              pathQueue.unshift {position: newPos, path: newPath}

      return null

