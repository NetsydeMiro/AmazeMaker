define ['Direction', 'Position', 'Room', 'Maze'], (Direction, Position, Room, Maze) -> 

  describe 'Maze', -> 
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

    describe "constructor", -> 

      it 'sets maze to correct height and width', -> 
        newMaze = new Maze(3,4)
        expect(newMaze.width()).toEqual 3
        expect(newMaze.height()).toEqual 4

      it 'initializes maze to empty unwalled rooms within walled labyrinth', -> 
        newMaze = new Maze(3,3)

        for x in [0..2]
          for y in [0..2]
            expect(newMaze.rooms[x][y].isEmpty()).toBe true

            expect(newMaze.rooms[x][y].doors).toContain(Direction.NORTH) unless y is 2
            expect(newMaze.rooms[x][y].doors).not.toContain(Direction.NORTH) if y is 2
            expect(newMaze.rooms[x][y].doors).toContain(Direction.EAST) unless x is 2
            expect(newMaze.rooms[x][y].doors).not.toContain(Direction.EAST) if x is 2
            expect(newMaze.rooms[x][y].doors).toContain(Direction.SOUTH) unless y is 0
            expect(newMaze.rooms[x][y].doors).not.toContain(Direction.SOUTH) if y is 0
            expect(newMaze.rooms[x][y].doors).toContain(Direction.WEST) unless x is 0
            expect(newMaze.rooms[x][y].doors).not.toContain(Direction.WEST) if x is 0

    describe '#equals()', -> 
      amaze2 = null
      
      beforeEach -> 
        amaze2 = new Maze(2,2)

        room = new Room(Direction.EAST)
        room.add('NW')
        amaze2.setRoom(new Position(0,1), room)

        room = new Room([Direction.WEST, Direction.SOUTH])
        room.add('NE')
        amaze2.setRoom(new Position(1,1), room)

        room = new Room([Direction.NORTH, Direction.WEST])
        room.add('SW')
        amaze2.setRoom(new Position(1,0), room)

        room = new Room(Direction.EAST)
        room.add('SE')
        amaze2.setRoom(new Position(0,0), room)

      it 'returns true if mazes have equal rooms, starts, and targets', -> 
        expect(amaze.equals amaze2).toBe true

      it 'returns false if mazes have different rooms', -> 
        amaze2.getRoom({x:0,y:0}).add 'another item'
        expect(amaze.equals amaze2).toBe false

      it 'returns false if mazes have different starts', -> 
        amaze2.setStart {x:0,y:1}
        expect(amaze.equals amaze2).toBe false

      it 'returns false if mazes have different goals', -> 
        amaze2.setGoal {x:0,y:1}
        expect(amaze.equals amaze2).toBe false

      it 'returns true if mazes have same goals', -> 
        amaze.setGoal {x:0,y:1}
        amaze2.setGoal {x:0,y:1}
        expect(amaze.equals amaze2).toBe true

      it 'returns true if mazes have same starts', -> 
        amaze.setGoal {x:0,y:1}
        amaze2.setGoal {x:0,y:1}
        expect(amaze.equals amaze2).toBe true


    describe '#setRoom()', -> 
      openroom = null
      closedroom = null

      beforeEach -> 
        openroom = new Room(Direction.ALL)
        closedroom = new Room([])
        amaze = new Maze(5,5)

      it "seals room's northern/western doors if placed on boundary", -> 
        amaze.setRoom {x:0,y:4}, openroom
        expect(openroom.doors.length).toEqual 2
        expect(openroom.doors).toContain Direction.EAST
        expect(openroom.doors).toContain Direction.SOUTH

      it "seals room's southern/eastern doors if placed on boundary", -> 
        amaze.setRoom {x:4,y:0}, openroom
        expect(openroom.doors.length).toEqual 2
        expect(openroom.doors).toContain Direction.NORTH
        expect(openroom.doors).toContain Direction.WEST

      it "does nothing if placed in middle", -> 
        amaze.setRoom {x:3,y:3}, openroom
        expect(openroom.doors.length).toEqual 4
        expect(openroom.doors).toContain Direction.NORTH
        expect(openroom.doors).toContain Direction.WEST
        expect(openroom.doors).toContain Direction.EAST
        expect(openroom.doors).toContain Direction.SOUTH

      it "seals adjacent rooms' doors if wall placed adjacent", -> 
        center = new Position(2,2)
        amaze.setRoom(center, closedroom)

        west = amaze.getRoom center.afterMove Direction.WEST
        expect(west.doors.length).toEqual 3
        expect(west.doors).not.toContain Direction.EAST

        east = amaze.getRoom center.afterMove Direction.EAST
        expect(east.doors.length).toEqual 3
        expect(east.doors).not.toContain Direction.WEST

        north = amaze.getRoom center.afterMove Direction.NORTH
        expect(north.doors.length).toEqual 3
        expect(north.doors).not.toContain Direction.SOUTH

        south = amaze.getRoom center.afterMove Direction.SOUTH
        expect(south.doors.length).toEqual 3
        expect(south.doors).not.toContain Direction.NORTH


      it "opens adjacent room's walls if door placed adjacent", -> 
        center = new Position(3,3)
        # seal all doors
        for x in [0..4]
          for y in [0..4]
            amaze.getRoom({x:x,y:y}).doors = []

        # plop room with all doors in middle
        amaze.setRoom(center, openroom)

        west = amaze.getRoom center.afterMove Direction.WEST
        expect(west.doors).toEqual [Direction.EAST]

        east = amaze.getRoom center.afterMove Direction.EAST
        expect(east.doors).toEqual [Direction.WEST]

        north = amaze.getRoom center.afterMove Direction.NORTH
        expect(north.doors).toEqual [Direction.SOUTH]

        south = amaze.getRoom center.afterMove Direction.SOUTH
        expect(south.doors).toEqual [Direction.NORTH]


    describe '#withinBounds()', -> 
      position = new Position(0,0)

      it "returns true when position in bounds", -> 
        position.x = 0; position.y = 0
        expect(amaze.withinBounds position).toBe true
        position.x = 0; position.y = 1
        expect(amaze.withinBounds position).toBe true
        position.x = 1; position.y = 0
        expect(amaze.withinBounds position).toBe true
        position.x = 1; position.y = 1
        expect(amaze.withinBounds position).toBe true

      it "returns false when past a wall", -> 
        position.x = -1; position.y = 0
        expect(amaze.withinBounds position).toBe false
        position.x = 2; position.y = 0
        expect(amaze.withinBounds position).toBe false
        position.x = 0; position.y = -1
        expect(amaze.withinBounds position).toBe false
        position.x = 0; position.y = 2
        expect(amaze.withinBounds position).toBe false

    describe '#atBounds()', -> 
      position = new Position(0,0)

      it "returns bounds when position at bounds", -> 
        position.x = 0; position.y = 0
        bounds = amaze.atBounds position
        expect(bounds.length).toBe 2
        expect(bounds).toContain Direction.SOUTH
        expect(bounds).toContain Direction.WEST

      it "returns bounds when position at north eastern bounds", -> 
        position.x = 1; position.y = 1
        bounds = amaze.atBounds position
        expect(bounds.length).toBe 2
        expect(bounds).toContain Direction.NORTH
        expect(bounds).toContain Direction.EAST

      it "returns empty when not at bounds", -> 
        amaze = new Maze(3,3)
        position.x = 1; position.y = 1
        bounds = amaze.atBounds position
        expect(bounds).toEqual []

    describe '#clearItems()', -> 

      it 'clears maze of items', -> 

        amaze.clearItems()

        for x in [0..1]
          for y in [0..1]
            expect(amaze.getRoom({x:x,y:y}).isEmpty()).toBe true
