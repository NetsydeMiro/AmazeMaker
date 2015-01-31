(function() {
  define(['Direction', 'Room'], function(Direction, Room) {
    return describe('Room', function() {
      describe('constructor', function() {
        it('defaults to no doors', function() {
          var room;
          room = new Room;
          return expect(room.doors).toEqual([]);
        });
        it('initializes doors properly', function() {
          var room;
          room = new Room([Direction.NORTH, Direction.SOUTH]);
          return expect(room.doors).toEqual([Direction.NORTH, Direction.SOUTH]);
        });
        return it('wraps single door into array', function() {
          var room;
          room = new Room(Direction.NORTH);
          return expect(room.doors).toEqual([Direction.NORTH]);
        });
      });
      describe('#contains()', function() {
        it('returns true if room contains item', function() {
          var room;
          room = new Room;
          room.add('treasure');
          return expect(room.contains('treasure')).toBe(true);
        });
        return it("returns false if room doesn't contain item", function() {
          var room;
          room = new Room;
          room.add('treasure');
          return expect(room.contains('monster')).toBe(false);
        });
      });
      describe('#isEmpty()', function() {
        it('returns true if room empty', function() {
          var room;
          room = new Room;
          return expect(room.isEmpty()).toBe(true);
        });
        return it("returns false if room not empty", function() {
          var room;
          room = new Room;
          room.add('treasure');
          return expect(room.isEmpty()).toBe(false);
        });
      });
      describe('#hasDoor()', function() {
        it('is true if room has door at specified diretion', function() {
          var room;
          room = new Room(Direction.SOUTH);
          return expect(room.hasDoor(Direction.SOUTH)).toBe(true);
        });
        return it('is false if room has wall at specified diretion', function() {
          var room;
          room = new Room(Direction.SOUTH);
          return expect(room.hasDoor(Direction.NORTH)).toBe(false);
        });
      });
      describe('#hasWall()', function() {
        it('is true if room has wall at specified direction', function() {
          var room;
          room = new Room(Direction.SOUTH);
          return expect(room.hasWall(Direction.NORTH)).toBe(true);
        });
        return it('is false if room has door at specified direction', function() {
          var room;
          room = new Room(Direction.SOUTH);
          return expect(room.hasWall(Direction.SOUTH)).toBe(false);
        });
      });
      describe('#sealDoor()', function() {
        it('removes door if present', function() {
          var room;
          room = new Room(Direction.NORTH);
          expect(room.doors.length).toEqual(1);
          room.sealDoor(Direction.NORTH);
          return expect(room.doors.length).toEqual(0);
        });
        it('leaves wall if present', function() {
          var room;
          room = new Room(Direction.NORTH);
          expect(room.doors.length).toEqual(1);
          room.sealDoor(Direction.SOUTH);
          return expect(room.doors.length).toEqual(1);
        });
        return it('returns self for chaining', function() {
          var room;
          room = new Room;
          return expect(room.sealDoor(Direction.SOUTH)).toBe(room);
        });
      });
      describe('#openWall()', function() {
        it('inserts door if not present', function() {
          var room;
          room = new Room([]);
          expect(room.doors.length).toEqual(0);
          room.openWall(Direction.NORTH);
          return expect(room.doors).toEqual([Direction.NORTH]);
        });
        it('leaves door if present', function() {
          var room;
          room = new Room(Direction.NORTH);
          expect(room.doors.length).toEqual(1);
          room.openWall(Direction.NORTH);
          return expect(room.doors).toEqual([Direction.NORTH]);
        });
        return it('returns self for chaining', function() {
          var room;
          room = new Room;
          return expect(room.openWall(Direction.SOUTH)).toBe(room);
        });
      });
      describe('#equals()', function() {
        it('returns true if rooms have same doors and items', function() {
          var room1, room2;
          room1 = new Room([Direction.NORTH, Direction.SOUTH]);
          room2 = new Room([Direction.SOUTH, Direction.NORTH]);
          room1.add('x');
          room1.add('y');
          room2.add('y');
          room2.add('x');
          return expect(room1.equals(room2)).toBe(true);
        });
        it('returns false if rooms have different doors', function() {
          var room1, room2;
          room1 = new Room([Direction.NORTH, Direction.SOUTH]);
          room2 = new Room([Direction.SOUTH, Direction.EAST]);
          room1.add('x');
          room1.add('y');
          room2.add('y');
          room2.add('x');
          return expect(room1.equals(room2)).toBe(false);
        });
        return it('returns false if rooms have different items', function() {
          var room1, room2;
          room1 = new Room([Direction.NORTH, Direction.SOUTH]);
          room2 = new Room([Direction.SOUTH, Direction.NORTH]);
          room1.add('x');
          room1.add('y');
          room2.add('x');
          room2.add('z');
          return expect(room1.equals(room2)).toBe(false);
        });
      });
      return describe('#clearItems()', function() {
        return it('clears all the rooms items', function() {
          var room1;
          room1 = new Room;
          room1.add('junk');
          expect(room1.isEmpty()).toBe(false);
          room1.clearItems();
          return expect(room1.isEmpty()).toBe(true);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=RoomSpec.js.map
