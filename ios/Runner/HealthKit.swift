import HealthKit

let store = HKHealthStore()
let writeTypes: Set<HKSampleType>? = {
    guard let category = HKSampleType.categoryType(forIdentifier: .menstrualFlow) else {
        return nil
    }
    return [category]
}()
let readTypes: Set<HKObjectType>? = {
    guard let object = HKObjectType.categoryType(forIdentifier: .menstrualFlow) else {
        return nil
    }
    return [object]
}()

struct HealthKitGeneralError: Error {
    let result = "failure"
    let reason: String

    func toDictionary() -> [String: Any] {
        ["result": result, "reason": reason]
    }
}

func requestWriteMenstrualFlowHealthKitDataPermission(
    completion: @escaping (Result<Bool, HealthKitGeneralError>) -> Void
)  {
    store.requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (status, error) in
        if let error = error {
            completion(.failure(.init(reason: error.localizedDescription)))
        } else {
            completion(.success(status))
        }
    })
}

func readMenstruationData(arguments: Any?, completion: @escaping (Result<HKSample?, HealthKitGeneralError>) -> Void) {
    guard let json = arguments as? Dictionary<String, Any>, let menstruation = json["menstruation"] as? Dictionary<String, Any> else {
        completion(.failure(.init(reason: "生理データの読み込みに失敗しました arguments: \(String(describing: arguments))")))
        return
    }
    guard let uuidString = menstruation["healthKitSampleDataUUID"] as? String else {
        completion(.success(nil))
        return
    }
    guard let uuid = UUID(uuidString: uuidString) else {
        completion(.failure(.init(reason: "ヘルスケアデータのIDのフォーマットに失敗しました: \(uuidString)")))
        return
    }
    guard let menstrualFlowSample = HKSampleType.categoryType(forIdentifier: .menstrualFlow) else {
        completion(.failure(.init(reason: "ヘルスケアが生理データに対応していません")))
        return
    }
    

    let predicate = HKQuery.predicateForObject(with: uuid)
    let query = HKSampleQuery(sampleType: menstrualFlowSample, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { sampleQuery, samples, error in
        // The results come back on an anonymous background queue.
        // Dispatch to the main queue before modifying the UI.
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(.init(reason: error.localizedDescription)))
            } else if let samples = samples {
                completion(.success(samples.first))
            } else {
                completion(.failure(.init(reason: "ヘルスケアからのデータ読み込みに失敗しました")))
            }
        }
    }

    store.execute(query)
}

// MARK: - Write
enum HealthKitWriteResult {
    typealias Failure = HealthKitGeneralError

    struct Success {
        let result = "success"
        let healthKitSampleDataUUID: UUID

        func toDictionary() -> [String: Any] {
            ["result": result, "healthKitSampleDataUUID": healthKitSampleDataUUID.uuidString]
        }
    }
}

func addMenstrualFlowHealthKitData(
    arguments: Any?,
    completion: @escaping (Result<HealthKitWriteResult.Success, HealthKitWriteResult.Failure>) -> Void
) {
    writeMenstrualFlowHealthKitData(arguments: arguments, sample: nil, completion: completion)
}

func updateOrAddMenstruationFlowHealthKitData(
    arguments: Any?,
    completion: @escaping (Result<HealthKitWriteResult.Success, HealthKitWriteResult.Failure>) -> Void
) {
    readMenstruationData(arguments: arguments) { readResult in
        switch readResult {
        case .success(let sample):
            writeMenstrualFlowHealthKitData(arguments: arguments, sample: sample, completion: completion)
        case .failure(let error):
            completion(.failure(.init(reason: error.localizedDescription)))
        }
    }
}

private func writeMenstrualFlowHealthKitData(
    arguments: Any?,
    sample: HKSample?,
    completion: @escaping (Result<HealthKitWriteResult.Success, HealthKitWriteResult.Failure>) -> Void
) {
    guard let json = arguments as? Dictionary<String, Any>,
          let menstruation = json["menstruation"] as? Dictionary<String, Any>,
          let beginDate = menstruation["beginDate"] as? NSNumber,
          let endDate = menstruation["endDate"] as? NSNumber
    else {
        completion(.failure(.init(reason: "生理データの書き込みに失敗しました arguments: \(String(describing: arguments))")))
        return
    }

    let begin = Date(timeIntervalSince1970: beginDate.doubleValue / 1000)
    let end = Date(timeIntervalSince1970: endDate.doubleValue / 1000)

    let writeData: HKSample
    if let sample = sample {
        writeData = sample
    } else {
        writeData = HKCategorySample.init(
            type: HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
            value: HKCategoryValueMenstrualFlow.unspecified.rawValue,
            start: begin,
            end: end,
            metadata: [
                HKMetadataKeyMenstrualCycleStart: true
            ]
        )
    }

    store.save(writeData, withCompletion: { (isSuccess, error) in
        if let error = error {
            completion(.failure(.init(reason: error.localizedDescription)))
        } else {
            if isSuccess {
                completion(.success(.init(healthKitSampleDataUUID: writeData.uuid)))
            } else {
                completion(.failure(.init(reason: "書き込みに失敗しました")))
            }
        }
    })
}



// MARK: - Delete
enum HealthKitDeleteResult {
    typealias Failure = HealthKitGeneralError

    struct Success {
        let result = "success"

        func toDictionary() -> [String: Any] {
            ["result": result]
        }
    }
}

func deleteMenstrualFlowHealthKitData(
    arguments: Any?,
    completion: @escaping (Result<HealthKitDeleteResult.Success, HealthKitDeleteResult.Failure>) -> Void
) {
    readMenstruationData(arguments: arguments) { readResult in
        switch readResult {
        case .success(let sample):
            if let sample = sample {
                store.delete(sample) { isSuccess, error in
                    if let error = error {
                        completion(.failure(.init(reason: error.localizedDescription)))
                    } else {
                        if isSuccess {
                            completion(.success(.init()))
                        } else {
                            completion(.failure(.init(reason: "削除に失敗しました")))
                        }
                    }
                }
            } else {
                completion(.failure(.init(reason: "削除するデータの読み込みに失敗しました")))
            }
        case .failure(let error):
            completion(.failure(.init(reason: error.localizedDescription)))
        }
    }
}
