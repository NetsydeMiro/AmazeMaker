define ['Direction', 'Room'], (Direction, Room) -> 

  describe 'Room', -> 

    describe 'constructor', -> 
      it 'defaults to no doors', ->
        room = new Room
        expect(room.doors).toEqual []

      it 'initializes doors properly', ->
        room = new Room [Direction.NORTH, Direction.SOUTH]
        expect(room.doors).toEqual [Direction.NORTH, Direction.SOUTH]

      it 'wraps single door into array', ->
        room = new Room Direction.NORTH
        expect(room.doors).toEqual [Direction.NORTH]

    describe '#walls()', -> 
      it 'returns no walls when room has only doors', -> 
        room = new Room Direction.ALL
        expect(room.walls()).toEqual []

      it 'returns all walls when room has only walls', -> 
        room = new Room []
        expect(room.walls()).toEqual Direction.ALL

      it 'returns correct walls when room has some doors', -> 
        room = new Room [Direction.NORTH, Direction.EAST]
        expect(room.walls().sort()).toEqual [Direction.SOUTH, Direction.WEST]

    describe '#contains()', -> 
      it 'returns true if room contains item', -> 
        room = new Room
        room.add 'treasure'
        expect(room.contains 'treasure').toBe true

      it "returns false if room doesn't contain item", -> 
        room = new Room
        room.add 'treasure'
        expect(room.contains 'monster').toBe false

    describe '#isEmpty()', -> 
      it 'returns true if room empty', -> 
        room = new Room
        expect(room.isEmpty()).toBe true

      it "returns false if room not empty", -> 
        room = new Room
        room.add 'treasure'
        expect(room.isEmpty()).toBe false

    describe '#hasDoor()', -> 
      it 'is true if room has door at specified diretion', -> 
        room = new Room(Direction.SOUTH)
        expect(room.hasDoor Direction.SOUTH).toBe true

      it 'is false if room has wall at specified diretion', -> 
        room = new Room(Direction.SOUTH)
        expect(room.hasDoor Direction.NORTH).toBe false

    describe '#hasWall()', -> 
      it 'is true if room has wall at specified direction', -> 
        room = new Room(Direction.SOUTH)
        expect(room.hasWall Direction.NORTH).toBe true

      it 'is false if room has door at specified direction', -> 
        room = new Room(Direction.SOUTH)
        expect(room.hasWall Direction.SOUTH).toBe false

    describe '#sealDoor()', -> 
      it 'removes door if present', -> 
        room = new Room(Direction.NORTH)
        expect(room.doors.length).toEqual 1

        room.sealDoor Direction.NORTH
        expect(room.doors.length).toEqual 0

      it 'leaves wall if present', -> 
        room = new Room(Direction.NORTH)
        expect(room.doors.length).toEqual 1

        room.sealDoor Direction.SOUTH
        expect(room.doors.length).toEqual 1

      it 'returns self for chaining', -> 
        room = new Room
        expect(room.sealDoor Direction.SOUTH).toBe room

    describe '#openWall()', -> 
      it 'inserts door if not present', -> 
        room = new Room([])
        expect(room.doors.length).toEqual 0

        room.openWall Direction.NORTH
        expect(room.doors).toEqual [Direction.NORTH]

      it 'leaves door if present', -> 
        room = new Room(Direction.NORTH)
        expect(room.doors.length).toEqual 1

        room.openWall Direction.NORTH
        expect(room.doors).toEqual [Direction.NORTH]

      it 'returns self for chaining', -> 
        room = new Room
        expect(room.openWall Direction.SOUTH).toBe room

    describe '#equals()', -> 
      it 'returns true if rooms have same doors and items', -> 
        room1 = new Room [Direction.NORTH, Direction.SOUTH]
        room2 = new Room [Direction.SOUTH, Direction.NORTH]

        room1.add 'x'
        room1.add 'y'
        room2.add 'y'
        room2.add 'x'

        expect(room1.equals room2).toBe true

      it 'returns false if rooms have different doors', -> 
        room1 = new Room [Direction.NORTH, Direction.SOUTH]
        room2 = new Room [Direction.SOUTH, Direction.EAST]

        room1.add 'x'
        room1.add 'y'
        room2.add 'y'
        room2.add 'x'

        expect(room1.equals room2).toBe false

      it 'returns false if rooms have different items', -> 
        room1 = new Room [Direction.NORTH, Direction.SOUTH]
        room2 = new Room [Direction.SOUTH, Direction.NORTH]

        room1.add 'x'
        room1.add 'y'
        room2.add 'x'
        room2.add 'z'

        expect(room1.equals room2).toBe false

    describe '#clearItems()', -> 
      it 'clears all the rooms items', -> 
        room1 = new Room 
        room1.add 'junk'
        expect(room1.isEmpty()).toBe false
        room1.clearItems()
        expect(room1.isEmpty()).toBe true
