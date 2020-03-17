import { NativeModules } from 'react-native'

class RNPytorch {
  async loadModel(modelPath, labelPath) {
    await NativeModules.RNPytorch.loadModel(modelPath, labelPath)
  }

  async predict(imagePath) {
    const result = await NativeModules.RNPytorch.predict(imagePath)
    console.log(result)
    const sum = result.reduce((acc, cur) => acc + Number(cur.confidence), 0)
    const transformed = result.map((r, index) => {
      return {
        label: r.label,
        confidence: Number(r.confidence) / sum,
      }
    })
    return transformed
  }
}

export default new RNPytorch()
