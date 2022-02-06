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

func requestWriteMenstrualFlowHealthKitDataPermission(
    completion: @escaping (Result<Bool, Error>) -> Void
)  {
    if !HKHealthStore.isHealthDataAvailable() {
        completion(.failure("HealthKit not available on Device"))
        return
    }

    store.requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (status, error) in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(status))
        }
    })
}

func readMenstruationData(arguments: Any?, completion: @escaping (Result<HKSample, Error>) -> Void) {
    guard let json = arguments as? Dictionary<String, Any>, let menstruation = json["menstruation"] as? Dictionary<String, Any> else {
        completion(.failure("argument is invalid \(String(describing: arguments))"))
        return
    }
    guard let uuidString = menstruation["healthKitObjectUUID"] as? String else {
        completion(.failure("healthKitObjectUUID is not found"))
        return
    }
    guard let uuid = UUID(uuidString: uuidString) else {
        completion(.failure("healthKitObjectUUID is invalid: \(uuidString)"))
        return
    }
    guard let menstrualFlowSample = HKSampleType.categoryType(forIdentifier: .menstrualFlow) else {
        completion(.failure("menstrualFlowSample is not available"))
        return
    }
    

    let predicate = HKQuery.predicateForObject(with: uuid)
    let query = HKSampleQuery(sampleType: menstrualFlowSample, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { sampleQuery, samples, error in
        // The results come back on an anonymous background queue.
        // Dispatch to the main queue before modifying the UI.
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(error))
            } else if let samples = samples {
                if let sample = samples.first {
                    completion(.success(sample))
                } else {
                    completion(.failure("retrieved samples is empty"))
                }
            } else {
                completion(.failure("Unexpected query result for samples and error are empty"))
            }
        }
    }

    store.execute(query)
}

func addMenstrualFlowHealthKitData(
    arguments: Any?,
    completion: @escaping (Result<(object: HKObject, isSuccess: Bool), Error>) -> Void
) {
    writeMenstrualFlowHealthKitData(arguments: arguments, sample: nil, completion: completion)
}

func updateMenstruationFlowHealthKitData(
    arguments: Any?,
    completion: @escaping (Result<(object: HKObject, isSuccess: Bool), Error>) -> Void
) {
    readMenstruationData(arguments: arguments) { readResult in
        switch readResult {
        case .success(let sample):
            writeMenstrualFlowHealthKitData(arguments: arguments, sample: sample, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

private func writeMenstrualFlowHealthKitData(
    arguments: Any?,
    sample: HKSample?,
    completion: @escaping (Result<(object: HKObject, isSuccess: Bool), Error>) -> Void
) {
    guard let json = arguments as? Dictionary<String, Any>,
          let menstruation = json["menstruation"] as? Dictionary<String, Any>,
          let beginDate = menstruation["beginDate"] as? NSNumber,
          let endDate = menstruation["endDate"] as? NSNumber
    else {
        completion(.failure("argument is invalid \(String(describing: arguments))"))
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
            completion(.failure(error))
        } else {
            completion(.success((writeData, isSuccess)))
        }
    })
}
