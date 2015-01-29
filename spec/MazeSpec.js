(function() {
  define(['AmazeMaker'], function(AmazeMaker) {
    return describe('Maze', function() {
      var Directions, Maze, Position, Room, amaze;
      Maze = AmazeMaker.Maze;
      Position = AmazeMaker.Position;
      Room = AmazeMaker.Room;
      Directions = AmazeMaker.Directions;
      amaze = null;
      beforeEach(function() {
        var room;
        amaze = new Maze(2, 2);
        room = new Room(Directions.East);
        room.add('NW');
        amaze.set_room(new Position(0, 1), room);
        room = new Room([Directions.West, Directions.South]);
        room.add('NE');
        amaze.set_room(new Position(1, 1), room);
        room = new Room([Directions.North, Directions.West]);
        room.add('SW');
        amaze.set_room(new Position(1, 0), room);
        room = new Room(Directions.East);
        room.add('SE');
        return amaze.set_room(new Position(0, 0), room);
      });
      describe("Constructor", function() {
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
                expect(newMaze.rooms[x][y].is_empty()).toBe(true);
                if (y !== 2) {
                  expect(newMaze.rooms[x][y].doors).toContain(Directions.North);
                }
                if (y === 2) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Directions.North);
                }
                if (x !== 2) {
                  expect(newMaze.rooms[x][y].doors).toContain(Directions.East);
                }
                if (x === 2) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Directions.East);
                }
                if (y !== 0) {
                  expect(newMaze.rooms[x][y].doors).toContain(Directions.South);
                }
                if (y === 0) {
                  expect(newMaze.rooms[x][y].doors).not.toContain(Directions.South);
                }
                if (x !== 0) {
                  expect(newMaze.rooms[x][y].doors).toContain(Directions.West);
                }
                if (x === 0) {
                  _results1.push(expect(newMaze.rooms[x][y].doors).not.toContain(Directions.West));
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
          room = new Room(Directions.East);
          room.add('NW');
          amaze2.set_room(new Position(0, 1), room);
          room = new Room([Directions.West, Directions.South]);
          room.add('NE');
          amaze2.set_room(new Position(1, 1), room);
          room = new Room([Directions.North, Directions.West]);
          room.add('SW');
          amaze2.set_room(new Position(1, 0), room);
          room = new Room(Directions.East);
          room.add('SE');
          return amaze2.set_room(new Position(0, 0), room);
        });
        it('returns true if mazes have equal rooms, starts, and targets', function() {
          return expect(amaze.equals(amaze2)).toBe(true);
        });
        it('returns false if mazes have different rooms', function() {
          amaze2.get_room({
            x: 0,
            y: 0
          }).add('another item');
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns false if mazes have different starts', function() {
          amaze2.set_start({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns false if mazes have different goals', function() {
          amaze2.set_goal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(false);
        });
        it('returns true if mazes have same goals', function() {
          amaze.set_goal({
            x: 0,
            y: 1
          });
          amaze2.set_goal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(true);
        });
        return it('returns true if mazes have same starts', function() {
          amaze.set_goal({
            x: 0,
            y: 1
          });
          amaze2.set_goal({
            x: 0,
            y: 1
          });
          return expect(amaze.equals(amaze2)).toBe(true);
        });
      });
      describe('#set_room()', function() {
        var all_doors, closedroom, openroom;
        all_doors = null;
        openroom = null;
        closedroom = null;
        beforeEach(function() {
          all_doors = [Directions.North, Directions.East, Directions.South, Directions.West];
          openroom = new Room(all_doors);
          closedroom = new Room([]);
          return amaze = new Maze(5, 5);
        });
        it("seals room's northern/western doors if placed on boundary", function() {
          amaze.set_room({
            x: 0,
            y: 4
          }, openroom);
          expect(openroom.doors.length).toEqual(2);
          expect(openroom.doors).toContain(Directions.East);
          return expect(openroom.doors).toContain(Directions.South);
        });
        it("seals room's southern/eastern doors if placed on boundary", function() {
          amaze.set_room({
            x: 4,
            y: 0
          }, openroom);
          expect(openroom.doors.length).toEqual(2);
          expect(openroom.doors).toContain(Directions.North);
          return expect(openroom.doors).toContain(Directions.West);
        });
        it("does nothing if placed in middle", function() {
          amaze.set_room({
            x: 3,
            y: 3
          }, openroom);
          expect(openroom.doors.length).toEqual(4);
          expect(openroom.doors).toContain(Directions.North);
          expect(openroom.doors).toContain(Directions.West);
          expect(openroom.doors).toContain(Directions.East);
          return expect(openroom.doors).toContain(Directions.South);
        });
        it("seals adjacent rooms' doors if wall placed adjacent", function() {
          var center, east, north, south, west;
          center = new Position(2, 2);
          amaze.set_room(center, closedroom);
          west = amaze.get_room(center.after_move(Directions.West));
          expect(west.doors.length).toEqual(3);
          expect(west.doors).not.toContain(Directions.East);
          east = amaze.get_room(center.after_move(Directions.East));
          expect(east.doors.length).toEqual(3);
          expect(east.doors).not.toContain(Directions.West);
          north = amaze.get_room(center.after_move(Directions.North));
          expect(north.doors.length).toEqual(3);
          expect(north.doors).not.toContain(Directions.South);
          south = amaze.get_room(center.after_move(Directions.South));
          expect(south.doors.length).toEqual(3);
          return expect(south.doors).not.toContain(Directions.North);
        });
        return it("opens adjacent room's walls if door placed adjacent", function() {
          var center, east, north, south, west, x, y, _i, _j;
          center = new Position(3, 3);
          for (x = _i = 0; _i <= 4; x = ++_i) {
            for (y = _j = 0; _j <= 4; y = ++_j) {
              amaze.get_room({
                x: x,
                y: y
              }).doors = [];
            }
          }
          amaze.set_room(center, openroom);
          west = amaze.get_room(center.after_move(Directions.West));
          expect(west.doors).toEqual([Directions.East]);
          east = amaze.get_room(center.after_move(Directions.East));
          expect(east.doors).toEqual([Directions.West]);
          north = amaze.get_room(center.after_move(Directions.North));
          expect(north.doors).toEqual([Directions.South]);
          south = amaze.get_room(center.after_move(Directions.South));
          return expect(south.doors).toEqual([Directions.North]);
        });
      });
      describe('#within_bounds()', function() {
        var position;
        position = new Position(0, 0);
        it("returns true when position in bounds", function() {
          position.x = 0;
          position.y = 0;
          expect(amaze.within_bounds(position)).toBe(true);
          position.x = 0;
          position.y = 1;
          expect(amaze.within_bounds(position)).toBe(true);
          position.x = 1;
          position.y = 0;
          expect(amaze.within_bounds(position)).toBe(true);
          position.x = 1;
          position.y = 1;
          return expect(amaze.within_bounds(position)).toBe(true);
        });
        return it("returns false when past a wall", function() {
          position.x = -1;
          position.y = 0;
          expect(amaze.within_bounds(position)).toBe(false);
          position.x = 2;
          position.y = 0;
          expect(amaze.within_bounds(position)).toBe(false);
          position.x = 0;
          position.y = -1;
          expect(amaze.within_bounds(position)).toBe(false);
          position.x = 0;
          position.y = 2;
          return expect(amaze.within_bounds(position)).toBe(false);
        });
      });
      describe('#at_bounds()', function() {
        var position;
        position = new Position(0, 0);
        it("returns bounds when position at bounds", function() {
          var bounds;
          position.x = 0;
          position.y = 0;
          bounds = amaze.at_bounds(position);
          expect(bounds.length).toBe(2);
          expect(bounds).toContain(Directions.South);
          return expect(bounds).toContain(Directions.West);
        });
        it("returns bounds when position at north eastern bounds", function() {
          var bounds;
          position.x = 1;
          position.y = 1;
          bounds = amaze.at_bounds(position);
          expect(bounds.length).toBe(2);
          expect(bounds).toContain(Directions.North);
          return expect(bounds).toContain(Directions.East);
        });
        return it("returns empty when not at bounds", function() {
          var bounds;
          amaze = new Maze(3, 3);
          position.x = 1;
          position.y = 1;
          bounds = amaze.at_bounds(position);
          return expect(bounds).toEqual([]);
        });
      });
      describe('#to_string()', function() {
        it("returns correct string representation", function() {
          amaze.set_start({
            x: 0,
            y: 1
          });
          amaze.set_goal({
            x: 0,
            y: 0
          });
          return expect(amaze.to_string()).toEqual("-----\n|s  |\n--  -\n|g  |\n-----");
        });
        return it("works when start and goal aren't set", function() {
          return expect(amaze.to_string()).toEqual("-----\n|   |\n--  -\n|   |\n-----");
        });
      });
      describe('::from_string()', function() {
        return it("correctly initializes maze", function() {
          var deserialized, serialized;
          amaze.set_start({
            x: 0,
            y: 1
          });
          amaze.set_goal({
            x: 0,
            y: 0
          });
          amaze.get_room({
            x: 0,
            y: 0
          }).items = [];
          amaze.get_room({
            x: 0,
            y: 1
          }).items = [];
          amaze.get_room({
            x: 1,
            y: 0
          }).items = [];
          amaze.get_room({
            x: 1,
            y: 1
          }).items = [];
          serialized = "-----\n|s  |\n--  -\n|g  |\n-----";
          deserialized = Maze.from_string(serialized);
          return expect(deserialized.equals(amaze)).toBe(true);
        });
      });
      return describe('#clear_items()', function() {
        return it('clears maze of items', function() {
          var x, y, _i, _results;
          amaze.clear_items();
          _results = [];
          for (x = _i = 0; _i <= 1; x = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (y = _j = 0; _j <= 1; y = ++_j) {
                _results1.push(expect(amaze.get_room({
                  x: x,
                  y: y
                }).is_empty()).toBe(true));
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
