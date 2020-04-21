module TopGG
    # An exception that resulted from an HTTP error code.
    class APIException < Exception
        getter status : HTTP::Status

        def self.raise_if_error(status : HTTP::Status)
            raise self.new(status) unless (100..399).includes? status.code
        end

        def initialize(@status)
        end

        # True if the status code is within the range 400..499.
        def client?
            @status.client_error?
        end

        # True if the status code is within the range 500..599.
        def server?
            @status.server_error?
        end

        def message
            "The server returned #{@status.code} #{@status.to_s}."
        end
    end
end
