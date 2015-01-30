define -> 

  class Room 
    constructor: (doors=[]) -> 
      if doors.constructor is Array
        # copy the array to avoid any unfortunate external side effects
        @doors = doors.slice()
      else
        @doors = [doors]

      @items = []

    isEmpty: -> 
      @items.length is 0

    add: (item) ->
      @items.push item

    clearItems: -> 
      @items = []

    contains: (item) -> 
      @items.indexOf(item) isnt -1

    sealDoor: (direction) -> 
      unless (index = @doors.indexOf direction) is -1
        @doors.splice index, 1
      return this

    openWall: (direction) -> 
      if @doors.indexOf(direction) is -1
        @doors.push direction
      return this

    hasDoor: (direction) -> 
      @doors.indexOf(direction) isnt -1

    hasWall: (direction) -> 
      not @hasDoor direction

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

