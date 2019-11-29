// RNPytorch.swift

@objc(RNPytorch)
class RNPytorch: NSObject {
    
  private var model : TorchModule?
  private var labels : [String]?

  @objc(loadModel:labelPath:resolver:rejecter:)
  func loadModel(modelPath: String, labelPath: String, resolve: RCTPromiseResolveBlock,  reject: RCTPromiseRejectBlock) -> Void {
    do {
      if let filePath = Bundle.main.path(forResource: modelPath, ofType: "pt"),
          let module = TorchModule(fileAtPath: filePath) {
          self.model = module
      } else {
          throw NSError(domain: "", code:401, userInfo: nil)
      }
      if let filePath = Bundle.main.path(forResource: labelPath, ofType: "txt"),
          let labels = try? String(contentsOfFile: filePath) {
          self.labels = labels.components(separatedBy: .newlines)
      } else {
          throw NSError(domain: "", code:401, userInfo: nil)
      }
    } catch {
      reject("", "Error during loadModel", error)
    }
  }

  @objc(predict:resolver:rejecter:)
  func predict(imagePath: String, resolve: RCTPromiseResolveBlock,  reject: RCTPromiseRejectBlock) -> Void {
    do {
    let url = NSURL(string: imagePath)
    let data = NSData(contentsOf: url! as URL)

    let image = UIImage(data: data! as Data)
    let resizedImage = image!.resized(to: CGSize(width: 224, height: 224))
    guard var pixelBuffer = resizedImage.normalized() else {
        throw NSError(domain: "", code:401, userInfo: nil)
    }
    guard let outputs = self.model!.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
        throw NSError(domain: "", code:401, userInfo: nil)
    }
    let zippedResults = zip(self.labels!.indices, outputs)
    let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }
    var results = [[String: Any]]()

    for result in sortedResults {
        let row = ["label": self.labels![result.0], "confidence": result.1.floatValue] as [String: Any]
        results.append(row)
    }
    resolve(results)
    } catch {
        reject("", "Error during prediction", error)
    }
  }
}
