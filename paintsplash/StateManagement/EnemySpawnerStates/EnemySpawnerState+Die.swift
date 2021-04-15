//
//  EnemySpawnerState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
extension EnemySpawnerState {
    class Die: EnemySpawnerState {
        override func onEnterState() {
            EventSystem.audioEvent.playSoundEffectEvent.post(event: PlaySoundEffectEvent(effect: SoundEffect.enemySpawn))
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerDie,
                interupt: true,
                callBack: { [weak self] in
                    self?.spawner.destroy()
                }
            )
        }
    }
}
