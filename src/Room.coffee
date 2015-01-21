define -> 

  class Room 
    constructor: (doors=[]) -> 
      if doors.constructor == Array
        @doors = doors.slice()
      else
        @doors = [doors]

      @items = []

    is_empty: () -> 
      @items.length == 0

    add: (item) ->
      @items.push item

    contains: (item) -> 
      @items.indexOf(item) >= 0

    seal_door: (direction) -> 
      unless (index = @doors.indexOf direction) is -1
        @doors.splice index, 1
      return @

    open_wall: (direction) -> 
      if (index = @doors.indexOf direction) is -1
        @doors.push direction
      return @

    has_door: (direction) -> 
      @doors.indexOf(direction) isnt -1

    has_wall: (direction) -> 
      not @has_door direction

