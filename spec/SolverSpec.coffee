define ['AmazeMaker'], (AmazeMaker) -> 

  Position = AmazeMaker.Position
  Direction = AmazeMaker.Direction
  Room = AmazeMaker.Room
  Maze = AmazeMaker.Maze
  Solver = AmazeMaker.Solver

  xdescribe 'Solver', -> 

    describe '#solveDepthFirst()', -> 

      it 'finds path from single path walled maze', -> 
        amaze = new Maze(2,2)
        amaze.setStart new Position(0,1)
        amaze.setGoal new Position(0,0)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:1}, room)

        room = new Room([Direction.WEST, Direction.SOUTH])
        amaze.setRoom({x:1,y:1}, room)

        room = new Room([Direction.North, Direction.WEST])
        amaze.setRoom({x:1,y:0}, room)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:0}, room)

        solver = new Solver(amaze)
        paths = solver.solveDepthFirst()

        expect(paths).toEqual [Direction.EAST, 
        Direction.SOUTH, 
        Direction.WEST]

      it 'gets no paths from impossible maze', -> 
        amaze = new Maze(2,2)
        amaze.setStart new Position(0,1)
        amaze.setGoal new Position(0,0)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:1}, room)

        room = new Room(Direction.WEST)
        amaze.setRoom({x:1,y:1}, room)

        room = new Room(Direction.WEST)
        amaze.setRoom({x:0,y:0}, room)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:0}, room)

        solver = new Solver(amaze)
        paths = solver.solveDepthFirst()

        expect(paths).toEqual null

    describe '#solveBreadthFirst()', -> 

      it 'finds path from single path walled maze', -> 
        amaze = new Maze(2,2)
        amaze.setStart new Position(0,1)
        amaze.setGoal new Position(0,0)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:1}, room)

        room = new Room([Direction.WEST, Direction.SOUTH])
        amaze.setRoom({x:1,y:1}, room)

        room = new Room([Direction.North, Direction.WEST])
        amaze.setRoom({x:1,y:0}, room)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:0}, room)

        solver = new Solver(amaze)
        paths = solver.solveBreadthFirst()

        expect(paths).toEqual [Direction.EAST, 
        Direction.SOUTH, 
        Direction.WEST]

      it 'gets no paths from impossible maze', -> 
        amaze = new Maze(2,2)
        amaze.setStart new Position(0,1)
        amaze.setGoal new Position(0,0)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:1}, room)

        room = new Room(Direction.WEST)
        amaze.setRoom({x:1,y:1}, room)

        room = new Room(Direction.WEST)
        amaze.setRoom({x:0,y:0}, room)

        room = new Room(Direction.EAST)
        amaze.setRoom({x:0,y:0}, room)

        solver = new Solver(amaze)
        paths = solver.solveBreadthFirst()

        expect(paths).toEqual null

