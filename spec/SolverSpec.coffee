define ['AmazeMaker'], (AmazeMaker) -> 

  describe 'Solver', -> 

    describe '#solve()', -> 

      it 'gets all paths from empty maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start(0,0)
        amaze.set_goal(1,1)
        amaze.set_position(amaze.start.x, amaze.start.y)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve()

        expect(paths).toEqual [[AmazeMaker.Directions.North, AmazeMaker.Directions.East], 
          [AmazeMaker.Directions.East, AmazeMaker.Directions.North]]


      it 'gets only path from single path walled maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start(0,1)
        amaze.set_goal(0,0)
        amaze.set_position(amaze.start.x, amaze.start.y)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room(room,0,1)

        room = new AmazeMaker.Room([AmazeMaker.Directions.West, AmazeMaker.Directions.South])
        amaze.set_room(room,1,1)

        room = new AmazeMaker.Room([AmazeMaker.Directions.North, AmazeMaker.Directions.West])
        amaze.set_room(room,1,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room(room,0,0)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve()

        expect(paths).toEqual [[AmazeMaker.Directions.East, 
        AmazeMaker.Directions.South, 
        AmazeMaker.Directions.West]]

      it 'gets no paths from impossible maze', -> 
        amaze = new AmazeMaker.Maze(2,2)
        amaze.set_start(0,1)
        amaze.set_goal(0,0)
        amaze.set_position(amaze.start.x, amaze.start.y)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room(room,0,1)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room(room,1,1)

        room = new AmazeMaker.Room(AmazeMaker.Directions.West)
        amaze.set_room(room,1,0)

        room = new AmazeMaker.Room(AmazeMaker.Directions.East)
        amaze.set_room(room,0,0)

        solver = new AmazeMaker.Solver(amaze)
        paths = solver.solve()

        expect(paths).toEqual []
