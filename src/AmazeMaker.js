(function() {
  define(['Directions', 'Position', 'Room', 'Maze', 'Solver'], function(Directions, Position, Room, Maze, Solver) {
    var AmazeMaker;
    return AmazeMaker = (function() {
      function AmazeMaker() {}

      AmazeMaker.Directions = Directions;

      AmazeMaker.Position = Position;

      AmazeMaker.Room = Room;

      AmazeMaker.Maze = Maze;

      AmazeMaker.Solver = Solver;

      return AmazeMaker;

    })();
  });

}).call(this);

//# sourceMappingURL=AmazeMaker.js.map
