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
    let sample = HKCategorySample.init(
        type: HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
        value: HKCategoryValueMenstrualFlow.unspecified.rawValue,
        start: begin,
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
