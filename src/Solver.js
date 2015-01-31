(function() {
  define(['Direction', 'Room', 'Maze'], function(Direction, Room, Maze) {
    var Solver;
    return Solver = (function() {
      function Solver(maze) {
        this.maze = maze;
      }

      Solver.prototype.solveDepthFirst = function() {
        var solveHelper;
        solveHelper = function(maze, position, path) {
          var direction, newPath, newPos, result, room, _i, _len, _ref;
          if (position.equals(maze.goal)) {
            return path;
          } else if ((room = maze.getRoom(position)) && room.contains('breadcrumb')) {
            return null;
          } else {
            room.add('breadcrumb');
            _ref = room.doors;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              direction = _ref[_i];
              if (!((newPos = position.afterMove(direction)) && maze.withinBounds(newPos))) {
                continue;
              }
              newPath = path.slice();
              newPath.push(direction);
              if ((result = solveHelper(maze, newPos, newPath))) {
                return result;
              }
            }
          }
          return null;
        };
        return solveHelper(this.maze, this.maze.start, []);
      };

      Solver.prototype.solveBreadthFirst = function() {
        var direction, newPath, newPos, path, pathQueue, position, room, _i, _len, _ref, _ref1;
        pathQueue = [
          {
            position: this.maze.start,
            path: []
          }
        ];
        while (pathQueue.length > 0 && (_ref1 = pathQueue.pop(), position = _ref1.position, path = _ref1.path, _ref1)) {
          if (position.equals(this.maze.goal)) {
            return path;
          } else {
            room = this.maze.getRoom(position);
            if (!room.contains('breadcrumb')) {
              room.add('breadcrumb');
              _ref = room.doors;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                direction = _ref[_i];
                if (!((newPos = position.afterMove(direction)) && this.maze.withinBounds(newPos))) {
                  continue;
                }
                newPath = path.slice();
                newPath.push(direction);
                pathQueue.unshift({
                  position: newPos,
                  path: newPath
                });
              }
            }
          }
        }
        return null;
      };

      return Solver;

    })();
  });

}).call(this);

//# sourceMappingURL=Solver.js.map
