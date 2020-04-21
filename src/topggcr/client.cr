module TopGG
    # A Top.GG API client.
    class Client
        getter token
        getter http_client

        # Initialize the client. Optionally specify the token.
        def initialize(@token : String? = nil)
            @http_client = HTTP::Client.new("top.gg", tls: true)
            @routes = RouteClient.new(@http_client, token: @token)
        end

        # Fetches information about a user given their `id`.
        def get_user(id : String)
            response = @routes.get "/users/#{id}"
            response.body?.try { |body| return User.from_json body }
            raise "Blank response"
        end

        # Fetches information about a user given their `id` as an `Int`.
        def get_user(id : Int)
            get_user id.to_s
        end

        # Fetches information about a bot given their `id`.
        def get_bot(id : String)
            response = @routes.get "/bots/#{id}"
            response.body?.try { |body| return Bot.from_json body }
            raise "Blank response"
        end

        # Fetches information about a bot given their `id` as an `Int`.
        def get_bot(id : Int)
            get_bot id.to_s
        end

        # Fetches an array of `SimpleUser`s that represent the last 1,000 votes this bot has received.
        # Top.GG's API advises that this endpoint should only be called if the bot does not receive
        # over 1,000 monthly votes.
        def get_votes
            response = @routes.get "/bots/votes"
            response.body?.try { |body| return Array(SimpleUser).from_json body }
            raise "Blank response"
        end

        # Returns true if the user represented by `user_id` has voted for the bot in the past 12 hours.
        def user_voted?(user_id : String)
            response = @routes.get "/bots/check?userId=#{user_id}"
            response.body?.try do |body|
                object = Hash(String, Int32).from_json body
                raise "Invalid response" unless object.has_key? "voted"
                return object["voted"] == 1
            end
            raise "Blank response"
        end

        # Returns true if the user represented by `user_id`, as an `Int`, has voted for the bot in the past 12 hours.
        def user_voted?(user_id : Int)
            user_voted? user_id.to_s
        end

        # Fetches the `BotStats` of the bot with the `id` provided.
        def get_bot_stats(id : String)
            response = @routes.get "/bots/#{id}/stats"
            response.body.try { |body| return BotStats.from_json body }
            raise "Blank response"
        end

        # Fetches the `BotStats` of the bot with the `id`, as an `Int`, provided.
        def get_bot_stats(id : Int)
            get_bot_stats id.to_s
        end

        # Updates the bot's stats using a `BotStats` object.
        def update_stats(stats : BotStats)
            response = @routes.post "/bots/stats", body: stats.to_json
        end

        # Update the bot's stats given the `server_count`.
        def update_stats(server_count : UInt32)
            response = @routes.post "/bots/stats", body: BotStats.new(server_count: server_count).to_json
        end

        # Update the bot's stats as an `Array(UInt32)` of shard-guild counts.
        def update_stats(shards : Array(UInt32))
            response = @routes.post "/bot/stats", body: BotStats.new(shards: shards).to_json
        end

        # Update the bot's stats by passing the `server_count` from a single `shard_id`. Optionally, specify the `shard_count`.
        def update_stats(server_count : UInt32, shard_id : UInt32, shard_count : UInt32? = nil)
            response = @routes.post "/bot/stats", body: %Q({"server_count": #{server_count}, "shard_id": #{shard_id}, "shard_count": #{shard_count}})
        end
    end
end
