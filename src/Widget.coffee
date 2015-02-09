define ['Direction', 'Position', 'Room', 'Maze', 'Serializer', 'Solver'], 
(Direction, Position, Room, Maze, Serializer, Solver) -> 

  $.widget 'netsyde.amazeMaker', 

    options: 
      width: 20
      height: 20
      serialized: null
      url: null

    _create: -> 
      @_renderRoomTypes()
      @_renderControls()

      if @options.serialized
        @_loadString @options.serialized
      else if @options.url
        @_loadFile @options.url
      else
        @maze = new Maze @options.width, @options.height
        @_buildMaze()
        @_renderMaze()

    _getDoors: ($draggableRoomElement) -> 
      klass = $draggableRoomElement.attr 'class'
      Direction.ALL.
        map((dir) -> dir.toLowerCase()).
        filter((dir) -> klass.indexOf(dir) isnt -1)

    _getPosition: ($droppableRoomElement) -> 
      klass = $droppableRoomElement.attr 'class'
      x = parseInt klass.match(/col(\d+)/)[1]
      y = parseInt klass.match(/row(\d+)/)[1]
      new Position x,y

    _getMarker: ($draggableRoomElement) -> 
      ['start','goal'].filter((klass) -> $draggableRoomElement.hasClass klass)[0]

    _getDropHandler: -> 
        amazeMaker = @
        (e,ui) -> 
          $draggedItem = ui.draggable
          $dropTarget = $ @

          position = amazeMaker._getPosition $dropTarget
          specialClass = amazeMaker._getMarker $draggedItem

          if specialClass is 'start'
            amazeMaker.maze.setStart position
          else if specialClass is 'goal'
            amazeMaker.maze.setGoal position
          else
            doors = amazeMaker._getDoors $draggedItem
            room = new Room doors
            amazeMaker.maze.setRoom position, room
          
          amazeMaker._renderMaze()

    _renderRoomTypes: -> 
      rooms = $('<div class="rooms"></div>')

      for perm in @_permute ['north','east','south','west']
        room = $('<div class="control room ' + perm.join(' ') + '"></div>')
        room.draggable revert: true
        rooms.append room

      $('<div class="control start" title="start"></div>').
        draggable(revert: true).appendTo rooms

      $('<div class="control goal" title="goal"></div>').
        draggable(revert: true).appendTo rooms

      rooms.append('<div class="clear"></div>')

      @element.append rooms

    _download: (filename, text) -> 
      pom = document.createElement 'a'
      pom.setAttribute 'href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text)
      pom.setAttribute 'download', filename
      pom.click()

    _loadString: (string) -> 
        @maze = Serializer.fromString string
        @_clearMaze()
        @_buildMaze()
        @_renderMaze()

    _loadUpload: (file) -> 
      reader = new FileReader
      reader.onload = (e) => 
        @_loadString reader.result
      reader.readAsText file

    _loadFile: (url) -> 
      request = new XMLHttpRequest
      request.onload = => 
        @_loadString request.responseText
      request.open 'get', url, true
      request.send()

    _renderControls: () -> 
      controls = $('<div class="controls"></div>')

      download = $('<button>Download</button>')
      download.click (e) => 
        @_download 'map.amaze', @maze.toString()
      controls.append download

      upload = $('<input type="file">')
      upload.change (e) => 
        @_loadUpload e.target.files[0]
      controls.append upload

      solver = $('<button>Solve</button>')
      solver.click (e) => 
        @_overlaySolution()
      controls.append solver

      controls.append '<div class="clear"></div>'
      @element.append controls

    _overlaySolution: () -> 
      @maze.clearItems()
      path = new Solver(@maze).solveBreadthFirst()
      currentPosition = @maze.start

      if path is null
        alert "No solution"
      else
        while path.length > 0
          currentCell = @element.find 'td.row' + currentPosition.y + 
          '.col' + currentPosition.x
          direction = path.shift()
          unless currentPosition.equals @maze.start
            currentCell.addClass 'move_' + direction
          currentPosition = currentPosition.afterMove direction

    _clearMaze: -> 
      @element.find('table').remove()

    _buildMaze: -> 
      table = $('<table class="maze"></table>')

      for ri in [@maze.height()-1..0]
        row = $('<tr></tr>').appendTo table
        for ci in [0..@maze.width()-1]
          $('<td></td>').
            addClass('row' + ri).
            addClass('col' + ci).
            droppable( 
              hoverClass: 'highlight'
              drop: @_getDropHandler(@)
            ).
            appendTo row

      @element.append table

    _renderMaze: -> 
      table = @element.find 'table'

      for ri in [0..@maze.height()-1]
        for ci in [0..@maze.width()-1]
          doors = @maze.getRoom(x:ci,y:ri).doors
          klass = 'row' + ri + ' col' + ci + ' ' + 
            doors.map((d) -> d.toLowerCase()).join(' ')
          cell = table.find('td.row' + ri + '.col' + ci)
          cell.attr 'class', klass

          if @maze.start and @maze.start.equals {x:ci,y:ri}
            cell.addClass 'start'
          else if @maze.goal and @maze.goal.equals {x:ci,y:ri}
            cell.addClass 'goal'

    _permute: (set) ->
      if set.length is 0
        []
      else if set.length is 1
        [[set[0]],[]]
      else
        head = set[set.length-1]
        tail = set.slice 0, set.length-1

        permutedTail = @_permute tail
        result = permutedTail.concat(permutedTail.map (perm) -> perm.concat(head))

        result.sort (perm1, perm2) -> perm1.length - perm2.length

