(function() {
  define(function() {
    var Directions;
    return Directions = (function() {
      function Directions() {}

      Directions.North = 'north';

      Directions.East = 'east';

      Directions.South = 'south';

      Directions.West = 'west';

      Directions.All = [Directions.North, Directions.East, Directions.South, Directions.West];

      Directions.Opposite = {};

      Directions.Opposite[Directions.North] = Directions.South;

      Directions.Opposite[Directions.East] = Directions.West;

      Directions.Opposite[Directions.South] = Directions.North;

      Directions.Opposite[Directions.West] = Directions.East;

      return Directions;

    })();
  });

}).call(this);

//# sourceMappingURL=Directions.js.map
