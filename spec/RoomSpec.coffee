define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Room', -> 

    describe 'Constructor', -> 

      it 'defaults to no doors', ->
        room = new AmazeMaker.Room
        expect(room.doors).toEqual []

      it 'initializes doors properly', ->
        room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.South])
        expect(room.doors).toEqual [AmazeMaker.Directions.North, AmazeMaker.Directions.South]

      it 'wraps single door into array', ->
        room = new AmazeMaker.Room(AmazeMaker.Directions.North)
        expect(room.doors).toEqual [AmazeMaker.Directions.North]

    describe '#contains()', -> 

      it 'returns true if room contains item', -> 
        room = new AmazeMaker.Room()
        room.add 'treasure'
        expect(room.contains 'treasure').toBe true

      it "returns false if room doesn't contain item", -> 
        room = new AmazeMaker.Room()
        room.add 'treasure'
        expect(room.contains 'monster').toBe false

    describe '#is_empty()', -> 

      it 'returns true if room empty', -> 
        room = new AmazeMaker.Room()
        expect(room.is_empty()).toBe true

      it "returns false if room not empty", -> 
        room = new AmazeMaker.Room()
        room.add 'treasure'
        expect(room.is_empty()).toBe false

    describe '#has_door()', -> 

      it 'is true if room has door at specified diretion', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.South)
        expect(room.has_door AmazeMaker.Directions.South).toBe true

      it 'is false if room has wall at specified diretion', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.South)
        expect(room.has_door AmazeMaker.Directions.North).toBe false

    describe '#has_wall()', -> 

      it 'is true if room has wall at specified direction', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.South)
        expect(room.has_wall AmazeMaker.Directions.North).toBe true

      it 'is false if room has door at specified direction', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.South)
        expect(room.has_wall AmazeMaker.Directions.South).toBe false


    describe '#seal_door()', -> 

      it 'removes door if present', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.North)
        expect(room.doors.length).toEqual 1

        room.seal_door AmazeMaker.Directions.North
        expect(room.doors.length).toEqual 0

      it 'leaves wall if present', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.North)
        expect(room.doors.length).toEqual 1

        room.seal_door AmazeMaker.Directions.South
        expect(room.doors.length).toEqual 1

      it 'returns self for chaining', -> 
        room = new AmazeMaker.Room
        expect(room.seal_door AmazeMaker.Directions.South).toBe room

    describe '#open_wall()', -> 

      it 'inserts door if not present', -> 
        room = new AmazeMaker.Room([])
        expect(room.doors.length).toEqual 0

        room.open_wall AmazeMaker.Directions.North
        expect(room.doors).toEqual [AmazeMaker.Directions.North]

      it 'leaves door if present', -> 
        room = new AmazeMaker.Room(AmazeMaker.Directions.North)
        expect(room.doors.length).toEqual 1

        room.open_wall AmazeMaker.Directions.North
        expect(room.doors).toEqual [AmazeMaker.Directions.North]

      it 'returns self for chaining', -> 
        room = new AmazeMaker.Room
        expect(room.open_wall AmazeMaker.Directions.South).toBe room
