(function() {
  define(function() {
    var Direction;
    return Direction = (function() {
      function Direction() {}

      Direction.NORTH = 'north';

      Direction.EAST = 'east';

      Direction.SOUTH = 'south';

      Direction.WEST = 'west';

      Direction.ALL = [Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST];

      Direction.OPPOSITE = {};

      Direction.OPPOSITE[Direction.NORTH] = Direction.SOUTH;

      Direction.OPPOSITE[Direction.EAST] = Direction.WEST;

      Direction.OPPOSITE[Direction.SOUTH] = Direction.NORTH;

      Direction.OPPOSITE[Direction.WEST] = Direction.EAST;

      return Direction;

    })();
  });

}).call(this);

//# sourceMappingURL=Direction.js.map
