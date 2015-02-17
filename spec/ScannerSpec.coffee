define ['Scanner'], (Scanner) -> 

  # simple image corresponds to binary png of dimensions 5x4: 
  # *****
  # **
  # * *
  # *  *
  simpleImage = """
  data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAECAIAAADJUWIXAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAXSURBVBhXY8AO/sMAlAMXQkiCGP//AwBQDBrmshXc1AAAAABJRU5ErkJggg==
  """

  simpleMaze = """
  data:image/gif;base64,R0lGODlhoQChAFAAACH5BAAAAAAALAAAAAChAKEAhwAAAAAAMwAAZgAAmQAAzAAA/wArAAArMwArZgArmQArzAAr/wBVAABVMwBVZgBVmQBVzABV/wCAAACAMwCAZgCAmQCAzACA/wCqAACqMwCqZgCqmQCqzACq/wDVAADVMwDVZgDVmQDVzADV/wD/AAD/MwD/ZgD/mQD/zAD//zMAADMAMzMAZjMAmTMAzDMA/zMrADMrMzMrZjMrmTMrzDMr/zNVADNVMzNVZjNVmTNVzDNV/zOAADOAMzOAZjOAmTOAzDOA/zOqADOqMzOqZjOqmTOqzDOq/zPVADPVMzPVZjPVmTPVzDPV/zP/ADP/MzP/ZjP/mTP/zDP//2YAAGYAM2YAZmYAmWYAzGYA/2YrAGYrM2YrZmYrmWYrzGYr/2ZVAGZVM2ZVZmZVmWZVzGZV/2aAAGaAM2aAZmaAmWaAzGaA/2aqAGaqM2aqZmaqmWaqzGaq/2bVAGbVM2bVZmbVmWbVzGbV/2b/AGb/M2b/Zmb/mWb/zGb//5kAAJkAM5kAZpkAmZkAzJkA/5krAJkrM5krZpkrmZkrzJkr/5lVAJlVM5lVZplVmZlVzJlV/5mAAJmAM5mAZpmAmZmAzJmA/5mqAJmqM5mqZpmqmZmqzJmq/5nVAJnVM5nVZpnVmZnVzJnV/5n/AJn/M5n/Zpn/mZn/zJn//8wAAMwAM8wAZswAmcwAzMwA/8wrAMwrM8wrZswrmcwrzMwr/8xVAMxVM8xVZsxVmcxVzMxV/8yAAMyAM8yAZsyAmcyAzMyA/8yqAMyqM8yqZsyqmcyqzMyq/8zVAMzVM8zVZszVmczVzMzV/8z/AMz/M8z/Zsz/mcz/zMz///8AAP8AM/8AZv8Amf8AzP8A//8rAP8rM/8rZv8rmf8rzP8r//9VAP9VM/9VZv9Vmf9VzP9V//+AAP+AM/+AZv+Amf+AzP+A//+qAP+qM/+qZv+qmf+qzP+q///VAP/VM//VZv/Vmf/VzP/V////AP//M///Zv//mf//zP///wAAAAAAAAAAAAAAAAj/APcJHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMmTHgGoXMmypcuXMGPKnEmzps2bOG0uzMmzp8+fQIPK3AkApVGBRVEmlaiS6FGjS01GhdhUYdWnUqFSvIqQK9aRU0mGdejVYNmvIMeKVMvwLEG3aDuyTbt17j64cTfaTVnXad61Wifivbv3r8XCHBGbtTvY8OHATBkrdhxxckbLAwc3piwYcmXJnPkq7WsVc+idnqmCPq039UPNpll3dU1WstCcFWPHzk064ebWW4MLNq17dVbhTHuXhD0aeWXlYo0v5915uFLpYqknt36SeXftz7lL/8UOFjxV6GDJA3Z+Xvxy9SF360a/Fj5d9q/px7f/UT7+2tf5dVx120UWYGnNERiegd3xJ5qC7TE4noDT/ddQcQf6thuEES74WYZdbVjgiB2qBuJBv2nkH4cANkhhfizW5lNdM7qHInEWnpbiW/plhmOMOv4oYYhAoiZbQTtm1iNSQnp4JGFFIiilkzA+yWSUGr5IVo6hJYnUklCSWKWVXt4FZpnzWXmlmC1myeaFaq5JZZtEvtlWnGHOeaGDs2HpGJpnNlnikYDauJifKOJZ6JA3ImqWooK+xmeijua16IdTDrplnJeamOmYmrLWqaRawllpXKPS2Whkt+E23E8nHkxqZ3xQiYipm3qu5+KuuIaq64S81pkrrbHWV+qdtBkb7KrD3rdsescamSCw1ArrK7HPKtsrqBVmu1+0Vh1l663vgeubuLUW+1ak2amb/9akjyb7rbc+nnpZuvTKea2z1UZnbp/Tlptvnvv2h2+/sjZrsLv9wYskjTW+2mpNgQY8YLfkMovxdxwzmvDGF7frMZLjcgvyr55uWx66HWf8scgWo0zqpyvLu/DI68YM884zqyzzydi6TLLONQPdlsP3shxyz9bybPTNQufc8tRFp9x01Uv/vOe/iT1V8qY410v10w9GLXbWTgdttcZpY73nxDdxDZzNPs9bN552C3w33g0zTDDf0A5cJuCGans14X0L/jXie6eENOOF58025HItfrTclEf+LuaZm514452DWTnnoasaOOile+446amzftjjrdNs+OSxi54Y7ITBrds73H6jufvvt9mrL+1HA298xAUfLrXCZeudPPFnP9+13wCrnqrbs4NtPbvYS6792i9/T/bqs8q+vPRzI2xq2MOL3/bm5Td+vdber7+98BdZfnn8ykdvcvfwYx702mc/tNUPWez7m/sA+Dn0nW+A56Ib+QQYvqHxTy4Hc6D/KojAsWWvgEyDYPUMGEANEvCBC6RfCf+3P9TF64LTS2CIYGU+fpGQMt65IdQIhTvzjM8wOfwhBtUUxPfZUDZFZOAOkdhDLh1RVE3E32OIGEUYpo+HrvOhEf9URQpekYk9WXTiEqEYRilqMUhltKKKONVFE+aPjWn04hqpSJTj2fGOeHRJHfPIxz7urnaADKQgB0nIQhrykIhMZF4CAgA7
  """

  isPhantom = -> navigator.userAgent.indexOf('PhantomJS') isnt -1

  describe 'Scanner', -> 

    scanner = null

    beforeEach (done) -> 
      scanner = new Scanner simpleImage, done

    describe 'constructor', -> 

      it 'accepts a url', -> 

      it 'accepts an encoded image', -> 

      it 'accepts an image object', -> 

      it 'correctly initializes wallMatrix', -> 
        expect(scanner.wallMatrix).toEqual [
          [true, true, true, true, true],
          [true, true, false, false, false],
          [true, false, true, false, false],
          [true, false, false, true, false]
        ]

      it 'initializes horizontal wall histogram', -> 
        expect(scanner.wallHistogramY).toEqual [5,2,2,2]

      it 'initializes vertical wall histogram', -> 
        expect(scanner.wallHistogramX).toEqual [4,2,2,2,1]

      describe 'wall finding', -> 
        beforeEach (done) -> 
          scanner = new Scanner simpleMaze, done

        it 'finds horizontal wall coords', -> 
          expect(scanner.wallCoordsY).toEqual [5,23,42,61,80,98,116,136,153]

        it 'finds vertical wall coords', -> 
          expect(scanner.wallCoordsX).toEqual [5,26,47,69,90,111,132,153]
