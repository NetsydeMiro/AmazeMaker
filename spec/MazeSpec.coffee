define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Maze', -> 

    amaze = null

    beforeEach -> 

      amaze = new AmazeMaker.Maze(2,2)

      room = new AmazeMaker.Room(AmazeMaker.Directions.East)
      room.add('NW')
      amaze.set_room(room,0,1)

      room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South])
      room.add('NE')
      amaze.set_room(room,1,1)

      room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West])
      room.add('SW')
      amaze.set_room(room,1,0)

      room = new AmazeMaker.Room(AmazeMaker.Directions.East)
      room.add('SE')
      amaze.set_room(room,0,0)

    describe "Constructor", -> 

      it 'sets maze to correct height and width', -> 
        newMaze = new AmazeMaker.Maze(3,4)
        expect(newMaze.width()).toEqual 3
        expect(newMaze.height()).toEqual 4

      it 'initializes maze to empty rooms with all doors', -> 
        newMaze = new AmazeMaker.Maze(2,3)
        expect(newMaze.rooms.length).toEqual 2
        expect(newMaze.rooms[0].length).toEqual 3
        expect(newMaze.rooms[1].length).toEqual 3

        for x in [0..1]
          for y in [0..2]
            expect(newMaze.rooms[x][y].is_empty()).toBe true
            expect(newMaze.rooms[x][y].doors).toEqual [AmazeMaker.Directions.North, 
              AmazeMaker.Directions.East, 
              AmazeMaker.Directions.South, 
              AmazeMaker.Directions.West]

      it 'initializes position to null', -> 
        newMaze = new AmazeMaker.Maze(3,4)
        expect(newMaze.position).toBeNull()

    describe "#current_room()", -> 

      it "returns null if position not set", -> 
        newMaze = new AmazeMaker.Maze(3,4)
        expect(newMaze.current_room()).toBeNull()

      it "returns correct room if position set", -> 
        amaze.set_position(1,1)
        expect(amaze.current_room()).toBe amaze.rooms[1][1]
        expect(amaze.current_room().contains('NE')).toBe true

    describe '#set_position()', -> 

      it "sets position", -> 
        amaze.set_position 1, 0
        expect(amaze.position).toEqual {x:1,y:0}

      it "returns the map for chaining", -> 
        expect(amaze.set_position 1,0).toBe amaze

    describe '#go()', -> 

      it "returns map when move possible", -> 
        amaze.set_position(0,0)
        expect(amaze.go AmazeMaker.Directions.North).toBe amaze

      it "updates map position correctly when moving North", -> 
        amaze.set_position(0,0)
        amaze.go AmazeMaker.Directions.North
        expect(amaze.position).toEqual {x:0, y:1}

      it "updates map position correctly when moving East", -> 
        amaze.set_position(0,0)
        amaze.go AmazeMaker.Directions.East
        expect(amaze.position).toEqual {x:1, y:0}

      it "updates map position correctly when moving South", -> 
        amaze.set_position(1,1)
        amaze.go AmazeMaker.Directions.South
        expect(amaze.position).toEqual {x:1, y:0}

      it "updates map position correctly when moving West", -> 
        amaze.set_position(1,1)
        amaze.go AmazeMaker.Directions.West
        expect(amaze.position).toEqual {x:0, y:1}

      it "returns false when attempting to move through north wall", -> 
        amaze.set_position(1,1)
        expect(amaze.go AmazeMaker.Directions.North).toBe false

      it "returns false when attempting to move through east wall", -> 
        amaze.set_position(1,1)
        expect(amaze.go AmazeMaker.Directions.East).toBe false

      it "returns false when attempting to move through south wall", -> 
        amaze.set_position(0,0)
        expect(amaze.go AmazeMaker.Directions.South).toBe false

      it "returns false when attempting to move through west wall", -> 
        amaze.set_position(0,0)
        expect(amaze.go AmazeMaker.Directions.West).toBe false
