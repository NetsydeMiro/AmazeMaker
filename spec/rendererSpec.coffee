define ['Maze', 'jquery-ui', 'renderer'], (Maze) -> 

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

    xit 'accepts serialized maze', -> 
      target.renderer maze: serializedMaze
      expect(target.renderer 'maze').toEqual Maze.fromString(serializedMaze)

