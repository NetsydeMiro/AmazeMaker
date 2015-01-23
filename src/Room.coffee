define -> 

  class Room 
    constructor: (doors=[]) -> 
      if doors.constructor == Array
        @doors = doors.slice()
      else
        @doors = [doors]

      @items = []

    is_empty: () -> 
      @items.length is 0

    add: (item) ->
      @items.push item

    contains: (item) -> 
      @items.indexOf(item) isnt -1

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

    equals: (room) -> 

      if @items.length isnt room.items.length or
      @doors.length isnt room.doors.length

        return false

      else
        this_doors = @doors.slice().sort()
        room_doors = room.doors.slice().sort()

        for x in [0..@doors.length-1]
          return false if this_doors[x] isnt room_doors[x]

        this_items = @items.slice().sort()
        room_items = room.items.slice().sort()

        for x in [0..@items.length-1]
          return false if this_items[x] isnt room_items[x]

        return true


