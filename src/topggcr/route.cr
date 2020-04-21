module TopGG
    # :nodoc:
    class RouteClient
        getter http_client

        def initialize(@http_client : HTTP::Client, @token : String? = nil)
            token.try { |token| @http_client.before_request &.headers["Authorization"] = token }
        end

        def get(endpoint : String, headers : HTTP::Headers? = nil)
            response = @http_client.get("/api#{endpoint}", headers: headers)
            APIException.raise_if_error response.status
            response
        end

        def post(endpoint : String, body : Hash(String, JSON::Any) | String, headers : HTTP::Headers? = nil)
            headers ||= HTTP::Headers.new
            headers["Content-Type"] = "application/json"
            response = @http_client.post("/api#{endpoint}", headers: headers, body: body.is_a?(String) ? body : body.to_json)
            APIException.raise_if_error response.status
            response
        end
    end
end