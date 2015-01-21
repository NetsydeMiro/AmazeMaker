define ['Directions'], (Directions) -> 
  class Position

    constructor: (@x,@y) -> 

    # we allow equality with shorthand position
    equals: (coords) -> 
      @x == coords.x and @y == coords.y

    after_move: (direction) -> 
      coords = switch direction
        when Directions.North
          x: @x, y: @y+1
        when Directions.East
          x: @x+1, y: @y
        when Directions.South
          x: @x, y: @y-1
        when Directions.West
          x: @x-1, y: @y

      new Position(coords.x, coords.y)

    # allows shorthand position specification: {x:0,y:0}
    @wrap: (obj) -> 
      if obj.constructor is Position
        obj
      else
        new Position obj.x, obj.y
