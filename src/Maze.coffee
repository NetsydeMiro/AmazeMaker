define ['Directions', 'Position', 'Room'], (Directions, Position, Room) -> 

  class Maze 

    constructor: (width, height) -> 
      # initialize empty rooms, within walled labyrinth
      @rooms = new Array(width)
      for x in [0..width-1]
        @rooms[x] = new Array(height)
        for y in [0..height-1]
          doors = []
          doors.push Directions.North unless y is height-1
          doors.push Directions.East unless x is width-1
          doors.push Directions.South unless y is 0
          doors.push Directions.West unless x is 0

          @rooms[x][y] = new Room(doors)


    width: -> @rooms.length
    height: -> @rooms[0].length

    set_room: (position, room) -> 
      position = Position.wrap position
      @rooms[position.x][position.y] = room

      room.seal_door(dir) for dir in @at_bounds(position)

      for dir in Directions.All when @within_bounds(adj_pos = position.after_move(dir))
        adjacent_room = @get_room adj_pos
        adjacent_room.seal_door(Directions.Opposite[dir]) if room.has_wall(dir)
        adjacent_room.open_wall(Directions.Opposite[dir]) if room.has_door(dir)

    get_room: (position) -> 
      position = Position.wrap position
      @rooms[position.x][position.y]

    set_start: (position) -> 
      position = Position.wrap position
      @start = position

    set_goal: (position) -> 
      position = Position.wrap position
      @goal = position

    within_bounds: (position) -> 
      0 <= position.x < @width() and 0 <= position.y < @height()

    at_bounds: (position) -> 
      bounds = []
      if position.y is 0
        bounds.push Directions.South
      if position.x is 0
        bounds.push Directions.West
      if position.y is @height()-1
        bounds.push Directions.North
      if position.x is @width()-1
        bounds.push Directions.East

      bounds

    equals: (maze) -> 
      if @height() isnt maze.height() or
      @width() isnt maze.width() or
      @start isnt maze.start and (not @start or not maze.start or not @start.equals maze.start) or
      @goal isnt maze.goal and (not @goal or not maze.goal or not @goal.equals maze.goal)

        return false

      else

        for x in [0..@width()-1]
          for y in [0..@height()-1]
            if not @rooms[x][y].equals maze.rooms[x][y]
              return false

        return true

    to_string: () -> 
      result = ""

      for y in [@height()-1..0]

        # first we draw northern wall
        for x in [0..@width()-1]
          room = @rooms[x][y]

          if room.has_wall Directions.North
            result += '--'
          else
            if room.has_wall Directions.West
              # north west corner
              result += '- '
            else
              result += '  '

        # far right is always labyrinth wall
        result += "-\n"

        # next we draw western walls and markers
        for x in [0..@width()-1]
          room = @rooms[x][y]

          if room.has_wall Directions.West
            result += '|'
          else
            result += ' '

          if @start.equals {x:x, y:y}
            result += 's'

          else if @goal.equals {x:x, y:y}
            result += 'g'

          else
            result += ' '

        # far right is always labyrinth wall
        result += "|\n"

      for x in [0..@width()-1]
        #lastly we draw southern boundary of labyrinth
        result += '--'

      result += '-'

    @from_string: (serialized) -> 

      lines = serialized.split("\n")

      height = Math.floor(lines.length / 2)
      width = Math.floor(lines[0].length / 2)

      maze = new Maze width, height

      for y in [0..height-1]

        # create north wall
        for x in [0..width-1]
          row = height - y - 1

          pos = new Position x, y

          if lines[height-y*2][x*2] == '-'
            maze.get_room(pos).seal_door Directions.North
            if maze.within_bounds (pos_north = pos.after_move Directions.North)
              maze.get_room(pos_north).seal_door Directions.South

          # create western walls
          if lines[height-y*2+1][x*2] == '|'
            maze.get_room(pos).seal_door Directions.West
            if maze.within_bounds (pos_west = pos.after_move Directions.West)
              maze.get_room(pos_west).seal_door Directions.East

          # create items
          switch lines[height-y*2+1][x*2+1]
            when 's'
              maze.set_start pos
            when 'g'
              maze.set_goal pos

          # close eastern edge of labyrinth
          maze.get_room(x:width-1, y:y).seal_door Directions.East

      maze
