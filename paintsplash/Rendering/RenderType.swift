//
//  RenderType.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//

enum RenderType {
    case sprite(spriteName: String)
    case label(text: String, fontName: String, fontSize: Double, fontColor: FontColor)
    case scene(name: String)
}

extension RenderType: Codable {
    private enum CodingKeys: String, CodingKey {
      case caseType, spriteParams, labelParams, sceneParams
    }

    private enum CaseType: String, Codable {
        case sprite, label, scene
    }

    private struct SpriteParams: Codable {
        let spriteName: String
    }

    private struct LabelParams: Codable {
        let text: String
        let fontName: String
        let fontSize: Double
        let fontColor: FontColor
    }

    private struct SceneParams: Codable {
        let name: String
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
            self = .label(
                text: labelParams.text,
                fontName: labelParams.fontName,
                fontSize: labelParams.fontSize,
                fontColor: labelParams.fontColor
            )
        case .scene:
            let sceneParams = try container.decode(SceneParams.self, forKey: .sceneParams)
            self = .scene(name: sceneParams.name)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .sprite(let spriteName):
            try container.encode(CaseType.sprite, forKey: .caseType)
            try container.encode(SpriteParams(spriteName: spriteName), forKey: .spriteParams)
        case let .label(text, fontName, fontSize, fontColor):
            try container.encode(CaseType.label, forKey: .caseType)
            try container.encode(
                LabelParams(
                    text: text,
                    fontName: fontName,
                    fontSize: fontSize,
                    fontColor: fontColor
                ),
                forKey: .labelParams
            )
        case .scene(let name):
            try container.encode(CaseType.scene, forKey: .caseType)
            try container.encode(SceneParams(name: name), forKey: .sceneParams)
        }
    }
}
