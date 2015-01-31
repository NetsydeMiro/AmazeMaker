(function() {
  define(['AmazeMaker'], function(AmazeMaker) {
    var Direction, Maze, Position, Room, Solver;
    Position = AmazeMaker.Position;
    Direction = AmazeMaker.Direction;
    Room = AmazeMaker.Room;
    Maze = AmazeMaker.Maze;
    Solver = AmazeMaker.Solver;
    return describe('Solver', function() {
      describe('#solveDepthFirst()', function() {
        it('finds path from single path walled maze', function() {
          var amaze, paths, room, solver;
          amaze = new Maze(2, 2);
          amaze.setStart(new Position(0, 1));
          amaze.setGoal(new Position(0, 0));
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 1
          }, room);
          room = new Room([Direction.WEST, Direction.SOUTH]);
          amaze.setRoom({
            x: 1,
            y: 1
          }, room);
          room = new Room([Direction.NORTH, Direction.WEST]);
          amaze.setRoom({
            x: 1,
            y: 0
          }, room);
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          solver = new Solver(amaze);
          paths = solver.solveDepthFirst();
          return expect(paths).toEqual([Direction.EAST, Direction.SOUTH, Direction.WEST]);
        });
        return it('gets no paths from impossible maze', function() {
          var amaze, paths, room, solver;
          amaze = new Maze(2, 2);
          amaze.setStart(new Position(0, 1));
          amaze.setGoal(new Position(0, 0));
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 1
          }, room);
          room = new Room(Direction.WEST);
          amaze.setRoom({
            x: 1,
            y: 1
          }, room);
          room = new Room(Direction.WEST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          solver = new Solver(amaze);
          paths = solver.solveDepthFirst();
          return expect(paths).toEqual(null);
        });
      });
      return describe('#solveBreadthFirst()', function() {
        it('finds path from single path walled maze', function() {
          var amaze, paths, room, solver;
          amaze = new Maze(2, 2);
          amaze.setStart(new Position(0, 1));
          amaze.setGoal(new Position(0, 0));
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 1
          }, room);
          room = new Room([Direction.WEST, Direction.SOUTH]);
          amaze.setRoom({
            x: 1,
            y: 1
          }, room);
          room = new Room([Direction.NORTH, Direction.WEST]);
          amaze.setRoom({
            x: 1,
            y: 0
          }, room);
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          solver = new Solver(amaze);
          paths = solver.solveBreadthFirst();
          return expect(paths).toEqual([Direction.EAST, Direction.SOUTH, Direction.WEST]);
        });
        return it('gets no paths from impossible maze', function() {
          var amaze, paths, room, solver;
          amaze = new Maze(2, 2);
          amaze.setStart(new Position(0, 1));
          amaze.setGoal(new Position(0, 0));
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 1
          }, room);
          room = new Room(Direction.WEST);
          amaze.setRoom({
            x: 1,
            y: 1
          }, room);
          room = new Room(Direction.WEST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          room = new Room(Direction.EAST);
          amaze.setRoom({
            x: 0,
            y: 0
          }, room);
          solver = new Solver(amaze);
          paths = solver.solveBreadthFirst();
          return expect(paths).toEqual(null);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=SolverSpec.js.map
