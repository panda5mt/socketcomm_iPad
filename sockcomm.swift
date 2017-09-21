/* 
 Socket communication on Static IP
 Works on Swift 3.1 + playgrounds support
 */
import UIKit
import PlaygroundSupport

let addr = "192.168.0.123"
let port = 4567  //PORT Num

var buffer = [UInt8](repeating: 0, count: 255)

var inp : InputStream?
var out : OutputStream?
Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inp, outputStream: &out)

if inp != nil && out != nil {
    let inputStream : InputStream = inp!
    let outputStream : OutputStream = out!
    inputStream.open()
    outputStream.open()
    
    if outputStream.streamError == nil && inputStream.streamError == nil {
        let queryString = "data send by me(Client)"
        let queryData = [UInt8](queryString.utf8) 
        while true {
            UnsafePointer<UInt8>(queryData)
            outputStream.write(queryData, maxLength: queryData.count)
            var readChars: Int = inputStream.read(&buffer, maxLength: buffer.count)
            if (readChars > 0) {
                let readString: String = NSString(data: NSData(bytes:buffer, length:readChars) as Data, encoding: String.Encoding.utf8.rawValue)! as String
                print(readString) //  data from server
                usleep(300 * 1000) // wait 300 msec (just wait. it is no meaning. using as "NOP") 
                }
             
            } else {
                print ("server closed connection")
                inputStream.close()
                outputStream.close()
                break
            }
        }
    } else {
        print ("could not create socket")
    }
} else {
    print ("could not initialize stream")
}
