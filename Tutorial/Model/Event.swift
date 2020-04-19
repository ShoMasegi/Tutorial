import Domain

final class Event {
    let id: String
    let type: String
    let actor: User
    let repo: Repository

    init(with event: Domain.Event) {
        id = event.id
        type = event.type
        actor = User(with: event.actor)
        repo = Repository(with: event.repo)
    }
}
