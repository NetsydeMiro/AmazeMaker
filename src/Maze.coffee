define ['Direction', 'Position', 'Room'], (Direction, Position, Room) -> 

  class Maze 

    constructor: (width, height) -> 
      # initialize empty rooms, within walled labyrinth
      @rooms = new Array(width)
      for x in [0...width]
        @rooms[x] = new Array(height)
        for y in [0...height]
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

    # returns boundaries on which position resides (if any)
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
      # maze must have same dimensions, and either equal or null starts and goals
      if @height() isnt maze.height() or
      @width() isnt maze.width() or
      @start isnt maze.start and (not @start or not maze.start or not @start.equals maze.start) or
      @goal isnt maze.goal and (not @goal or not maze.goal or not @goal.equals maze.goal)

        return false

      else

        # rooms must all be equal
        for x in [0...@width()]
          for y in [0...@height()]
            if not @rooms[x][y].equals maze.rooms[x][y]
              return false

        return true

    clearItems: -> 
      for x in [0...@width()]
        for y in [0...@height()]
          @rooms[x][y].clearItems()
