(function() {
  define(['Direction', 'Position', 'Room', 'Maze', 'Solver'], function(Direction, Position, Room, Maze, Solver) {
    return $.widget('netsyde.amazeMaker', {
      options: {
        width: 20,
        height: 20,
        serialized: null,
        url: null
      },
      _create: function() {
        this._renderRoomTypes();
        this._renderControls();
        if (this.options.serialized) {
          return this._loadString(this.options.serialized);
        } else if (this.options.url) {
          return this._loadFile(this.options.url);
        } else {
          this.maze = new Maze(this.options.width, this.options.height);
          this._buildMaze();
          return this._renderMaze();
        }
      },
      _getDoors: function($draggableRoomElement) {
        var klass;
        klass = $draggableRoomElement.attr('class');
        return Direction.ALL.map(function(dir) {
          return dir.toLowerCase();
        }).filter(function(dir) {
          return klass.indexOf(dir) !== -1;
        });
      },
      _getPosition: function($droppableRoomElement) {
        var klass, x, y;
        klass = $droppableRoomElement.attr('class');
        x = parseInt(klass.match(/col(\d+)/)[1]);
        y = parseInt(klass.match(/row(\d+)/)[1]);
        return new Position(x, y);
      },
      _getMarker: function($draggableRoomElement) {
        return ['start', 'goal'].filter(function(klass) {
          return $draggableRoomElement.hasClass(klass);
        })[0];
      },
      _getDropHandler: function() {
        var amazeMaker;
        amazeMaker = this;
        return function(e, ui) {
          var $draggedItem, $dropTarget, doors, position, room, specialClass;
          $draggedItem = ui.draggable;
          $dropTarget = $(this);
          position = amazeMaker._getPosition($dropTarget);
          specialClass = amazeMaker._getMarker($draggedItem);
          if (specialClass === 'start') {
            amazeMaker.maze.setStart(position);
          } else if (specialClass === 'goal') {
            amazeMaker.maze.setGoal(position);
          } else {
            doors = amazeMaker._getDoors($draggedItem);
            room = new Room(doors);
            amazeMaker.maze.setRoom(position, room);
          }
          return amazeMaker._renderMaze();
        };
      },
      _renderRoomTypes: function() {
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
      _loadString: function(string) {
        this.maze = Maze.fromString(string);
        this._clearMaze();
        this._buildMaze();
        return this._renderMaze();
      },
      _loadUpload: function(file) {
        var reader;
        reader = new FileReader;
        reader.onload = (function(_this) {
          return function(e) {
            return _this._loadString(reader.result);
          };
        })(this);
        return reader.readAsText(file);
      },
      _loadFile: function(url) {
        var request;
        request = new XMLHttpRequest;
        request.onload = (function(_this) {
          return function() {
            return _this._loadString(request.responseText);
          };
        })(this);
        request.open('get', url, true);
        return request.send();
      },
      _renderControls: function() {
        var controls, download, solver, upload;
        controls = $('<div class="controls"></div>');
        download = $('<button>Download</button>');
        download.click((function(_this) {
          return function(e) {
            return _this._download('map.amaze', _this.maze.toString());
          };
        })(this));
        controls.append(download);
        upload = $('<input type="file">');
        upload.change((function(_this) {
          return function(e) {
            return _this._loadUpload(e.target.files[0]);
          };
        })(this));
        controls.append(upload);
        solver = $('<button>Solve</button>');
        solver.click((function(_this) {
          return function(e) {
            return _this._overlaySolution();
          };
        })(this));
        controls.append(solver);
        controls.append('<div class="clear"></div>');
        return this.element.append(controls);
      },
      _overlaySolution: function() {
        var currentCell, currentPosition, direction, path, _results;
        this.maze.clearItems();
        path = new Solver(this.maze).solveBreadthFirst();
        currentPosition = this.maze.start;
        if (path === null) {
          return alert("No solution");
        } else {
          _results = [];
          while (path.length > 0) {
            currentCell = this.element.find('td.row' + currentPosition.y + '.col' + currentPosition.x);
            direction = path.shift();
            if (!currentPosition.equals(this.maze.start)) {
              currentCell.addClass('move_' + direction);
            }
            _results.push(currentPosition = currentPosition.afterMove(direction));
          }
          return _results;
        }
      },
      _clearMaze: function() {
        return this.element.find('table').remove();
      },
      _buildMaze: function() {
        var ci, ri, row, table, _i, _j, _ref, _ref1;
        table = $('<table class="maze"></table>');
        for (ri = _i = _ref = this.maze.height() - 1; _ref <= 0 ? _i <= 0 : _i >= 0; ri = _ref <= 0 ? ++_i : --_i) {
          row = $('<tr></tr>').appendTo(table);
          for (ci = _j = 0, _ref1 = this.maze.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; ci = 0 <= _ref1 ? ++_j : --_j) {
            $('<td></td>').addClass('row' + ri).addClass('col' + ci).droppable({
              hoverClass: 'highlight',
              drop: this._getDropHandler(this)
            }).appendTo(row);
          }
        }
        return this.element.append(table);
      },
      _renderMaze: function() {
        var cell, ci, doors, klass, ri, table, _i, _ref, _results;
        table = this.element.find('table');
        _results = [];
        for (ri = _i = 0, _ref = this.maze.height() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; ri = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (ci = _j = 0, _ref1 = this.maze.width() - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; ci = 0 <= _ref1 ? ++_j : --_j) {
              doors = this.maze.getRoom({
                x: ci,
                y: ri
              }).doors;
              klass = 'row' + ri + ' col' + ci + ' ' + doors.map(function(d) {
                return d.toLowerCase();
              }).join(' ');
              cell = table.find('td.row' + ri + '.col' + ci);
              cell.attr('class', klass);
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
        var head, permutedTail, result, tail;
        if (set.length === 0) {
          return [];
        } else if (set.length === 1) {
          return [[set[0]], []];
        } else {
          head = set[set.length - 1];
          tail = set.slice(0, set.length - 1);
          permutedTail = this._permute(tail);
          result = permutedTail.concat(permutedTail.map(function(perm) {
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
