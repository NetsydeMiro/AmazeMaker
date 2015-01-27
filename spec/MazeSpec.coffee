define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Maze', -> 

    Maze = AmazeMaker.Maze
    Position = AmazeMaker.Position
    Room = AmazeMaker.Room
    Directions = AmazeMaker.Directions
    amaze = null

    beforeEach -> 
      amaze = new Maze(2,2)

      room = new Room(Directions.East)
      room.add('NW')
      amaze.set_room(new Position(0,1), room)

      room = new Room([Directions.West, Directions.South])
      room.add('NE')
      amaze.set_room(new Position(1,1), room)

      room = new Room([Directions.North, Directions.West])
      room.add('SW')
      amaze.set_room(new Position(1,0), room)

      room = new Room(Directions.East)
      room.add('SE')
      amaze.set_room(new Position(0,0), room)

    describe "Constructor", -> 

      it 'sets maze to correct height and width', -> 
        newMaze = new Maze(3,4)
        expect(newMaze.width()).toEqual 3
        expect(newMaze.height()).toEqual 4

      it 'initializes maze to empty unwalled rooms within walled labyrinth', -> 
        newMaze = new Maze(3,3)

        for x in [0..2]
          for y in [0..2]
            expect(newMaze.rooms[x][y].is_empty()).toBe true

            expect(newMaze.rooms[x][y].doors).toContain(Directions.North) unless y is 2
            expect(newMaze.rooms[x][y].doors).not.toContain(Directions.North) if y is 2
            expect(newMaze.rooms[x][y].doors).toContain(Directions.East) unless x is 2
            expect(newMaze.rooms[x][y].doors).not.toContain(Directions.East) if x is 2
            expect(newMaze.rooms[x][y].doors).toContain(Directions.South) unless y is 0
            expect(newMaze.rooms[x][y].doors).not.toContain(Directions.South) if y is 0
            expect(newMaze.rooms[x][y].doors).toContain(Directions.West) unless x is 0
            expect(newMaze.rooms[x][y].doors).not.toContain(Directions.West) if x is 0

    describe '#equals()', -> 
      amaze2 = null
      
      beforeEach -> 
        amaze2 = new Maze(2,2)

        room = new Room(Directions.East)
        room.add('NW')
        amaze2.set_room(new Position(0,1), room)

        room = new Room([Directions.West, Directions.South])
        room.add('NE')
        amaze2.set_room(new Position(1,1), room)

        room = new Room([Directions.North, Directions.West])
        room.add('SW')
        amaze2.set_room(new Position(1,0), room)

        room = new Room(Directions.East)
        room.add('SE')
        amaze2.set_room(new Position(0,0), room)

      it 'returns true if mazes have equal rooms, starts, and targets', -> 
        expect(amaze.equals amaze2).toBe true

      it 'returns false if mazes have different rooms', -> 
        amaze2.get_room({x:0,y:0}).add 'another item'
        expect(amaze.equals amaze2).toBe false

      it 'returns false if mazes have different starts', -> 
        amaze2.set_start {x:0,y:1}
        expect(amaze.equals amaze2).toBe false

      it 'returns false if mazes have different goals', -> 
        amaze2.set_goal {x:0,y:1}
        expect(amaze.equals amaze2).toBe false

      it 'returns true if mazes have same goals', -> 
        amaze.set_goal {x:0,y:1}
        amaze2.set_goal {x:0,y:1}
        expect(amaze.equals amaze2).toBe true

      it 'returns true if mazes have same starts', -> 
        amaze.set_goal {x:0,y:1}
        amaze2.set_goal {x:0,y:1}
        expect(amaze.equals amaze2).toBe true


    describe '#set_room()', -> 
      all_doors = null
      openroom = null
      closedroom = null

      beforeEach -> 
        all_doors = [Directions.North, Directions.East, 
        Directions.South, Directions.West]
        openroom = new Room(all_doors)
        closedroom = new Room([])
        amaze = new Maze(5,5)

      it "seals room's northern/western doors if placed on boundary", -> 
        amaze.set_room({x:0,y:4}, openroom)
        expect(openroom.doors.length).toEqual 2
        expect(openroom.doors).toContain Directions.East
        expect(openroom.doors).toContain Directions.South

      it "seals room's southern/eastern doors if placed on boundary", -> 
        amaze.set_room({x:4,y:0}, openroom)
        expect(openroom.doors.length).toEqual 2
        expect(openroom.doors).toContain Directions.North
        expect(openroom.doors).toContain Directions.West

      it "does nothing if placed in middle", -> 
        amaze.set_room({x:3,y:3}, openroom)
        expect(openroom.doors.length).toEqual 4
        expect(openroom.doors).toContain Directions.North
        expect(openroom.doors).toContain Directions.West
        expect(openroom.doors).toContain Directions.East
        expect(openroom.doors).toContain Directions.South

      it "seals adjacent rooms' doors if wall placed adjacent", -> 
        center = new Position(2,2)
        amaze.set_room(center, closedroom)

        west = amaze.get_room center.after_move Directions.West
        expect(west.doors.length).toEqual 3
        expect(west.doors).not.toContain Directions.East

        east = amaze.get_room center.after_move Directions.East
        expect(east.doors.length).toEqual 3
        expect(east.doors).not.toContain Directions.West

        north = amaze.get_room center.after_move Directions.North
        expect(north.doors.length).toEqual 3
        expect(north.doors).not.toContain Directions.South

        south = amaze.get_room center.after_move Directions.South
        expect(south.doors.length).toEqual 3
        expect(south.doors).not.toContain Directions.North


      it "opens adjacent room's walls if door placed adjacent", -> 
        center = new Position(3,3)
        # seal all doors
        for x in [0..4]
          for y in [0..4]
            amaze.get_room({x:x,y:y}).doors = []

        # plop room with all doors in middle
        amaze.set_room(center, openroom)

        west = amaze.get_room center.after_move Directions.West
        expect(west.doors).toEqual [Directions.East]

        east = amaze.get_room center.after_move Directions.East
        expect(east.doors).toEqual [Directions.West]

        north = amaze.get_room center.after_move Directions.North
        expect(north.doors).toEqual [Directions.South]

        south = amaze.get_room center.after_move Directions.South
        expect(south.doors).toEqual [Directions.North]


    describe '#within_bounds()', -> 
      position = new Position(0,0)

      it "returns true when position in bounds", -> 
        position.x = 0; position.y = 0
        expect(amaze.within_bounds position).toBe true
        position.x = 0; position.y = 1
        expect(amaze.within_bounds position).toBe true
        position.x = 1; position.y = 0
        expect(amaze.within_bounds position).toBe true
        position.x = 1; position.y = 1
        expect(amaze.within_bounds position).toBe true

      it "returns false when past a wall", -> 
        position.x = -1; position.y = 0
        expect(amaze.within_bounds position).toBe false
        position.x = 2; position.y = 0
        expect(amaze.within_bounds position).toBe false
        position.x = 0; position.y = -1
        expect(amaze.within_bounds position).toBe false
        position.x = 0; position.y = 2
        expect(amaze.within_bounds position).toBe false

    describe '#at_bounds()', -> 
      position = new Position(0,0)

      it "returns bounds when position at bounds", -> 
        position.x = 0; position.y = 0
        bounds = amaze.at_bounds position
        expect(bounds.length).toBe 2
        expect(bounds).toContain Directions.South
        expect(bounds).toContain Directions.West

      it "returns bounds when position at north eastern bounds", -> 
        position.x = 1; position.y = 1
        bounds = amaze.at_bounds position
        expect(bounds.length).toBe 2
        expect(bounds).toContain Directions.North
        expect(bounds).toContain Directions.East

      it "returns empty when not at bounds", -> 
        amaze = new Maze(3,3)
        position.x = 1; position.y = 1
        bounds = amaze.at_bounds position
        expect(bounds).toEqual []

    describe '#to_string()', -> 

      it "returns correct string representation", -> 

        amaze.set_start {x:0, y:1}
        amaze.set_goal {x:0, y:0}

        expect(amaze.to_string()).toEqual """
        -----
        |s  |
        --  -
        |g  |
        -----
        """

      it "works when start and goal aren't set", -> 

        expect(amaze.to_string()).toEqual """
        -----
        |   |
        --  -
        |   |
        -----
        """

    describe '::from_string()', -> 

      it "correctly initializes maze", -> 

        amaze.set_start {x:0, y:1}
        amaze.set_goal {x:0, y:0}

        amaze.get_room(x:0, y:0).items = []
        amaze.get_room(x:0, y:1).items = []
        amaze.get_room(x:1, y:0).items = []
        amaze.get_room(x:1, y:1).items = []

        serialized = """
        -----
        |s  |
        --  -
        |g  |
        -----
        """

        deserialized = Maze.from_string serialized

        expect(deserialized.equals amaze).toBe true
