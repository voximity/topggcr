module TopGG
    # Represents a request from Top.GG's webhook votes.
    class VoteRequest
        # The ID of the bot that received a vote.
        getter bot : String

        # The ID of the user that voted.
        getter user : String

        # The querystring params that were passed to the vote page on Top.GG.
        getter query : String?

        # Whether or not the request was a real vote.
        def vote?
            @type == "upvote"
        end

        # Whether or not the request was a test vote. Received by pressing the Test button on the bot config page.
        def test?
            @type == "test" 
        end

        # Whether or not the weekend multiplier is in place.
        def weekend?
            @is_weekend
        end

        JSON.mapping(
            bot: {type: String, setter: false},
            user: {type: String, setter: false},
            type: {type: String, getter: false, setter: false},
            is_weekend: {type: Bool, getter: false, setter: false},
            query: {type: String, nilable: true, setter: false}
        )
    end

    # An `HTTP::Server` that listens for vote webhooks from Top.GG.
    class WebhookServer
        # Creates a new `WebhookServer`. Requires a block that accepts a `VoteRequest` as a parameter.
        # The block is called when a valid vote request arrives.
        def initialize(@port : Int32, @password : String? = nil, &block : VoteRequest -> )
            @server = HTTP::Server.new do |context|
                context.response.content_type = "application/json"

                unless @password.nil?
                    unless context.request.headers["Authorization"]? == @password
                        context.response.status_code = 401
                        context.response.print %({"code": 401, "message": "Unauthorized"})
                        next
                    end
                end

                begin
                    block.call VoteRequest.from_json context.request.body.to_s
                    context.response.status_code = 200
                    context.response.print %({"code": 200, "message": "topggcr"})
                rescue exception
                    context.response.status_code = 500
                    context.response.print %({"code": 500, "message": "The server experienced an unknown error processing this request."})
                end
            end
        end

        # Start the server. Optionally, start this message through `Fiber.new &->{webhook_server.start}` to prevent blocking the main thread.
        def start
            address = @server.bind_tcp @port
            @server.listen
        end
    end
end
