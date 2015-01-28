define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Solver', -> 

    describe '#solve_depth_first()', -> 

      it 'finds path from single path walled maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start new AmazeMaker.Position(0,1)
        amaze.set_goal new AmazeMaker.Position(0,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:1}, room)

        room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South])
        amaze.set_room({x:1,y:1}, room)

        room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West])
        amaze.set_room({x:1,y:0}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:0}, room)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve_depth_first()

        expect(paths).toEqual [AmazeMaker.Directions.East, 
        AmazeMaker.Directions.South, 
        AmazeMaker.Directions.West]

      it 'gets no paths from impossible maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start new AmazeMaker.Position(0,1)
        amaze.set_goal new AmazeMaker.Position(0,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:1}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room({x:1,y:1}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room({x:0,y:0}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:0}, room)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve_depth_first()

        expect(paths).toEqual null

    describe '#solve_breadth_first()', -> 

      it 'finds path from single path walled maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start new AmazeMaker.Position(0,1)
        amaze.set_goal new AmazeMaker.Position(0,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:1}, room)

        room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South])
        amaze.set_room({x:1,y:1}, room)

        room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West])
        amaze.set_room({x:1,y:0}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:0}, room)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve_breadth_first()

        expect(paths).toEqual [AmazeMaker.Directions.East, 
        AmazeMaker.Directions.South, 
        AmazeMaker.Directions.West]

      it 'gets no paths from impossible maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start new AmazeMaker.Position(0,1)
        amaze.set_goal new AmazeMaker.Position(0,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:1}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room({x:1,y:1}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room({x:0,y:0}, room)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room({x:0,y:0}, room)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve_breadth_first()

        expect(paths).toEqual null

