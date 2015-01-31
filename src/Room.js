(function() {
  define(function() {
    var Room;
    return Room = (function() {
      function Room(doors) {
        if (doors == null) {
          doors = [];
        }
        if (doors.constructor === Array) {
          this.doors = doors.slice();
        } else {
          this.doors = [doors];
        }
        this.items = [];
      }

      Room.prototype.isEmpty = function() {
        return this.items.length === 0;
      };

      Room.prototype.add = function(item) {
        return this.items.push(item);
      };

      Room.prototype.clearItems = function() {
        return this.items = [];
      };

      Room.prototype.contains = function(item) {
        return this.items.indexOf(item) !== -1;
      };

      Room.prototype.sealDoor = function(direction) {
        var index;
        if ((index = this.doors.indexOf(direction)) !== -1) {
          this.doors.splice(index, 1);
        }
        return this;
      };

      Room.prototype.openWall = function(direction) {
        if (this.doors.indexOf(direction) === -1) {
          this.doors.push(direction);
        }
        return this;
      };

      Room.prototype.hasDoor = function(direction) {
        return this.doors.indexOf(direction) !== -1;
      };

      Room.prototype.hasWall = function(direction) {
        return !this.hasDoor(direction);
      };

      Room.prototype.equals = function(room) {
        var room_doors, room_items, this_doors, this_items, x, _i, _j, _ref, _ref1;
        if (this.items.length !== room.items.length || this.doors.length !== room.doors.length) {
          return false;
        } else {
          this_doors = this.doors.slice().sort();
          room_doors = room.doors.slice().sort();
          for (x = _i = 0, _ref = this.doors.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
            if (this_doors[x] !== room_doors[x]) {
              return false;
            }
          }
          this_items = this.items.slice().sort();
          room_items = room.items.slice().sort();
          for (x = _j = 0, _ref1 = this.items.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            if (this_items[x] !== room_items[x]) {
              return false;
            }
          }
          return true;
        }
      };

      return Room;

    })();
  });

}).call(this);

//# sourceMappingURL=Room.js.map
