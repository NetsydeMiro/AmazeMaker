(function() {
  define(['Directions', 'Position', 'Room', 'Maze', 'Solver'], function(Directions, Position, Room, Maze, Solver) {
    return $.widget('netsyde.amazeMaker', {
      options: {
        width: 20,
        height: 20,
        serialized: null,
        url: null
      },
      _create: function() {
        this._render_room_types();
        this._render_controls();
        if (this.options.serialized) {
          return this._load_string(this.options.serialized);
        } else if (this.options.url) {
          return this._load_file(this.options.url);
        } else {
          this.maze = new Maze(this.options.width, this.options.height);
          this._build_maze();
          return this._render_maze();
        }
      },
      _get_doors: function($draggable_room_element) {
        var classes_string;
        classes_string = $draggable_room_element.attr('class');
        return Directions.All.map(function(dir) {
          return dir.toLowerCase();
        }).filter(function(dir) {
          return classes_string.indexOf(dir) !== -1;
        });
      },
      _get_position: function($droppable_room_element) {
        var classes_string, x, y;
        classes_string = $droppable_room_element.attr('class');
        x = parseInt(classes_string.match(/col(\d+)/)[1]);
        y = parseInt(classes_string.match(/row(\d+)/)[1]);
        return new Position(x, y);
      },
      _get_marker: function($draggable_room_element) {
        return ['start', 'goal'].filter(function(klass) {
          return $draggable_room_element.hasClass(klass);
        })[0];
      },
      _get_drop_handler: function() {
        var maze_maker;
        maze_maker = this;
        return function(e, ui) {
          var $dragged_item, $drop_target, doors, position, room, special_class;
          $dragged_item = ui.draggable;
          $drop_target = $(this);
          position = maze_maker._get_position($drop_target);
          special_class = maze_maker._get_marker($dragged_item);
          if (special_class === 'start') {
            maze_maker.maze.set_start(position);
          } else if (special_class === 'goal') {
            maze_maker.maze.set_goal(position);
          } else {
            doors = maze_maker._get_doors($dragged_item);
            room = new Room(doors);
            maze_maker.maze.set_room(position, room);
          }
          return maze_maker._render_maze();
        };
      },
      _render_room_types: function() {
        var perm, room, rooms, _i, _len, _ref;
        rooms = $('<div class="rooms"></div>');
        _ref = this._permute(['north', 'east', 'south', 'west']);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          perm = _ref[_i];
          room = $('<div class="control room ' + perm.join(' ') + '"></div>');
          room.draggable({
            revert: true
          });
          rooms.append(room);
        }
        $('<div class="control start" title="start"></div>').draggable({
          revert: true
        }).appendTo(rooms);
        $('<div class="control goal" title="goal"></div>').draggable({
          revert: true
        }).appendTo(rooms);
        rooms.append('<div class="clear"></div>');
        return this.element.append(rooms);
      },
      _download: function(filename, text) {
        var pom;
        pom = document.createElement('a');
        pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
        pom.setAttribute('download', filename);
        return pom.click();
      },
      _load_string: function(string) {
        this.maze = Maze.from_string(string);
        this._clear_maze();
        this._build_maze();
        return this._render_maze();
      },
      _load_upload: function(file) {
        var reader;
        reader = new FileReader;
        reader.onload = (function(_this) {
          return function(e) {
            return _this._load_string(reader.result);
          };
        })(this);
        return reader.readAsText(file);
      },
      _load_file: function(url) {
        var request;
        request = new XMLHttpRequest;
        request.onload = (function(_this) {
          return function() {
            return _this._load_string(request.responseText);
          };
        })(this);
        request.open('get', url, true);
        return request.send();
      },
      _render_controls: function() {
        var amaze_maker, controls, download, solver, upload;
        amaze_maker = this;
        controls = $('<div class="controls"></div>');
        download = $('<button>Download</button>');
        download.click((function(_this) {
          return function(e) {
            return _this._download('map.amaze', _this.maze.to_string());
          };
        })(this));
        controls.append(download);
        upload = $('<input type="file">');
        upload.change((function(_this) {
          return function(e) {
            return _this._load_upload(e.target.files[0]);
          };
        })(this));
        controls.append(upload);
        solver = $('<button>Solve</button>');
        solver.click((function(_this) {
          return function(e) {
            return _this._overlay_solution();
          };
        })(this));
        controls.append(solver);
        controls.append('<div class="clear"></div>');
        return this.element.append(controls);
      },
      _overlay_solution: function() {
        var current_cell, current_position, direction, path, _results;
        this.maze.clear_items();
        path = new Solver(this.maze).solve_breadth_first();
        current_position = this.maze.start;
        if (path === null) {
          return alert("No solution");
        } else {
          _results = [];
          while (path.length > 0) {
            current_cell = this.element.find('td.row' + current_position.y + '.col' + current_position.x);
            direction = path.shift();
            if (!current_position.equals(this.maze.start)) {
              current_cell.addClass('move_' + direction);
            }
            _results.push(current_position = current_position.after_move(direction));
          }
          return _results;
        }
      },
      _clear_maze: function() {
        return this.element.find('table').remove();
      },
      _build_maze: function() {
        var ci, ri, row, table, _i, _j, _ref, _ref1;
        table = $('<table class="maze"></table>');
        for (ri = _i = _ref = this.maze.height() - 1; _ref <= 0 ? _i <= 0 : _i >= 0; ri = _ref <= 0 ? ++_i : --_i) {
          row = $('<tr></tr>').appendTo(table);
          for (ci = _j = 0, _ref1 = this.maze.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; ci = 0 <= _ref1 ? ++_j : --_j) {
            $('<td></td>').addClass('row' + ri).addClass('col' + ci).droppable({
              hoverClass: 'highlight',
              drop: this._get_drop_handler(this)
            }).appendTo(row);
          }
        }
        return this.element.append(table);
      },
      _render_maze: function() {
        var cell, ci, class_string, doors, ri, table, _i, _ref, _results;
        table = this.element.find('table');
        _results = [];
        for (ri = _i = 0, _ref = this.maze.height() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; ri = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (ci = _j = 0, _ref1 = this.maze.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; ci = 0 <= _ref1 ? ++_j : --_j) {
              doors = this.maze.get_room({
                x: ci,
                y: ri
              }).doors;
              class_string = 'row' + ri + ' col' + ci + ' ' + doors.map(function(d) {
                return d.toLowerCase();
              }).join(' ');
              cell = table.find('td.row' + ri + '.col' + ci);
              cell.attr('class', class_string);
              if (this.maze.start && this.maze.start.equals({
                x: ci,
                y: ri
              })) {
                _results1.push(cell.addClass('start'));
              } else if (this.maze.goal && this.maze.goal.equals({
                x: ci,
                y: ri
              })) {
                _results1.push(cell.addClass('goal'));
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }).call(this));
        }
        return _results;
      },
      _permute: function(set) {
        var head, permuted_tail, result, tail;
        if (set.length === 0) {
          return [];
        } else if (set.length === 1) {
          return [[set[0]], []];
        } else {
          head = set[set.length - 1];
          tail = set.slice(0, set.length - 1);
          permuted_tail = this._permute(tail);
          result = permuted_tail.concat(permuted_tail.map(function(perm) {
            return perm.concat(head);
          }));
          return result.sort(function(perm1, perm2) {
            return perm1.length - perm2.length;
          });
        }
      }
    });
  });

}).call(this);

//# sourceMappingURL=Widget.js.map
