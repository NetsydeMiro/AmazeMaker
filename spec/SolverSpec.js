(function() {
  define(['AmazeMaker'], function(AmazeMaker) {
    return describe('Solver', function() {
      describe('#solve_depth_first()', function() {
        it('finds path from single path walled maze', function() {
          var amaze, paths, room, solver;
          amaze = new AmazeMaker.Maze(2, 2);
          amaze.set_start(new AmazeMaker.Position(0, 1));
          amaze.set_goal(new AmazeMaker.Position(0, 0));
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 1
          }, room);
          room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South]);
          amaze.set_room({
            x: 1,
            y: 1
          }, room);
          room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West]);
          amaze.set_room({
            x: 1,
            y: 0
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          solver = new AmazeMaker.Solver(amaze);
          paths = solver.solve_depth_first();
          return expect(paths).toEqual([AmazeMaker.Directions.East, AmazeMaker.Directions.South, AmazeMaker.Directions.West]);
        });
        return it('gets no paths from impossible maze', function() {
          var amaze, paths, room, solver;
          amaze = new AmazeMaker.Maze(2, 2);
          amaze.set_start(new AmazeMaker.Position(0, 1));
          amaze.set_goal(new AmazeMaker.Position(0, 0));
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 1
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.West);
          amaze.set_room({
            x: 1,
            y: 1
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.West);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          solver = new AmazeMaker.Solver(amaze);
          paths = solver.solve_depth_first();
          return expect(paths).toEqual(null);
        });
      });
      return describe('#solve_breadth_first()', function() {
        it('finds path from single path walled maze', function() {
          var amaze, paths, room, solver;
          amaze = new AmazeMaker.Maze(2, 2);
          amaze.set_start(new AmazeMaker.Position(0, 1));
          amaze.set_goal(new AmazeMaker.Position(0, 0));
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 1
          }, room);
          room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South]);
          amaze.set_room({
            x: 1,
            y: 1
          }, room);
          room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West]);
          amaze.set_room({
            x: 1,
            y: 0
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          solver = new AmazeMaker.Solver(amaze);
          paths = solver.solve_breadth_first();
          return expect(paths).toEqual([AmazeMaker.Directions.East, AmazeMaker.Directions.South, AmazeMaker.Directions.West]);
        });
        return it('gets no paths from impossible maze', function() {
          var amaze, paths, room, solver;
          amaze = new AmazeMaker.Maze(2, 2);
          amaze.set_start(new AmazeMaker.Position(0, 1));
          amaze.set_goal(new AmazeMaker.Position(0, 0));
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 1
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.West);
          amaze.set_room({
            x: 1,
            y: 1
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.West);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          room = new AmazeMaker.Room(AmazeMaker.Directions.East);
          amaze.set_room({
            x: 0,
            y: 0
          }, room);
          solver = new AmazeMaker.Solver(amaze);
          paths = solver.solve_breadth_first();
          return expect(paths).toEqual(null);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=SolverSpec.js.map
