define -> 
  class Directions
    @North = 0
    @East = 1
    @South = 2
    @West = 3

    @All = [@North,@East,@South,@West]

    @Opposite = {}
    @Opposite[@North] = @South
    @Opposite[@East] = @West
    @Opposite[@South] = @North
    @Opposite[@West] = @East
