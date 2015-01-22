define -> 
  class Directions
    @North = 'north'
    @East = 'east'
    @South = 'south'
    @West = 'west'

    @All = [@North,@East,@South,@West]

    @Opposite = {}
    @Opposite[@North] = @South
    @Opposite[@East] = @West
    @Opposite[@South] = @North
    @Opposite[@West] = @East
