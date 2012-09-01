
# Collection of functions that are embedded in an iframe on S3.  These functions provide a way to
# circumvent cross-origin XHR commands.
class DataOnWire
  @validOrigins = ["http://0.0.0.0:9294"]
  
  constructor: -> window.addEventListener("message", @receiveMessage, false)
  
  receiveMessage: (e) =>
    bands     = e.data.bands
    location  = e.data.location
    
    for band in bands
      do (band) =>
        url = "#{location}_#{band}.fits.fz"
        console.log url
        
        xhr = new XMLHttpRequest()
        xhr.open('GET', url)
        xhr.responseType = 'arraybuffer'
        xhr.onload = =>
          msg =
            origin: url
            band: band
            arraybuffer: xhr.response
          
          @sendMessage(msg)
          
        xhr.send()
  
  sendMessage: (msg) =>
    console.log 'sendMessage'
    window.parent.postMessage(msg, DataOnWire.validOrigins[0])
  
@DataOnWire = DataOnWire