define ['Scanner'], (Scanner) -> 

  xdescribe 'Scanner', -> 
    describe 'constructor', -> 

      it 'accepts a url', -> 
        scanner = new Scanner '/mazes/medium.gif'

    describe 'width()', -> 

      it 'returns correct image width', -> 
        scanner = new Scanner '/mazes/thickwalls.png'
        expect(scanner.width()).toBe 601

    describe 'height()', -> 

      it 'returns correct image width', -> 
        scanner = new Scanner '/mazes/thickwalls.png'
        expect(scanner.width()).toBe 366

