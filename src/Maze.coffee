define ['Directions', 'Position', 'Room'], (Directions, Position, Room) -> 

  class Maze 

    constructor: (width, height) -> 
      @position = null

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


