define ['Direction', 'Position', 'Room', 'Maze', 'Serializer'], 
(Direction, Position, Room, Maze, Serializer) -> 

  describe 'Serializer', -> 
    amaze = null

    beforeEach -> 
      amaze = new Maze(2,2)

      room = new Room(Direction.EAST)
      room.add 'NW'
      amaze.setRoom(new Position(0,1), room)

      room = new Room([Direction.WEST, Direction.SOUTH])
      room.add 'NE'
      amaze.setRoom(new Position(1,1), room)

      room = new Room([Direction.NORTH, Direction.WEST])
      room.add 'SW'
      amaze.setRoom(new Position(1,0), room)

      room = new Room(Direction.EAST)
      room.add 'SE'
      amaze.setRoom(new Position(0,0), room)


    describe '::toString()', -> 

      it "returns correct string representation", -> 

        amaze.setStart {x:0, y:1}
        amaze.setGoal {x:0, y:0}

        expect(Serializer.toString amaze).toEqual """
        -----
        |s  |
        --  -
        |g  |
        -----
        """

      it "works when start and goal aren't set", -> 

        expect(Serializer.toString amaze).toEqual """
        -----
        |   |
        --  -
        |   |
        -----
        """

    describe '::validMazeString()', -> 

      it 'must be at least 3 lines high (maze height of 1 room)', -> 

        invalid = """
        ---
        | |
        """
        expect(Serializer.validMazeString invalid).toBe false

      it 'must be have all dashes in first line (northern wall)', -> 

        invalid = """
        - -
        | |
        ---
        """
        expect(Serializer.validMazeString invalid).toBe false


    describe '::fromString()', -> 

      it "correctly initializes maze", -> 

        amaze.setStart {x:0, y:1}
        amaze.setGoal {x:0, y:0}

        amaze.getRoom(x:0, y:0).items = []
        amaze.getRoom(x:0, y:1).items = []
        amaze.getRoom(x:1, y:0).items = []
        amaze.getRoom(x:1, y:1).items = []

        serialized = """
        -----
        |s  |
        --  -
        |g  |
        -----
        """

        deserialized = Serializer.fromString serialized

        expect(deserialized.equals amaze).toBe true

      it "throws error if incorrect maze representation supplied", -> 

        clearlyNotMaze = "Blork Bleep"
        bomb = -> Serializer.fromString(clearlyNotMaze)
        expect(bomb).toThrow "Invalid Maze String: #{clearlyNotMaze}"


