define ['Direction', 'Position', 'Maze'], (Direction, Position, Maze) ->

  class Serializer

    # returns ascii art representation of maze
    @toString: (maze) -> 
      result = ""

      for y in [maze.height()-1..0]

        # first we draw northern wall
        for x in [0..maze.width()-1]
          room = maze.getRoom x:x, y:y

          if room.hasWall Direction.NORTH
            result += '--'
          else
            if room.hasWall Direction.WEST
              # north west corner
              result += '- '
            else
              result += '  '

        # far right is always labyrinth wall
        result += "-\n"

        # next we draw western walls and markers
        for x in [0..maze.width()-1]
          room = maze.getRoom x:x, y:y

          if room.hasWall Direction.WEST
            result += '|'
          else
            result += ' '

          if maze.start and maze.start.equals {x:x, y:y}
            result += 's'

          else if maze.goal and maze.goal.equals {x:x, y:y}
            result += 'g'

          else
            result += ' '

        # far right is always labyrinth wall
        result += "|\n"

      for x in [0..maze.width()-1]
        #lastly we draw southern boundary of labyrinth
        result += '--'

      result += '-'

    # just a quick sanity check... not an exhaustive validation
    @validMazeString: (serialized) -> 
      lines = serialized.split "\n"
      # must be at least 3 lines (height or at least 1 room)
      lines.length > 2 and 
      # first line must contain only dasheas (northern wall)
      not lines[0].match('[^-]')


    # builds maze from ascii art representation
    @fromString: (serialized) -> 

      if not @validMazeString serialized
        throw "Invalid Maze String: #{serialized}"

      lines = serialized.split("\n")

      height = Math.floor(lines.length / 2)
      width = Math.floor(lines[0].length / 2)

      maze = new Maze width, height

      for y in [height-1..0]
        line_no = lines.length - (y + 1) * 2 - 1

        # create north wall
        for x in [0..width-1]

          pos = new Position x, y

          if lines[line_no][x*2+1] == '-'
            maze.getRoom(pos).sealDoor Direction.NORTH
            if maze.withinBounds (pos_north = pos.afterMove Direction.NORTH)
              maze.getRoom(pos_north).sealDoor Direction.SOUTH

          # create western walls
          if lines[line_no+1][x*2] == '|'
            maze.getRoom(pos).sealDoor Direction.WEST
            if maze.withinBounds (pos_west = pos.afterMove Direction.WEST)
              maze.getRoom(pos_west).sealDoor Direction.EAST

          # create markers, if any
          switch lines[line_no+1][x*2+1]
            when 's'
              maze.setStart pos
            when 'g'
              maze.setGoal pos

          # close eastern edge of labyrinth
          maze.getRoom(x:width-1, y:y).sealDoor Direction.EAST

      maze
