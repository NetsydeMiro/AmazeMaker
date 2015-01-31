(function() {
  define(['Direction', 'Position', 'Room'], function(Direction, Position, Room) {
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
              doors.push(Direction.NORTH);
            }
            if (x !== width - 1) {
              doors.push(Direction.EAST);
            }
            if (y !== 0) {
              doors.push(Direction.SOUTH);
            }
            if (x !== 0) {
              doors.push(Direction.WEST);
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

      Maze.prototype.setRoom = function(position, room) {
        var adjPos, adjacentRoom, dir, _i, _j, _len, _len1, _ref, _ref1, _results;
        position = Position.wrap(position);
        this.rooms[position.x][position.y] = room;
        _ref = this.atBounds(position);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dir = _ref[_i];
          room.sealDoor(dir);
        }
        _ref1 = Direction.ALL;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          dir = _ref1[_j];
          if (!(this.withinBounds(adjPos = position.afterMove(dir)))) {
            continue;
          }
          adjacentRoom = this.getRoom(adjPos);
          if (room.hasWall(dir)) {
            adjacentRoom.sealDoor(Direction.OPPOSITE[dir]);
          }
          if (room.hasDoor(dir)) {
            _results.push(adjacentRoom.openWall(Direction.OPPOSITE[dir]));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      Maze.prototype.getRoom = function(position) {
        position = Position.wrap(position);
        return this.rooms[position.x][position.y];
      };

      Maze.prototype.setStart = function(position) {
        position = Position.wrap(position);
        return this.start = position;
      };

      Maze.prototype.setGoal = function(position) {
        position = Position.wrap(position);
        return this.goal = position;
      };

      Maze.prototype.withinBounds = function(position) {
        var _ref, _ref1;
        return (0 <= (_ref = position.x) && _ref < this.width()) && (0 <= (_ref1 = position.y) && _ref1 < this.height());
      };

      Maze.prototype.atBounds = function(position) {
        var bounds;
        bounds = [];
        if (position.y === 0) {
          bounds.push(Direction.SOUTH);
        }
        if (position.x === 0) {
          bounds.push(Direction.WEST);
        }
        if (position.y === this.height() - 1) {
          bounds.push(Direction.NORTH);
        }
        if (position.x === this.width() - 1) {
          bounds.push(Direction.EAST);
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

      Maze.prototype.toString = function() {
        var result, room, x, y, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3;
        result = "";
        for (y = _i = _ref = this.height() - 1; _ref <= 0 ? _i <= 0 : _i >= 0; y = _ref <= 0 ? ++_i : --_i) {
          for (x = _j = 0, _ref1 = this.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            room = this.rooms[x][y];
            if (room.hasWall(Direction.NORTH)) {
              result += '--';
            } else {
              if (room.hasWall(Direction.WEST)) {
                result += '- ';
              } else {
                result += '  ';
              }
            }
          }
          result += "-\n";
          for (x = _k = 0, _ref2 = this.width() - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; x = 0 <= _ref2 ? ++_k : --_k) {
            room = this.rooms[x][y];
            if (room.hasWall(Direction.WEST)) {
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

      Maze.fromString = function(serialized) {
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
              maze.getRoom(pos).sealDoor(Direction.NORTH);
              if (maze.withinBounds((pos_north = pos.afterMove(Direction.NORTH)))) {
                maze.getRoom(pos_north).sealDoor(Direction.SOUTH);
              }
            }
            if (lines[line_no + 1][x * 2] === '|') {
              maze.getRoom(pos).sealDoor(Direction.WEST);
              if (maze.withinBounds((pos_west = pos.afterMove(Direction.WEST)))) {
                maze.getRoom(pos_west).sealDoor(Direction.EAST);
              }
            }
            switch (lines[line_no + 1][x * 2 + 1]) {
              case 's':
                maze.setStart(pos);
                break;
              case 'g':
                maze.setGoal(pos);
            }
            maze.getRoom({
              x: width - 1,
              y: y
            }).sealDoor(Direction.EAST);
          }
        }
        return maze;
      };

      Maze.prototype.clearItems = function() {
        var x, y, _i, _ref, _results;
        _results = [];
        for (x = _i = 0, _ref = this.width() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (y = _j = 0, _ref1 = this.height() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
              _results1.push(this.rooms[x][y].clearItems());
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
