define ['jquery-ui'], -> 

  $.widget 'AmazeMaker.renderer', 

    options: 
      width: 10
      height: 10

    _create: -> 
      table = $('<table></table>').appendTo @element
      for y in [0...@options.height]
        row = $('<tr></tr>').appendTo table
        for x in [0...@options.width]
          cell = $('<td></td>').appendTo row

