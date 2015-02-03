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

      table = $('<table></table>').appendTo @element
      for y in [0...@_maze.height()]
        row = $('<tr></tr>').appendTo table
        for x in [0...@_maze.width()]
          cell = $('<td></td>').appendTo row

    _readUrl: (url) -> 
      request = new XMLHttpRequest
      request.open 'get', url
      request.send()
      request.responseText

    maze: (maze) -> 
      @_maze

