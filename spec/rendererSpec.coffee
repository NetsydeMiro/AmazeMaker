define ['Maze', 'jquery-ui', 'renderer', 'mock-ajax'], (Maze) -> 

  target = null
  serializedMaze = null

  beforeEach -> 
    target = $('<div id="renderer"></div>').appendTo $('body')
    serializedMaze = """
    -----
    |s  |
    --- -
    |g  |
    -----
    """

  afterEach -> 
    target.remove()

  describe 'Renderer', -> 

    describe 'constructor', -> 
        
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

      it 'accepts serialized maze', -> 
        target.renderer maze: serializedMaze
        expect(target.renderer 'maze').toEqual Maze.fromString(serializedMaze)

      describe 'Ajaxy behaviour', -> 
        beforeEach -> 
          jasmine.Ajax.install()

        afterEach -> 
          jasmine.Ajax.uninstall()


        it 'accepts url to serialized maze', -> 
          url = 'phony/url'

          jasmine.Ajax.stubRequest(url).andReturn responseText: serializedMaze
          target.renderer maze: url
          expect(target.renderer 'maze').toEqual Maze.fromString(serializedMaze)

    describe '#_readUrl()', -> 

      beforeEach -> 
        jasmine.Ajax.install()

      afterEach -> 
        jasmine.Ajax.uninstall()

      it 'reads url correctly', -> 
        url = 'phony/url'
        contents = 'Some Content Here!'

        jasmine.Ajax.stubRequest(url).andReturn responseText: contents
        expect($.AmazeMaker.renderer::_readUrl url).toEqual contents

