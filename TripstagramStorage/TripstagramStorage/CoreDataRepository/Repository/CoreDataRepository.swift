import CoreData

class CoreDataRepository {
    
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func savePosts(_ posts: [any Post]) async throws {
        let context = persistentContainer.newBackgroundContext()
        posts.forEach { post in
            insert(post: post, into: context)
        }
        try context.save()
    }
    
    private func insert(post: any Post, into context: NSManagedObjectContext) {
        switch post {
        case let imageOnlyPost as ImageOnlyPost:
            insert(post: imageOnlyPost, into: context)
        case let videoOnlyPost as VideoOnlyPost:
            insert(post: videoOnlyPost, into: context)
        case let multiSourcePost as MultiSourcePost:
            insert(post: multiSourcePost, into: context)
        default:
            break
        }
    }
    
    private func insert(post: ImageOnlyPost, into context: NSManagedObjectContext) {
        let coreDataPost = CoreDataImageOnlyPost(context: context)
        coreDataPost.id = post.id
        let source = CoreDataPostImageSource(context: context)
        source.url = post.source.url
        coreDataPost.source = source
    }
    
    private func insert(post: VideoOnlyPost, into context: NSManagedObjectContext) {
        let coreDataPost = CoreDataVideoOnlyPost(context: context)
        coreDataPost.id = post.id
        let source = CoreDataPostVideoSource(context: context)
        source.url = post.source.url
        coreDataPost.source = source
    }
    
    private func insert(post: MultiSourcePost, into context: NSManagedObjectContext) {
        let coreDataPost = CoreDataMultiSourcePost(context: context)
        coreDataPost.id = post.id
        var coreDataSources: [CoreDataPostOrderedSource] = []
        for (index, postSource) in post.sources.enumerated() {
            do {
                let coreDataSource = try insert(postSource: postSource, orderNumber: index, into: context)
                coreDataSources.append(coreDataSource)
            } catch {
                print(error)
            }
        }
        coreDataPost.sources = coreDataSources
    }
    
    private func insert(postSource: PostSource, orderNumber: Int, into context: NSManagedObjectContext) throws -> CoreDataPostOrderedSource {
        switch postSource {
        case let imageSource as PostImageSource:
            return insert(postSource: imageSource, orderNumber: orderNumber, into: context)
        case let videoSource as PostVideoSource:
            return insert(postSource: videoSource, orderNumber: orderNumber, into: context)
        default:
            throw Error("Unsupported post source type")
        }
    }
    
    private func insert(postSource: PostImageSource, orderNumber: Int, into context: NSManagedObjectContext) -> CoreDataPostOrderedImageSource {
        let coreDataSource = CoreDataPostOrderedImageSource(context: context)
        coreDataSource.url = postSource.url
        coreDataSource.orderNumber = orderNumber
        return coreDataSource
    }
    
    private func insert(postSource: PostVideoSource, orderNumber: Int, into context: NSManagedObjectContext) -> CoreDataPostOrderedVideoSource {
        let coreDataSource = CoreDataPostOrderedVideoSource(context: context)
        coreDataSource.url = postSource.url
        coreDataSource.orderNumber = orderNumber
        return coreDataSource
    }
    
    func fetchPosts() async throws -> [any Post] {
        return []
    }
}
