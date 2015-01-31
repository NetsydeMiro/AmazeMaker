(function() {
  define(['Direction', 'Position'], function(Direction, Position) {
    return describe('Position', function() {
      var position;
      position = null;
      beforeEach(function() {
        return position = new Position(1, 1);
      });
      describe('#equals()', function() {
        it("returns true if coords equal", function() {
          var pos1, pos2;
          pos1 = new Position(1, 1);
          pos2 = new Position(1, 1);
          return expect(pos1.equals(pos2)).toBe(true);
        });
        return it("returns false if coords unequal", function() {
          var pos1, pos2;
          pos1 = new Position(1, 1);
          pos2 = new Position(1, 2);
          expect(pos1.equals(pos2)).toBe(false);
          pos1 = new Position(1, 1);
          pos2 = new Position(2, 1);
          return expect(pos1.equals(pos2)).toBe(false);
        });
      });
      return describe('#afterMove()', function() {
        it("leaves position unchanged", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.NORTH);
          expect(position.x).toEqual(1);
          expect(position.y).toEqual(1);
          return expect(position).toEqual(jasmine.any(Position));
        });
        it("returns new position", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.NORTH);
          expect(new_pos).toEqual(jasmine.any(Position));
          return expect(new_pos).not.toEqual(position);
        });
        it("correctly calculates move North", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.NORTH);
          expect(new_pos.x).toEqual(1);
          return expect(new_pos.y).toEqual(2);
        });
        it("correctly calculates move East", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.EAST);
          expect(new_pos.x).toEqual(2);
          return expect(new_pos.y).toEqual(1);
        });
        it("correctly calculates move South", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.SOUTH);
          expect(new_pos.x).toEqual(1);
          return expect(new_pos.y).toEqual(0);
        });
        return it("correctly calculates move West", function() {
          var new_pos;
          new_pos = position.afterMove(Direction.WEST);
          expect(new_pos.x).toEqual(0);
          return expect(new_pos.y).toEqual(1);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=PositionSpec.js.map
