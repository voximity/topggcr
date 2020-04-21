# topggcr

This is an API wrapper for [top.gg's API.](https://top.gg/api/docs). It supports most endpoints, as well as has a built-in webhook server
to listen to Top.GG's vote webhooks.

## Usage

```cr
require "topggcr"

# Create a client.
client = TopGG::Client.new token: "replace_this_but_keep_it_secret"
```

### Fetching object information

```cr
# Fetch user information.
user = client.get_user 80047598504783872
puts user.username #=> voximity

# Fetch bot information.
bot = client.get_bot 691713521007984681
puts bot.name #=> Engauge

# Fetch vote information.
voters = client.get_votes
voters.each { |voter| puts voter.username }

# Check recent voting status. `#user_voted?` returns a Bool.
puts client.user_voted? 80047598504783872

# Check bot stats.
stats = client.get_bot_stats 691713521007984681
stats.server_count.try { |count| puts count }
```

### Updating bot stats

```cr
# Update stats by server count.
client.update_stats server_count: 500

# Update stats by using an existing `BotStats` object.
client.update_stats TopGG::BotStats.new(server_count: 500, shard_count: 10)

# Update stats by individually addressing shards.
client.update_stats server_count: 100, shard_id: 4
```

### Voting webhooks

```cr
# Create the webhook server.
server = TopGG::WebhookServer.new port: 8080, password: "password_you_set_in_your_bot's_config_page" do |vote|
  puts "User ID #{vote.user} has voted! Thank you!"

  # Reward the user for voting...
end

# Start the server.
server.start
```

### Unsupported endpoints

- GET `/bots` (TODO)