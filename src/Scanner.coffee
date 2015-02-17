define ['jquery'], -> 

  class Scanner

    constructor: (inp, imageLoadedCallback) -> 
      image = new Image
      image.onload = => 
        imageData = @_getImageData image
        @wallMatrix = @_getWallMatrix imageData
        histograms = [@wallHistogramY, @wallHistogramX] = @_getWallHistograms @wallMatrix
        [@wallCoordsY, @wallCoordsX] = histograms.map (hist) => @_getWallCoords(hist)
        imageLoadedCallback() if imageLoadedCallback
      image.src = inp

    _getImageData: (image) -> 
      canvas = document.createElement 'canvas'
      [canvas.width, canvas.height] = [image.width, image.height]
      context = canvas.getContext '2d'
      context.drawImage image, 0, 0
      context.getImageData 0, 0, image.width, image.height

    _getWallMatrix: (imageData) -> 
      thresholdValue = 255 / 2.0
      wallMatrix = [0...imageData.height].map (colIndex) -> new Array(imageData.width)

      for y in [0...imageData.height]
        for x in [0...imageData.width]
          pixelIndex = (y*imageData.width+x)*4
          pixelSum = 0
          for colorOffset in [0...3]
            pixelSum += imageData.data[pixelIndex + colorOffset]
          rgbMean = pixelSum / 3.0
          wallMatrix[y][x] = rgbMean < thresholdValue

      wallMatrix

    #TODO: find a more robust method that doesn't rely on magic numbers; 
    # something more statistical
    _getWallCoords: (histogram) -> 
      minWall = Number.MAX_VALUE
      for i in [0...histogram.length]
        minWall = histogram[i] if 0 < histogram[i] < minWall 

      wallCoords = []

      prevWall = 0
      for i in [0...histogram.length]
        if histogram[i] > minWall and histogram[i] > prevWall and Math.abs(histogram[i] - prevWall) > 7 
          wallCoords.push i
        prevWall = histogram[i]

      wallCoords

    _getWallHistograms: (wallMatrix) -> 
      [histogramY, histogramX] = [[],[]]
      for y in [0...wallMatrix.length]
        histogramY[y] = 0
        for x in [0...wallMatrix[0].length]
          histogramX[x] ||= 0
          histogramY[y] += 1 if wallMatrix[y][x]
          histogramX[x] += 1 if wallMatrix[y][x]

      [histogramY, histogramX]
