requirejs.config
  baseUrl: 'src/'

define ['Directions', 'Room', 'Maze'], (Directions, Room, Maze) -> 

  class AmazeMaker

    @Directions: Directions

    @Room: Room

    @Maze: Maze

