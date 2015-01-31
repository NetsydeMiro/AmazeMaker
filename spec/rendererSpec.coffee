define ['jquery-ui', 'renderer'], -> 

  target = null

  beforeEach -> 
    target = $('<div id="renderer"></div>').appendTo $('body')

  afterEach -> 
    target.remove()

  describe 'Renderer', -> 

    it 'renders single table', -> 
      target.renderer()
      expect(target.children('table').length).toBe 1

    it 'renders correct number of rows', -> 
      target.renderer height: 7
      rows = target.find 'table tr'
      expect(rows.length).toBe 7

    it 'renders correct number of default rows', -> 
      target.renderer()
      rows = target.find 'table tr'

      expect(rows.length).toBe 10

    it 'renders correct number of columns', -> 
      height = 3; width= 5
      target.renderer height: height, width: width
      rows = target.find 'table tr'

      for rowI in [0...height]
        expect(rows.eq(rowI).find('td').length).toBe width

    it 'renders correct number of default columns', -> 
      height = 10; width = 10

      target.renderer()
      rows = target.find 'table tr'

      for rowI in [0...height]
        expect(rows.eq(rowI).find('td').length).toBe width

