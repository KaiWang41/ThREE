//import Foundation
//import CreateMLUI
//
//// 定义数据源
//let trainDirectory = URL(fileURLWithPath: "/Users/createml/Desktop/Fruits")
//let testDirectory = URL(fileURLWithPath: "/Users/createml/Desktop/TestFruits")
//
//// 训练模型
//let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainDirectory))
//
//// 评估模型
//let evaluation = model.evaluation(on: .labeledDirectories(at: testDirectory))
//
//// 保存模型
//try model.write(to: URL(fileURLWithPath: "/Users/createml/Desktop/FruitClassifier.mlmodel"))
import CreateMLUI

let builder = MLImageClassifierBuilder()
builder.showInLiveView()


