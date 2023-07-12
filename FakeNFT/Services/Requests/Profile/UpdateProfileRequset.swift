//
//  UpdateProfileRequset.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 27.06.2023.
//

import Foundation

final class UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbc238620b8bae7ed51a1.mockapi.io/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        HttpMethod.put
    }

    var dto: Encodable?

    init(newProfile: Profile) {
        dto = newProfile
    }
}
