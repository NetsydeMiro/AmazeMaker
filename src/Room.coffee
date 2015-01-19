define -> 

  class Room 
    constructor: (@doors=[]) -> 
      @items = []

    is_empty: () -> 
      @items.length == 0

    add: (item) ->
      @items.push item

    contains: (item) -> 
      @items.indexOf(item) >= 0
