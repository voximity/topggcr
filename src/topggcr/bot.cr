module TopGG
    class Bot
        JSON.mapping(
            id: String,
            name: {type: String, key: "username"},
            discriminator: String,

            avatar: String?,
            definite_avatar: {type: String, key: "defAvatar"},
            library: {type: String, key: "lib"},
            prefix: String,
            short_description: {type: String, key: "shortdesc"},
            long_description: {type: String?, key: "longdesc"},
            tags: {type: Array(String), default: [] of String},
            website: String?,
            support: String?,
            github: String?,
            owners: {type: Array(String), default: [] of String},
            guilds: {type: Array(String), default: [] of String},

            invite: String?,
            approval_date: {type: Time, key: "date"},
            certified: {type: Bool, key: "certifiedBot"},
            vanity: String?,
            points: UInt32,
            month_points: {type: UInt32, key: "monthlyPoints"},
            donate_guild_id: {type: String?, key: "donatebotguildid"}
        )
    end

    class BotStats
        JSON.mapping(
            server_count: Int32?,
            shards: Array(Int32)?,
            shard_count: Int32?
        )

        getter server_count
        getter shards
        getter shard_count

        def initialize(@server_count : Int32? = nil, @shards : Array(Int32)? = nil, @shard_count : Int32? = nil)
        end
    end
end