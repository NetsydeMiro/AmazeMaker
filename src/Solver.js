(function() {
  define(['Directions', 'Room', 'Maze'], function(Directions, Room, Maze) {
    var Solver;
    return Solver = (function() {
      function Solver(maze) {
        this.maze = maze;
      }

      Solver.prototype.solve_depth_first = function() {
        var solve_helper;
        solve_helper = function(maze, position, path) {
          var direction, new_path, new_pos, result, room, _i, _len, _ref;
          if (position.equals(maze.goal)) {
            return path;
          } else if ((room = maze.get_room(position)) && room.contains('breadcrumb')) {
            return null;
          } else {
            room.add('breadcrumb');
            _ref = room.doors;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              direction = _ref[_i];
              if (!((new_pos = position.after_move(direction)) && maze.within_bounds(new_pos))) {
                continue;
              }
              new_path = path.slice();
              new_path.push(direction);
              if ((result = solve_helper(maze, new_pos, new_path))) {
                return result;
              }
            }
          }
          return null;
        };
        return solve_helper(this.maze, this.maze.start, []);
      };

      Solver.prototype.solve_breadth_first = function() {
        var direction, new_path, new_pos, path, path_queue, position, room, _i, _len, _ref, _ref1;
        path_queue = [
          {
            position: this.maze.start,
            path: []
          }
        ];
        while (path_queue.length > 0 && (_ref1 = path_queue.pop(), position = _ref1.position, path = _ref1.path, _ref1)) {
          if (position.equals(this.maze.goal)) {
            return path;
          } else {
            room = this.maze.get_room(position);
            if (!room.contains('breadcrumb')) {
              room.add('breadcrumb');
              _ref = room.doors;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                direction = _ref[_i];
                if (!((new_pos = position.after_move(direction)) && this.maze.within_bounds(new_pos))) {
                  continue;
                }
                new_path = path.slice();
                new_path.push(direction);
                path_queue.unshift({
                  position: new_pos,
                  path: new_path
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
