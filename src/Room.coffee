define -> 

  class Room 
    constructor: (@doors=[]) -> 
      unless @doors.constructor == Array
        @doors = [@doors]
      @items = []

    is_empty: () -> 
      @items.length == 0

    add: (item) ->
      @items.push item

    contains: (item) -> 
      @items.indexOf(item) >= 0
