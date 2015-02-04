define ['Maze', 'jquery-ui'], (Maze) -> 

  $.widget 'AmazeMaker.renderer', 

    options: 
      maze: null # must be supplied

    _create: -> 
      @_maze = if (typeof @options.maze) is 'string'
        try
          Maze.fromString @options.maze
        catch ex
          if ex.indexOf('Invalid Maze String: ') is 0
            Maze.fromString @_readUrl(@options.maze)
          else
            throw ex
      else
        @options.maze

      @_buildMaze()
      @renderMaze()

    maze: (maze) -> 
      if maze
        @_maze = maze
        @_buildMaze()
        @renderMaze()
      @_maze

    renderMaze: -> 
      table = @element.find 'table.maze'
      # mazes origin is bottom left (south west)
      # so we have to reverse our y iteration
      for y in [@_maze.height()-1..0]
        for x in [0...@_maze.width()]
          # build door classes
          doorClasses = @_maze.getRoom(x:x,y:y).doors.join(' ')
          cell = table.find @_tableCellSelector x:x, y:y
          cell.attr 'class',  doorClasses

          # set start and goal if necessary
          if @_maze.start and @_maze.start.equals {x:x,y:y}
            cell.addClass 'start'
          if @_maze.goal and @_maze.goal.equals {x:x,y:y}
            cell.addClass 'goal'

    _buildMaze: -> 
      @element.find('table.maze').remove()
      table = $('<table class="maze"></table>').appendTo @element

      # mazes origin is bottom left (south west)
      # so we have to reverse our y iteration
      for y in [@_maze.height()-1..0]
        row = $('<tr></tr>').appendTo table
        for x in [0...@_maze.width()]
          cell = $("<td></td>").appendTo row

    _tableCellSelector: (position) -> 
      "tr:nth-child(#{@_maze.height()-position.y}) td:nth-child(#{position.x+1})"

    _readUrl: (url) -> 
      request = new XMLHttpRequest
      request.open 'get', url
      request.send()
      request.responseText

