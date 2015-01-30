define ['Direction', 'Position'], (Direction, Position) -> 

  describe 'Position', -> 
    position = null

    beforeEach ->
      position = new Position(1,1)

    describe '#equals()', -> 

      it "returns true if coords equal", -> 
        pos1 = new Position(1,1)
        pos2 = new Position(1,1)
        expect(pos1.equals(pos2)).toBe true

      it "returns false if coords unequal", -> 
        pos1 = new Position(1,1)
        pos2 = new Position(1,2)
        expect(pos1.equals(pos2)).toBe false

        pos1 = new Position(1,1)
        pos2 = new Position(2,1)
        expect(pos1.equals(pos2)).toBe false

    describe '#afterMove()', -> 

      it "leaves position unchanged", -> 
        new_pos = position.afterMove Direction.NORTH
        expect(position.x).toEqual 1
        expect(position.y).toEqual 1
        expect(position).toEqual jasmine.any(Position)

      it "returns new position", -> 
        new_pos = position.afterMove Direction.NORTH
        expect(new_pos).toEqual jasmine.any(Position)
        expect(new_pos).not.toEqual position

      it "correctly calculates move North", -> 
        new_pos = position.afterMove Direction.NORTH
        expect(new_pos.x).toEqual 1
        expect(new_pos.y).toEqual 2

      it "correctly calculates move East", -> 
        new_pos = position.afterMove Direction.EAST
        expect(new_pos.x).toEqual 2
        expect(new_pos.y).toEqual 1

      it "correctly calculates move South", -> 
        new_pos = position.afterMove Direction.SOUTH
        expect(new_pos.x).toEqual 1
        expect(new_pos.y).toEqual 0

      it "correctly calculates move West", -> 
        new_pos = position.afterMove Direction.WEST
        expect(new_pos.x).toEqual 0
        expect(new_pos.y).toEqual 1
