import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {

    // serve test page
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // configure CORS
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)
    
    // register routes
    try routes(app)
}
