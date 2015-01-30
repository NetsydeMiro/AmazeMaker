define ['Direction'], (Direction) -> 
  class Position

    constructor: (@x,@y) -> 

    # duck type equality allowed to support shorthand position notation
    equals: (coords) -> 
      @x == coords.x and @y == coords.y

    afterMove: (direction) -> 
      coords = switch direction
        when Direction.NORTH
          x: @x, y: @y+1
        when Direction.EAST
          x: @x+1, y: @y
        when Direction.SOUTH
          x: @x, y: @y-1
        when Direction.WEST
          x: @x-1, y: @y

      new Position(coords.x, coords.y)

    # to easily support shorthand position notation: {x:0,y:0}
    @wrap: (obj) -> 
      if obj.constructor is Position
        obj
      else
        new Position obj.x, obj.y
