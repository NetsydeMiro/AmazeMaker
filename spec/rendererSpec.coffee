define ['Maze', 'Serializer', 'jquery-ui', 'renderer', 'mock-ajax'], (Maze, Serializer) -> 

  target = null
  serializedMaze = null
  maze = null

  beforeEach -> 
    target = $('<div id="renderer"></div>').appendTo $('body')
    serializedMaze = """
    -----
    |s  |
    --- -
    |g  |
    -----
    """
    maze = Serializer.fromString serializedMaze

  afterEach -> 
    target.remove()

  describe 'Renderer', -> 

    describe 'option.maze', -> 

      it 'accepts maze', -> 
        target.renderer maze: maze
        expect(target.renderer 'maze').toEqual maze

      it 'accepts serialized maze', -> 
        target.renderer maze: serializedMaze
        expect(target.renderer 'maze').toEqual maze

      describe 'ajaxy behaviour', -> 
        beforeEach -> 
          jasmine.Ajax.install()

        afterEach -> 
          jasmine.Ajax.uninstall()

        describe '#_readUrl()', -> 

          it 'reads url correctly', -> 
            url = 'phony/url'
            contents = 'Some Content Here!'

            jasmine.Ajax.stubRequest(url).andReturn responseText: contents
            expect($.AmazeMaker.renderer::_readUrl url).toEqual contents

        it 'accepts url to serialized maze', -> 
          url = 'phony/url'

          jasmine.Ajax.stubRequest(url).andReturn responseText: serializedMaze
          target.renderer maze: url
          expect(target.renderer 'maze').toEqual maze

    describe 'table rendering', -> 
      
      it 'renders single table', -> 
        maze = new Maze(2,2)
        target.renderer maze: maze
        expect(target.children('table').length).toBe 1

      it 'renders correct number of rows', -> 
        [width, height] = [3,7]
        maze = new Maze(width, height)
        target.renderer maze: maze
        rows = target.find 'table tr'
        expect(rows.length).toBe height

      it 'renders correct number of columns', -> 
        [width, height] = [5, 3]
        maze = new Maze(width, height)
        target.renderer maze: maze
        rows = target.find 'table tr'

        for rowI in [0...height]
          expect(rows.eq(rowI).find('td').length).toBe width

      tableCellSelector = (maze, pos) ->
        "tr:nth-child(#{maze.height()-pos.y}) td:nth-child(#{pos.x+1})"

      it 'renders correct doors and walls', -> 
        target.renderer maze: maze

        for y in [0...maze.height()]
          for x in [0...maze.width()]
            cell = target.find(tableCellSelector maze, {x:x, y:y})
            room = maze.getRoom {x:x,y:y}

            for door in room.doors
              expect(cell.hasClass door).toBe true

            for wall in room.walls()
              expect(cell.hasClass wall).toBe false

      it 'renders correct start', -> 
        target.renderer maze: maze
        expect(target.find(tableCellSelector maze, maze.start).hasClass 'start').toBe true
        for y in [0...maze.height()]
          for x in [0...maze.width()]
            pos = {x:x, y:y}
            unless maze.start.equals pos
              expect(target.find(tableCellSelector maze, pos).hasClass 'start').toBe false

      it 'renders correct goal', -> 
        target.renderer maze: maze
        expect(target.find(tableCellSelector maze, maze.goal).hasClass 'goal').toBe true

        for y in [0...maze.height()]
          for x in [0...maze.width()]
            pos = {x:x, y:y}
            unless maze.goal.equals pos
              expect(target.find(tableCellSelector maze, pos).hasClass 'goal').toBe false

    describe '#maze()', -> 
      maze2 = null

      beforeEach -> 
        maze2 = Serializer.fromString """
        ---
        | |
        ---
        """

      it 'gets maze', -> 
        target.renderer maze: maze
        expect(target.renderer 'maze').toBe maze

      it 'sets maze', -> 
        target.renderer maze: maze

        target.renderer 'maze', maze2
        expect(target.renderer 'maze').toBe maze2

      it 're-renders maze', -> 
        target.renderer maze: maze
        expect(target.find('td').length).toBe 4

        target.renderer 'maze', maze2
        expect(target.find('td').length).toBe 1

