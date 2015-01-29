(function() {
  define(['Directions', 'Position', 'Room'], function(Directions, Position, Room) {
    var Maze;
    return Maze = (function() {
      function Maze(width, height) {
        var doors, x, y, _i, _j, _ref, _ref1;
        this.rooms = new Array(width);
        for (x = _i = 0, _ref = width - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
          this.rooms[x] = new Array(height);
          for (y = _j = 0, _ref1 = height - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
            doors = [];
            if (y !== height - 1) {
              doors.push(Directions.North);
            }
            if (x !== width - 1) {
              doors.push(Directions.East);
            }
            if (y !== 0) {
              doors.push(Directions.South);
            }
            if (x !== 0) {
              doors.push(Directions.West);
            }
            this.rooms[x][y] = new Room(doors);
          }
        }
      }

      Maze.prototype.width = function() {
        return this.rooms.length;
      };

      Maze.prototype.height = function() {
        return this.rooms[0].length;
      };

      Maze.prototype.set_room = function(position, room) {
        var adj_pos, adjacent_room, dir, _i, _j, _len, _len1, _ref, _ref1, _results;
        position = Position.wrap(position);
        this.rooms[position.x][position.y] = room;
        _ref = this.at_bounds(position);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dir = _ref[_i];
          room.seal_door(dir);
        }
        _ref1 = Directions.All;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          dir = _ref1[_j];
          if (!(this.within_bounds(adj_pos = position.after_move(dir)))) {
            continue;
          }
          adjacent_room = this.get_room(adj_pos);
          if (room.has_wall(dir)) {
            adjacent_room.seal_door(Directions.Opposite[dir]);
          }
          if (room.has_door(dir)) {
            _results.push(adjacent_room.open_wall(Directions.Opposite[dir]));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      Maze.prototype.get_room = function(position) {
        position = Position.wrap(position);
        return this.rooms[position.x][position.y];
      };

      Maze.prototype.set_start = function(position) {
        position = Position.wrap(position);
        return this.start = position;
      };

      Maze.prototype.set_goal = function(position) {
        position = Position.wrap(position);
        return this.goal = position;
      };

      Maze.prototype.within_bounds = function(position) {
        var _ref, _ref1;
        return (0 <= (_ref = position.x) && _ref < this.width()) && (0 <= (_ref1 = position.y) && _ref1 < this.height());
      };

      Maze.prototype.at_bounds = function(position) {
        var bounds;
        bounds = [];
        if (position.y === 0) {
          bounds.push(Directions.South);
        }
        if (position.x === 0) {
          bounds.push(Directions.West);
        }
        if (position.y === this.height() - 1) {
          bounds.push(Directions.North);
        }
        if (position.x === this.width() - 1) {
          bounds.push(Directions.East);
        }
        return bounds;
      };

      Maze.prototype.equals = function(maze) {
        var x, y, _i, _j, _ref, _ref1;
        if (this.height() !== maze.height() || this.width() !== maze.width() || this.start !== maze.start && (!this.start || !maze.start || !this.start.equals(maze.start)) || this.goal !== maze.goal && (!this.goal || !maze.goal || !this.goal.equals(maze.goal))) {
          return false;
        } else {
          for (x = _i = 0, _ref = this.width() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
            for (y = _j = 0, _ref1 = this.height() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
              if (!this.rooms[x][y].equals(maze.rooms[x][y])) {
                return false;
              }
            }
          }
          return true;
        }
      };

      Maze.prototype.to_string = function() {
        var result, room, x, y, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3;
        result = "";
        for (y = _i = _ref = this.height() - 1; _ref <= 0 ? _i <= 0 : _i >= 0; y = _ref <= 0 ? ++_i : --_i) {
          for (x = _j = 0, _ref1 = this.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            room = this.rooms[x][y];
            if (room.has_wall(Directions.North)) {
              result += '--';
            } else {
              if (room.has_wall(Directions.West)) {
                result += '- ';
              } else {
                result += '  ';
              }
            }
          }
          result += "-\n";
          for (x = _k = 0, _ref2 = this.width() - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; x = 0 <= _ref2 ? ++_k : --_k) {
            room = this.rooms[x][y];
            if (room.has_wall(Directions.West)) {
              result += '|';
            } else {
              result += ' ';
            }
            if (this.start && this.start.equals({
              x: x,
              y: y
            })) {
              result += 's';
            } else if (this.goal && this.goal.equals({
              x: x,
              y: y
            })) {
              result += 'g';
            } else {
              result += ' ';
            }
          }
          result += "|\n";
        }
        for (x = _l = 0, _ref3 = this.width() - 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; x = 0 <= _ref3 ? ++_l : --_l) {
          result += '--';
        }
        return result += '-';
      };

      Maze.from_string = function(serialized) {
        var height, line_no, lines, maze, pos, pos_north, pos_west, width, x, y, _i, _j, _ref, _ref1;
        lines = serialized.split("\n");
        height = Math.floor(lines.length / 2);
        width = Math.floor(lines[0].length / 2);
        maze = new Maze(width, height);
        for (y = _i = _ref = height - 1; _ref <= 0 ? _i <= 0 : _i >= 0; y = _ref <= 0 ? ++_i : --_i) {
          line_no = lines.length - (y + 1) * 2 - 1;
          for (x = _j = 0, _ref1 = width - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            pos = new Position(x, y);
            if (lines[line_no][x * 2 + 1] === '-') {
              maze.get_room(pos).seal_door(Directions.North);
              if (maze.within_bounds((pos_north = pos.after_move(Directions.North)))) {
                maze.get_room(pos_north).seal_door(Directions.South);
              }
            }
            if (lines[line_no + 1][x * 2] === '|') {
              maze.get_room(pos).seal_door(Directions.West);
              if (maze.within_bounds((pos_west = pos.after_move(Directions.West)))) {
                maze.get_room(pos_west).seal_door(Directions.East);
              }
            }
            switch (lines[line_no + 1][x * 2 + 1]) {
              case 's':
                maze.set_start(pos);
                break;
              case 'g':
                maze.set_goal(pos);
            }
            maze.get_room({
              x: width - 1,
              y: y
            }).seal_door(Directions.East);
          }
        }
        return maze;
      };

      Maze.prototype.clear_items = function() {
        var x, y, _i, _ref, _results;
        _results = [];
        for (x = _i = 0, _ref = this.width() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (y = _j = 0, _ref1 = this.height() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
              _results1.push(this.rooms[x][y].clear_items());
            }
            return _results1;
          }).call(this));
        }
        return _results;
      };

      return Maze;

    })();
  });

}).call(this);

//# sourceMappingURL=Maze.js.map
