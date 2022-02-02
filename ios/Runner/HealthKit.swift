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
        completion(.success(false))
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

func writeMenstrualFlowHealthKitData(arguments: Any?, completion: @escaping (Result<Bool, Error>) -> Void) {
    guard let dictionary = arguments as? Dictionary<String, Any>,
          let startDate = dictionary["startDate"] as? TimeInterval,
          let endDate = dictionary["endDate"] as? TimeInterval
    else {
        completion(.failure("argument is invalid \(String(describing: arguments))"))
        return
    }

    let start = Date(timeIntervalSince1970: startDate / 1000)
    let end = Date(timeIntervalSince1970: endDate / 1000)
    let sample = HKCategorySample.init(
        type: HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
        value: HKCategoryValueMenstrualFlow.unspecified.rawValue,
        start: start,
        end: end,
        metadata: [
            HKMetadataKeyMenstrualCycleStart: true
        ]
    )

    store.save(sample, withCompletion: { (isSuccess, error) in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(isSuccess))
        }
    })
}
