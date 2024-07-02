
import Vapor
import SSEKit

func routes(_ app: Application) throws {

    let eventStream = AsyncStream<ServerSentEvent>.makeStream()
    
    app.on(.GET, "makeevent") { req -> Response in

        let now = SSEValue(string: Date.now.ISO8601Format())
        let event = ServerSentEvent(data: now)
        
        let _ = eventStream.continuation.yield(event)

        return .init(status: .ok,
                     version: .http1_1,
                     headers: .init(),
                     body: .empty)
    }
    
    app.on(.GET, "sse", body: .stream) { req -> Response  in
        req.logger.info("returning resp")

        return Response(status: .ok,
                        version: .http1_1,
                        headers: .init([("content-type", "text/event-stream"),
                                        ("transfer-encoding", "chunked")]),
                        body: .init(asyncStream: { writer in
            
            req.logger.info("getting stuff in async body stream...")
            let stuff = eventStream.stream.mapToByteBuffer(allocator: app.allocator)
            do {
                for try await event in stuff {
                    req.logger.info("writting event in response for \(req.id)")
                    try await writer.writeBuffer(event)
                }
            }
            catch {
                req.logger.error("\(error)")
                req.logger.error("writting end")
                try await writer.write(.error(error))
            }
            
            // is this ever reached?
                req.logger.info("writting end")
                try await writer.write(.end)
        }))
        
        
    }
}

