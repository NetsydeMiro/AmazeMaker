(function() {
  define(['AmazeMaker'], function(AmazeMaker) {
    var Directions, Room;
    Room = AmazeMaker.Room;
    Directions = AmazeMaker.Directions;
    return describe('Room', function() {
      describe('Constructor', function() {
        it('defaults to no doors', function() {
          var room;
          room = new Room;
          return expect(room.doors).toEqual([]);
        });
        it('initializes doors properly', function() {
          var room;
          room = new Room([Directions.North, Directions.South]);
          return expect(room.doors).toEqual([Directions.North, Directions.South]);
        });
        return it('wraps single door into array', function() {
          var room;
          room = new Room(Directions.North);
          return expect(room.doors).toEqual([Directions.North]);
        });
      });
      describe('#contains()', function() {
        it('returns true if room contains item', function() {
          var room;
          room = new Room();
          room.add('treasure');
          return expect(room.contains('treasure')).toBe(true);
        });
        return it("returns false if room doesn't contain item", function() {
          var room;
          room = new Room();
          room.add('treasure');
          return expect(room.contains('monster')).toBe(false);
        });
      });
      describe('#is_empty()', function() {
        it('returns true if room empty', function() {
          var room;
          room = new Room();
          return expect(room.is_empty()).toBe(true);
        });
        return it("returns false if room not empty", function() {
          var room;
          room = new Room();
          room.add('treasure');
          return expect(room.is_empty()).toBe(false);
        });
      });
      describe('#has_door()', function() {
        it('is true if room has door at specified diretion', function() {
          var room;
          room = new Room(Directions.South);
          return expect(room.has_door(Directions.South)).toBe(true);
        });
        return it('is false if room has wall at specified diretion', function() {
          var room;
          room = new Room(Directions.South);
          return expect(room.has_door(Directions.North)).toBe(false);
        });
      });
      describe('#has_wall()', function() {
        it('is true if room has wall at specified direction', function() {
          var room;
          room = new Room(Directions.South);
          return expect(room.has_wall(Directions.North)).toBe(true);
        });
        return it('is false if room has door at specified direction', function() {
          var room;
          room = new Room(Directions.South);
          return expect(room.has_wall(Directions.South)).toBe(false);
        });
      });
      describe('#seal_door()', function() {
        it('removes door if present', function() {
          var room;
          room = new Room(Directions.North);
          expect(room.doors.length).toEqual(1);
          room.seal_door(Directions.North);
          return expect(room.doors.length).toEqual(0);
        });
        it('leaves wall if present', function() {
          var room;
          room = new Room(Directions.North);
          expect(room.doors.length).toEqual(1);
          room.seal_door(Directions.South);
          return expect(room.doors.length).toEqual(1);
        });
        return it('returns self for chaining', function() {
          var room;
          room = new Room;
          return expect(room.seal_door(Directions.South)).toBe(room);
        });
      });
      describe('#open_wall()', function() {
        it('inserts door if not present', function() {
          var room;
          room = new Room([]);
          expect(room.doors.length).toEqual(0);
          room.open_wall(Directions.North);
          return expect(room.doors).toEqual([Directions.North]);
        });
        it('leaves door if present', function() {
          var room;
          room = new Room(Directions.North);
          expect(room.doors.length).toEqual(1);
          room.open_wall(Directions.North);
          return expect(room.doors).toEqual([Directions.North]);
        });
        return it('returns self for chaining', function() {
          var room;
          room = new Room;
          return expect(room.open_wall(Directions.South)).toBe(room);
        });
      });
      describe('#equals()', function() {
        it('returns true if rooms have same doors and items', function() {
          var room1, room2;
          room1 = new Room([Directions.North, Directions.South]);
          room2 = new Room([Directions.South, Directions.North]);
          room1.add('test1');
          room1.add('test2');
          room2.add('test2');
          room2.add('test1');
          return expect(room1.equals(room2)).toBe(true);
        });
        it('returns false if rooms have different doors', function() {
          var room1, room2;
          room1 = new Room([Directions.North, Directions.South]);
          room2 = new Room([Directions.South, Directions.East]);
          room1.add('test1');
          room1.add('test2');
          room2.add('test2');
          room2.add('test1');
          return expect(room1.equals(room2)).toBe(false);
        });
        return it('returns false if rooms have different items', function() {
          var room1, room2;
          room1 = new Room([Directions.North, Directions.South]);
          room2 = new Room([Directions.South, Directions.North]);
          room1.add('test1');
          room1.add('test2');
          room2.add('test1');
          room2.add('test3');
          return expect(room1.equals(room2)).toBe(false);
        });
      });
      return describe('#clear_items()', function() {
        return it('clears all the rooms items', function() {
          var room1;
          room1 = new Room;
          room1.add('junk');
          expect(room1.is_empty()).toBe(false);
          room1.clear_items();
          return expect(room1.is_empty()).toBe(true);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=RoomSpec.js.map
