define ['Directions', 'Position', 'Room', 'Maze', 'Solver'], 
(Directions, Position, Room, Maze, Solver) -> 

  jQuery.widget 'netsyde.amazeMaker', 

    options: 
      width: 20
      height: 20

    _create: () -> 
      @maze = new Maze(@options.width, @options.height)

      @_render_room_types()
      @_build_maze()
      @_render_maze()

    _get_doors: ($draggable_room_element) -> 
      classes_string = $draggable_room_element.attr('class')
      Directions.All.
        map((dir) -> dir.toLowerCase()).
        filter((dir) -> classes_string.indexOf(dir) isnt -1)

    _get_position: ($droppable_room_element) -> 
      classes_string = $droppable_room_element.attr('class')
      x = parseInt classes_string.match(/col(\d+)/)[1]
      y = parseInt classes_string.match(/row(\d+)/)[1]
      new Position(x,y)

    _get_special: ($draggable_room_element) -> 
      ['start','goal'].filter((klass) -> $draggable_room_element.hasClass klass)[0]

    _get_drop_handler: () -> 
        maze_maker = @
        (e,ui) -> 
          $dragged_item = ui.draggable
          $drop_target = $ @

          position = maze_maker._get_position $drop_target
          special_class = maze_maker._get_special $dragged_item

          if special_class is 'start'
            maze_maker.maze.set_start position
          else if special_class is 'goal'
            maze_maker.maze.set_goal position
          else
            doors = maze_maker._get_doors $dragged_item
            room = new Room(doors)
            maze_maker.maze.set_room position, room
          
          maze_maker._render_maze()

    _render_room_types: () -> 
      rooms = $('<div class="rooms"></div>')
      #wrapper = $('<div class="room_wrapper"></div>').appendTo rooms

      for perm in @_permute ['north','east','south','west']
        room = $('<div class="room ' + perm.join(' ') + '"></div>')
        room.draggable(
          revert: true
        )
        rooms.append(room)

      $('<div class="room start"></div>').
        draggable(revert: true).appendTo(rooms)

      $('<div class="room goal"></div>').
        draggable(revert: true).appendTo(rooms)

      rooms.append('<div class="clear"></div>')

      @element.append rooms

    _build_maze: () -> 
      table = $('<table class="maze"></table>')

      for ri in [@maze.height()-1..0]
        row = $('<tr></tr>').appendTo table
        for ci in [0..@maze.width()-1]
          $('<td></td>').
            addClass('row' + ri).
            addClass('col' + ci).
            droppable( 
              hoverClass: 'highlight'
              drop: @_get_drop_handler(@)
            ).
            appendTo row

      @element.append table

    _render_maze: () -> 
      table = @element.find('table')

      for ri in [0..@maze.height()-1]
        for ci in [0..@maze.width()-1]
          doors = @maze.get_room(x:ci,y:ri).doors
          class_string = 'row' + ri + ' col' + ci + ' ' + 
            doors.map((d) -> d.toLowerCase()).join(' ')
          cell = table.find('td.row' + ri + '.col' + ci)
          cell.attr 'class', class_string

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

        permuted_tail = @_permute(tail)
        result = permuted_tail.concat(permuted_tail.map (perm) -> perm.concat(head))

        result.sort (perm1, perm2) -> perm1.length - perm2.length

