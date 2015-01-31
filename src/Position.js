(function() {
  define(['Direction'], function(Direction) {
    var Position;
    return Position = (function() {
      function Position(x, y) {
        this.x = x;
        this.y = y;
      }

      Position.prototype.equals = function(coords) {
        return this.x === coords.x && this.y === coords.y;
      };

      Position.prototype.afterMove = function(direction) {
        var coords;
        coords = (function() {
          switch (direction) {
            case Direction.NORTH:
              return {
                x: this.x,
                y: this.y + 1
              };
            case Direction.EAST:
              return {
                x: this.x + 1,
                y: this.y
              };
            case Direction.SOUTH:
              return {
                x: this.x,
                y: this.y - 1
              };
            case Direction.WEST:
              return {
                x: this.x - 1,
                y: this.y
              };
          }
        }).call(this);
        return new Position(coords.x, coords.y);
      };

      Position.wrap = function(obj) {
        if (obj.constructor === Position) {
          return obj;
        } else {
          return new Position(obj.x, obj.y);
        }
      };

      return Position;

    })();
  });

}).call(this);

//# sourceMappingURL=Position.js.map
