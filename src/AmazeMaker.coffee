requirejs.config
  baseUrl: 'src/'

define ['Directions', 'Room', 'Maze', 'Solver'], (Directions, Room, Maze, Solver) -> 

  class AmazeMaker
    @Directions: Directions
    @Room: Room
    @Maze: Maze
    @Solver: Solver
