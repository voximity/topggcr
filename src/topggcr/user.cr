module TopGG
    # A user object with limited information available.
    class SimpleUser
        JSON.mapping(
            id: String,
            username: String,
            discriminator: String,
            avatar: {type: String?, getter: false, setter: false}
        )
    end

    # A user object.
    class User < SimpleUser
        JSON.mapping(
            id: String,
            username: String,
            discriminator: String,
            avatar: {type: String?, getter: false, setter: false},

            definite_avatar: {type: String?, key: "defAvatar", getter: false, setter: false},

            bio: String?,
            banner: String?,

            youtube: {type: String?, root: "social"},
            reddit: {type: String?, root: "social"},
            twitter: {type: String?, root: "social"},
            instagram: {type: String?, root: "social"},
            github: {type: String?, root: "social"},

            color: {type: String?, getter: false, setter: false},
            supporter: Bool,
            certified: {type: Bool, key: "certifiedDev"},
            moderator: {type: Bool, key: "mod"},
            website_moderator: {type: Bool, key: "webMod"},
            administrator: {type: Bool, key: "admin"}
        )
    end
end