define ['Direction', 'Position', 'Room'], (Direction, Position, Room) -> 

  class Maze 

    constructor: (width, height) -> 
      # initialize empty rooms, within walled labyrinth
      @rooms = new Array(width)
      for x in [0..width-1]
        @rooms[x] = new Array(height)
        for y in [0..height-1]
          doors = []
          doors.push Direction.NORTH unless y is height-1
          doors.push Direction.EAST unless x is width-1
          doors.push Direction.SOUTH unless y is 0
          doors.push Direction.WEST unless x is 0

          @rooms[x][y] = new Room(doors)

    width: -> @rooms.length
    height: -> @rooms[0].length

    setRoom: (position, room) -> 
      position = Position.wrap position
      @rooms[position.x][position.y] = room

      room.sealDoor(dir) for dir in @atBounds(position)

      for dir in Direction.ALL when @withinBounds(adjPos = position.afterMove dir)
        adjacentRoom = @getRoom adjPos
        adjacentRoom.sealDoor(Direction.OPPOSITE[dir]) if room.hasWall dir
        adjacentRoom.openWall(Direction.OPPOSITE[dir]) if room.hasDoor dir

    getRoom: (position) -> 
      position = Position.wrap position
      @rooms[position.x][position.y]

    setStart: (position) -> 
      position = Position.wrap position
      @start = position

    setGoal: (position) -> 
      position = Position.wrap position
      @goal = position

    withinBounds: (position) -> 
      0 <= position.x < @width() and 0 <= position.y < @height()

    # returns boundaries on with position resides (if any)
    atBounds: (position) -> 
      bounds = []
      if position.y is 0
        bounds.push Direction.SOUTH
      if position.x is 0
        bounds.push Direction.WEST
      if position.y is @height()-1
        bounds.push Direction.NORTH
      if position.x is @width()-1
        bounds.push Direction.EAST

      bounds

    equals: (maze) -> 
      # maze must have same dimensions, and either equal or unset starts and goals
      if @height() isnt maze.height() or
      @width() isnt maze.width() or
      @start isnt maze.start and (not @start or not maze.start or not @start.equals maze.start) or
      @goal isnt maze.goal and (not @goal or not maze.goal or not @goal.equals maze.goal)

        return false

      else

        # rooms must all be equal
        for x in [0..@width()-1]
          for y in [0..@height()-1]
            if not @rooms[x][y].equals maze.rooms[x][y]
              return false

        return true

    # returns ascii art representation of maze
    toString: () -> 
      result = ""

      for y in [@height()-1..0]

        # first we draw northern wall
        for x in [0..@width()-1]
          room = @rooms[x][y]

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
        for x in [0..@width()-1]
          room = @rooms[x][y]

          if room.hasWall Direction.WEST
            result += '|'
          else
            result += ' '

          if @start and @start.equals {x:x, y:y}
            result += 's'

          else if @goal and @goal.equals {x:x, y:y}
            result += 'g'

          else
            result += ' '

        # far right is always labyrinth wall
        result += "|\n"

      for x in [0..@width()-1]
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

    clearItems: -> 
      for x in [0..@width()-1]
        for y in [0..@height()-1]
          @rooms[x][y].clearItems()
