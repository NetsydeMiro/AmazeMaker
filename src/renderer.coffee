define ['Maze', 'jquery-ui'], (Maze) -> 

  $.widget 'AmazeMaker.renderer', 

    options: 
      maze: null # must be supplied

    _create: -> 
      @maze = if (typeof @options.maze) is 'string'
        Maze.fromString @options.maze
      else
        @options.maze

      table = $('<table></table>').appendTo @element
      for y in [0...@maze.height()]
        row = $('<tr></tr>').appendTo table
        for x in [0...@maze.width()]
          cell = $('<td></td>').appendTo row

    maze: (maze) -> 
      @maze
