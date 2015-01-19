define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Room', -> 

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

    describe '#doors', -> 

      it "lists all doors", -> 
        room = new AmazeMaker.Room([AmazeMaker.Directions.north, AmazeMaker.Directions.south])
        expect(room.doors).toEqual [AmazeMaker.Directions.north, AmazeMaker.Directions.south]
