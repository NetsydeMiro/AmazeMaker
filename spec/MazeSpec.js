(function() {
  define(['Direction', 'Position', 'Room', 'Maze'], function(Direction, Position, Room, Maze) {
    return describe('Maze', function() {
      var amaze;
      amaze = null;
      beforeEach(function() {
        var room;
        amaze = new Maze(2, 2);
        room = new Room(Direction.EAST);
        room.add('NW');
        amaze.setRoom(new Position(0, 1), room);
        room = new Room([Direction.WEST, Direction.SOUTH]);
        room.add('NE');
        amaze.setRoom(new Position(1, 1), room);
        room = new Room([Direction.NORTH, Direction.WEST]);
        room.add('SW');
        amaze.setRoom(new Position(1, 0), room);
        room = new Room(Direction.EAST);
        room.add('SE');
        return amaze.setRoom(new Position(0, 0), room);
      });
      describe("constructor", function() {
        it('sets maze to correct height and width', function() {
          var newMaze;
          newMaze = new Maze(3, 4);
          expect(newMaze.width()).toEqual(3);
          return expect(newMaze.height()).toEqual(4);
        });
        return it('initializes maze to empty unwalled rooms within walled labyrinth', function() {
          var newMaze, x, y, _i, _results;
          newMaze = new Maze(3, 3);
          _results = [];
          for (x = _i = 0; _i <= 2; x = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (y = _j = 0; _j <= 2; y = ++_j) {
                expect(newMaze.rooms[x][y].isEmpty()).toBe(true);
                if (y !== 2) {
                  expect(newMaze.rooms[x][y].doors).toContain(Direction.NORTH);
                }
                if (y === 2) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Direction.NORTH);
                }
                if (x !== 2) {
                  expect(newMaze.rooms[x][y].doors).toContain(Direction.EAST);
                }
                if (x === 2) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Direction.EAST);
                }
                if (y !== 0) {
                  expect(newMaze.rooms[x][y].doors).toContain(Direction.SOUTH);
                }
                if (y === 0) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Direction.SOUTH);
                }
                if (x !== 0) {
                  expect(newMaze.rooms[x][y].doors).toContain(Direction.WEST);
                }
                if (x === 0) {
                  _results1.push(expect(newMaze.rooms[x][y].doors).not.toContain(Direction.WEST));
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            })());
          }
          return _results;
        });
      });
      describe('#equals()', function() {
        var amaze2;
        amaze2 = null;
        beforeEach(function() {
          var room;
          amaze2 = new Maze(2, 2);
          room = new Room(Direction.EAST);
          room.add('NW');
          amaze2.setRoom(new Position(0, 1), room);
          room = new Room([Direction.WEST, Direction.SOUTH]);
          room.add('NE');
          amaze2.setRoom(new Position(1, 1), room);
          room = new Room([Direction.NORTH, Direction.WEST]);
          room.add('SW');
          amaze2.setRoom(new Position(1, 0), room);
          room = new Room(Direction.EAST);
          room.add('SE');
          return amaze2.setRoom(new Position(0, 0), room);
        });
        it('returns true if mazes have equal rooms, starts, and targets', function() {
          return expect(amaze.equals(amaze2)).toBe(true);
        });
        it('returns false if mazes have different rooms', function() {
          amaze2.getRoom({
            x: 0,
            y: 0
          }).add('another item');
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns false if mazes have different starts', function() {
          amaze2.setStart({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns false if mazes have different goals', function() {
          amaze2.setGoal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns true if mazes have same goals', function() {
          amaze.setGoal({
            x: 0,
            y: 1
          });
          amaze2.setGoal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(true);
        });
        return it('returns true if mazes have same starts', function() {
          amaze.setGoal({
            x: 0,
            y: 1
          });
          amaze2.setGoal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(true);
        });
      });
      describe('#setRoom()', function() {
        var closedroom, openroom;
        openroom = null;
        closedroom = null;
        beforeEach(function() {
          openroom = new Room(Direction.ALL);
          closedroom = new Room([]);
          return amaze = new Maze(5, 5);
        });
        it("seals room's northern/western doors if placed on boundary", function() {
          amaze.setRoom({
            x: 0,
            y: 4
          }, openroom);
          expect(openroom.doors.length).toEqual(2);
          expect(openroom.doors).toContain(Direction.EAST);
          return expect(openroom.doors).toContain(Direction.SOUTH);
        });
        it("seals room's southern/eastern doors if placed on boundary", function() {
          amaze.setRoom({
            x: 4,
            y: 0
          }, openroom);
          expect(openroom.doors.length).toEqual(2);
          expect(openroom.doors).toContain(Direction.NORTH);
          return expect(openroom.doors).toContain(Direction.WEST);
        });
        it("does nothing if placed in middle", function() {
          amaze.setRoom({
            x: 3,
            y: 3
          }, openroom);
          expect(openroom.doors.length).toEqual(4);
          expect(openroom.doors).toContain(Direction.NORTH);
          expect(openroom.doors).toContain(Direction.WEST);
          expect(openroom.doors).toContain(Direction.EAST);
          return expect(openroom.doors).toContain(Direction.SOUTH);
        });
        it("seals adjacent rooms' doors if wall placed adjacent", function() {
          var center, east, north, south, west;
          center = new Position(2, 2);
          amaze.setRoom(center, closedroom);
          west = amaze.getRoom(center.afterMove(Direction.WEST));
          expect(west.doors.length).toEqual(3);
          expect(west.doors).not.toContain(Direction.EAST);
          east = amaze.getRoom(center.afterMove(Direction.EAST));
          expect(east.doors.length).toEqual(3);
          expect(east.doors).not.toContain(Direction.WEST);
          north = amaze.getRoom(center.afterMove(Direction.NORTH));
          expect(north.doors.length).toEqual(3);
          expect(north.doors).not.toContain(Direction.SOUTH);
          south = amaze.getRoom(center.afterMove(Direction.SOUTH));
          expect(south.doors.length).toEqual(3);
          return expect(south.doors).not.toContain(Direction.NORTH);
        });
        return it("opens adjacent room's walls if door placed adjacent", function() {
          var center, east, north, south, west, x, y, _i, _j;
          center = new Position(3, 3);
          for (x = _i = 0; _i <= 4; x = ++_i) {
            for (y = _j = 0; _j <= 4; y = ++_j) {
              amaze.getRoom({
                x: x,
                y: y
              }).doors = [];
            }
          }
          amaze.setRoom(center, openroom);
          west = amaze.getRoom(center.afterMove(Direction.WEST));
          expect(west.doors).toEqual([Direction.EAST]);
          east = amaze.getRoom(center.afterMove(Direction.EAST));
          expect(east.doors).toEqual([Direction.WEST]);
          north = amaze.getRoom(center.afterMove(Direction.NORTH));
          expect(north.doors).toEqual([Direction.SOUTH]);
          south = amaze.getRoom(center.afterMove(Direction.SOUTH));
          return expect(south.doors).toEqual([Direction.NORTH]);
        });
      });
      describe('#withinBounds()', function() {
        var position;
        position = new Position(0, 0);
        it("returns true when position in bounds", function() {
          position.x = 0;
          position.y = 0;
          expect(amaze.withinBounds(position)).toBe(true);
          position.x = 0;
          position.y = 1;
          expect(amaze.withinBounds(position)).toBe(true);
          position.x = 1;
          position.y = 0;
          expect(amaze.withinBounds(position)).toBe(true);
          position.x = 1;
          position.y = 1;
          return expect(amaze.withinBounds(position)).toBe(true);
        });
        return it("returns false when past a wall", function() {
          position.x = -1;
          position.y = 0;
          expect(amaze.withinBounds(position)).toBe(false);
          position.x = 2;
          position.y = 0;
          expect(amaze.withinBounds(position)).toBe(false);
          position.x = 0;
          position.y = -1;
          expect(amaze.withinBounds(position)).toBe(false);
          position.x = 0;
          position.y = 2;
          return expect(amaze.withinBounds(position)).toBe(false);
        });
      });
      describe('#atBounds()', function() {
        var position;
        position = new Position(0, 0);
        it("returns bounds when position at bounds", function() {
          var bounds;
          position.x = 0;
          position.y = 0;
          bounds = amaze.atBounds(position);
          expect(bounds.length).toBe(2);
          expect(bounds).toContain(Direction.SOUTH);
          return expect(bounds).toContain(Direction.WEST);
        });
        it("returns bounds when position at north eastern bounds", function() {
          var bounds;
          position.x = 1;
          position.y = 1;
          bounds = amaze.atBounds(position);
          expect(bounds.length).toBe(2);
          expect(bounds).toContain(Direction.NORTH);
          return expect(bounds).toContain(Direction.EAST);
        });
        return it("returns empty when not at bounds", function() {
          var bounds;
          amaze = new Maze(3, 3);
          position.x = 1;
          position.y = 1;
          bounds = amaze.atBounds(position);
          return expect(bounds).toEqual([]);
        });
      });
      describe('#toString()', function() {
        it("returns correct string representation", function() {
          amaze.setStart({
            x: 0,
            y: 1
          });
          amaze.setGoal({
            x: 0,
            y: 0
          });
          return expect(amaze.toString()).toEqual("-----\n|s  |\n--  -\n|g  |\n-----");
        });
        return it("works when start and goal aren't set", function() {
          return expect(amaze.toString()).toEqual("-----\n|   |\n--  -\n|   |\n-----");
        });
      });
      describe('::fromString()', function() {
        return it("correctly initializes maze", function() {
          var deserialized, serialized;
          amaze.setStart({
            x: 0,
            y: 1
          });
          amaze.setGoal({
            x: 0,
            y: 0
          });
          amaze.getRoom({
            x: 0,
            y: 0
          }).items = [];
          amaze.getRoom({
            x: 0,
            y: 1
          }).items = [];
          amaze.getRoom({
            x: 1,
            y: 0
          }).items = [];
          amaze.getRoom({
            x: 1,
            y: 1
          }).items = [];
          serialized = "-----\n|s  |\n--  -\n|g  |\n-----";
          deserialized = Maze.fromString(serialized);
          return expect(deserialized.equals(amaze)).toBe(true);
        });
      });
      return describe('#clearItems()', function() {
        return it('clears maze of items', function() {
          var x, y, _i, _results;
          amaze.clearItems();
          _results = [];
          for (x = _i = 0; _i <= 1; x = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (y = _j = 0; _j <= 1; y = ++_j) {
                _results1.push(expect(amaze.getRoom({
                  x: x,
                  y: y
                }).isEmpty()).toBe(true));
              }
              return _results1;
            })());
          }
          return _results;
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=MazeSpec.js.map
