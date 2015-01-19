define ['Directions', 'Room'], (Directions, Room) -> 

  class Maze 

    constructor: (width, height) -> 
      @position = null
      @rooms =  [1..width].map (x) -> 
        [1..height].map (y) -> 
          new Room [Directions.North, 
            Directions.East, 
            Directions.South, 
            Directions.West]

    width: -> @rooms.length
    height: -> @rooms[0].length

    set_room: (room, x, y) -> 
      @rooms[x][y] = room

    set_position: (x,y) -> 
      @position = x: x, y: y
      @

    current_room: -> 
      if @position
        @rooms[@position.x][@position.y]
      else null

    set_goal: (x,y) -> 
      @goal = x: x, y: y

    go: (direction) -> 
      new_position = switch direction
        when Directions.North
          x: @position.x, y: @position.y+1
        when Directions.East
          x: @position.x+1, y: @position.y
        when Directions.South
          x: @position.x, y: @position.y-1
        when Directions.West
          x: @position.x-1, y: @position.y

      if (0 <= new_position.x < @width()) and (0 <= new_position.y < @height())
        @set_position new_position.x, new_position.y
      else
        false
