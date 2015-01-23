define ['AmazeMaker'], (AmazeMaker) -> 

  Room = AmazeMaker.Room
  Directions = AmazeMaker.Directions

  describe 'Room', -> 

    describe 'Constructor', -> 

      it 'defaults to no doors', ->
        room = new Room
        expect(room.doors).toEqual []

      it 'initializes doors properly', ->
        room = new Room([Directions.North, Directions.South])
        expect(room.doors).toEqual [Directions.North, Directions.South]

      it 'wraps single door into array', ->
        room = new Room(Directions.North)
        expect(room.doors).toEqual [Directions.North]

    describe '#contains()', -> 

      it 'returns true if room contains item', -> 
        room = new Room()
        room.add 'treasure'
        expect(room.contains 'treasure').toBe true

      it "returns false if room doesn't contain item", -> 
        room = new Room()
        room.add 'treasure'
        expect(room.contains 'monster').toBe false

    describe '#is_empty()', -> 

      it 'returns true if room empty', -> 
        room = new Room()
        expect(room.is_empty()).toBe true

      it "returns false if room not empty", -> 
        room = new Room()
        room.add 'treasure'
        expect(room.is_empty()).toBe false

    describe '#has_door()', -> 

      it 'is true if room has door at specified diretion', -> 
        room = new Room(Directions.South)
        expect(room.has_door Directions.South).toBe true

      it 'is false if room has wall at specified diretion', -> 
        room = new Room(Directions.South)
        expect(room.has_door Directions.North).toBe false

    describe '#has_wall()', -> 

      it 'is true if room has wall at specified direction', -> 
        room = new Room(Directions.South)
        expect(room.has_wall Directions.North).toBe true

      it 'is false if room has door at specified direction', -> 
        room = new Room(Directions.South)
        expect(room.has_wall Directions.South).toBe false


    describe '#seal_door()', -> 

      it 'removes door if present', -> 
        room = new Room(Directions.North)
        expect(room.doors.length).toEqual 1

        room.seal_door Directions.North
        expect(room.doors.length).toEqual 0

      it 'leaves wall if present', -> 
        room = new Room(Directions.North)
        expect(room.doors.length).toEqual 1

        room.seal_door Directions.South
        expect(room.doors.length).toEqual 1

      it 'returns self for chaining', -> 
        room = new Room
        expect(room.seal_door Directions.South).toBe room

    describe '#open_wall()', -> 

      it 'inserts door if not present', -> 
        room = new Room([])
        expect(room.doors.length).toEqual 0

        room.open_wall Directions.North
        expect(room.doors).toEqual [Directions.North]

      it 'leaves door if present', -> 
        room = new Room(Directions.North)
        expect(room.doors.length).toEqual 1

        room.open_wall Directions.North
        expect(room.doors).toEqual [Directions.North]

      it 'returns self for chaining', -> 
        room = new Room
        expect(room.open_wall Directions.South).toBe room

    describe '#equals()', -> 

      it 'returns true if rooms have same doors and items', -> 
        room1 = new Room [Directions.North, Directions.South]
        room2 = new Room [Directions.South, Directions.North]

        room1.add('test1')
        room1.add('test2')
        room2.add('test2')
        room2.add('test1')

        expect(room1.equals room2).toBe true

      it 'returns false if rooms have different doors', -> 
        room1 = new Room [Directions.North, Directions.South]
        room2 = new Room [Directions.South, Directions.East]

        room1.add('test1')
        room1.add('test2')
        room2.add('test2')
        room2.add('test1')

        expect(room1.equals room2).toBe false

      it 'returns false if rooms have different items', -> 
        room1 = new Room [Directions.North, Directions.South]
        room2 = new Room [Directions.South, Directions.North]

        room1.add('test1')
        room1.add('test2')
        room2.add('test1')
        room2.add('test3')

        expect(room1.equals room2).toBe false
