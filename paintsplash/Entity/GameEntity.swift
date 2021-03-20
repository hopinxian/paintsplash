//
//  Entity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import Foundation

class GameEntity {
    var id: UUID = UUID()
    var components = [Component]()

    init() {
        for component in components {
            component.entity = self
        }
    }

    func getComponent<ComponentType: Component>(type: ComponentType.Type) -> ComponentType? {
        components.compactMap({ $0 as? ComponentType }).first
    }

    func getAllComponents<ComponentType: Component>(type: ComponentType.Type) -> [ComponentType] {
        components.compactMap({ $0 as? ComponentType })
    }

    func addComponent<Type: Component>(_ component: Type) {
        // TODO Check Requirements Available
        let requirements = component.getRequirements()
        for requirement in requirements {
            if let requiredComponent = getComponent(type: requirement) {
                component.setRequiredComponent(requiredComponent)
            } else {
                fatalError("Component Requirements Not Met")
            }
        }
        components.append(component)
    }

    func spawn(gameManager: GameManager) {
        gameManager.addObject(self)
    }

    func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
    }

    func update() {

    }
}

extension GameEntity: Hashable {
    static func == (lhs: GameEntity, rhs: GameEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
