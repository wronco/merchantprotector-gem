require 'net/https'
require 'uri'
require 'multi_json'

require 'merchantprotector/version'
require 'merchantprotector/configuration'

module Merchantprotector
  
  
  class << self
    attr_writer :configuration


    # Configures the gem.
    #
    # Call on app startup to set the `api_token` (required) and other config params.
    # In a Rails app, this is called by `config/initializers/merchantprotector.rb` which is generated
    # with `rails generate merchantprotector api-token-here`
    #
    # @example
    #   Merchantprotector.configure do |config|
    #     config.api_token = 'abcdefg'
    #   end
    def configure
      # if configuration.enabled has not been set yet (is still 'nil'), set to true.
      if configuration.enabled.nil?
        configuration.enabled = true
      end
      yield(configuration)
    end

    def reconfigure
      @configuration = Configuration.new
      @configuration.enabled = true
      yield(configuration)
    end

    def unconfigure
      @configuration = nil
    end

    # Returns the configuration object.
    #
    # @return [Merchantprotector::Configuration] The configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Sends order details to Merchant Protector. Returns true on success, false on failure.
    #
    # @example
    #   class ChargesController < ApplicationController
    #     def process_payment
    #       ... do stuff with the stripe token ...
    #       Merchantprotector.report_transaction(params[:stripeToken], request)
    #       ... do other payment related stuff ...
    #     end
    #
    # @param stripe_token [String] The exception object to report
    # @param request_data [Object] Data describing the request. In a rails controller, just pass the `request` object.
    def report_transaction(stripe_token, request_data)
      data = {
        stripe_token: stripe_token,
        browser_ip: request_data.remote_ip,
        referer: request_data.referer,
        user_agent: request_data.user_agent,
        api_token: configuration.api_token,
        timestamp: Time.now.to_i,
        environment: configuration.environment,
        language: 'ruby',
        host: Socket.gethostname,
        notifier: {
          name: 'merchantprotector-gem',
          version: VERSION
        }
      }

      if defined?(SecureRandom) and SecureRandom.respond_to?(:uuid)
        data[:uuid] = SecureRandom.uuid
      end
       
      uri = URI.parse(configuration.endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = configuration.request_timeout
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
      request.body = MultiJson.dump(data)
      response = http.request(request)

      if response.code == '200'
        log_info '[Merchantprotector] Successfully logged transaction'
      else
        log_warning "[Merchantprotector] Unexpected status code from Merchantprotector api: #{response.code}"
        log_info "[Merchantprotector] Response: #{response.body}"
      end
    end


   # wrappers around logger methods
    def log_error(message)
      begin
        logger.error message
      rescue => e
        puts "[Merchantprotector] Error logging error:"
        puts "[Merchantprotector] #{message}"
      end
    end

    def log_info(message)
      begin
        logger.info message
      rescue => e
        puts "[Merchantprotector] Error logging info:"
        puts "[Merchantprotector] #{message}"
      end
    end

    def log_warning(message)
      begin
        logger.warn message
      rescue => e
        puts "[Merchantprotector] Error logging warning:"
        puts "[Merchantprotector] #{message}"
      end
    end
    def log_debug(message)
      begin
        logger.debug message
      rescue => e
        puts "[Merchantprotector] Error logging debug"
        puts "[Merchantprotector] #{message}"
      end
    end

    private

    def logger
      # init if not set
      unless configuration.logger
        configuration.logger = configuration.default_logger.call
      end
      configuration.logger
    end





  end
end