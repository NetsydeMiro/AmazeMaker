require ['Widget'], (Widget) -> 
  $('#amaze-maker').amazeMaker()

  serialized = """
  -----
  |s  |
  --  -
  |g  |
  -----
  """

  $('#amaze-maker-test').amazeMaker width:2, height:2
  $('#amaze-maker-test').amazeMaker 'load', serialized
