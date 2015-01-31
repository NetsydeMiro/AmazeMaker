(function() {
  define(['Direction', 'Position', 'Room', 'Maze', 'Solver'], function(Direction, Position, Room, Maze, Solver) {
    var AmazeMaker;
    return AmazeMaker = (function() {
      function AmazeMaker() {}

      AmazeMaker.Direction = Direction;

      AmazeMaker.Position = Position;

      AmazeMaker.Room = Room;

      AmazeMaker.Maze = Maze;

      AmazeMaker.Solver = Solver;

      return AmazeMaker;

    })();
  });

}).call(this);

//# sourceMappingURL=AmazeMaker.js.map
