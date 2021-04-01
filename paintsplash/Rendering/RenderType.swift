//
//  RenderType.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//

enum RenderType {
    case sprite(spriteName: String)
    case label(text: String)
}

extension RenderType: Codable {

    private enum CodingKeys: String, CodingKey {
      case caseType, spriteParams, labelParams
    }

    private enum CaseType: String, Codable {
        case sprite, label
    }

    private struct SpriteParams: Codable {
        let spriteName: String
    }

    private struct LabelParams: Codable {
        let text: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseType = try container.decode(CaseType.self, forKey: .caseType)

        switch caseType {
        case .sprite:
            let spriteParams = try container.decode(SpriteParams.self, forKey: .spriteParams)
            self = .sprite(spriteName: spriteParams.spriteName)
        case .label:
            let labelParams = try container.decode(LabelParams.self, forKey: .labelParams)
            self = .label(text: labelParams.text)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .sprite(let spriteName):
            try container.encode(CaseType.sprite, forKey: .caseType)
            try container.encode(SpriteParams(spriteName: spriteName), forKey: .spriteParams)
        case .label(let text):
            try container.encode(CaseType.label, forKey: .caseType)
            try container.encode(LabelParams(text: text), forKey: .labelParams)
        }
    }
}
