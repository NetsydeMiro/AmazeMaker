define -> 
  class Direction
    @NORTH = 'north'
    @EAST = 'east'
    @SOUTH = 'south'
    @WEST = 'west'

    @ALL = [@NORTH,@EAST,@SOUTH,@WEST]

    @OPPOSITE = {}
    @OPPOSITE[@NORTH] = @SOUTH
    @OPPOSITE[@EAST] = @WEST
    @OPPOSITE[@SOUTH] = @NORTH
    @OPPOSITE[@WEST] = @EAST
