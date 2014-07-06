module Merchantprotector
  class Configuration

    attr_accessor :api_token
    attr_accessor :enabled
    attr_accessor :endpoint
    attr_accessor :environment
    attr_accessor :request_timeout
    attr_accessor :logger
    attr_accessor :default_logger

    DEFAULT_ENDPOINT = 'https://www.merchantprotector.net/api/orders/describe'

    def initialize
      @enabled = nil  # set to true when configure is called
      @endpoint = DEFAULT_ENDPOINT
      @environment = nil
      @api_token = nil
      @request_timeout = 3
      @default_logger = lambda { Logger.new(STDERR) }
    end


  end
end