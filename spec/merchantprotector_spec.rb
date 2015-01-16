require 'spec_helper'

describe Merchantprotector do

  describe '#report_transaction' do
    before(:each) do
      configure
      Merchantprotector.configure do |config|
        config.logger = logger_mock
      end
      @request_data = double(ActionDispatch::Request,
        request_parameters: {},
        remote_ip: "127.1.1.1",
        referer: "http://example.com/page",
        user_agent: "Chrome v8" 
      )
      stub_request(:post, Merchantprotector.configuration.endpoint)
    end

    let(:logger_mock) { double("Rails.logger").as_null_object }

    it 'should send data to the configured endpoint' do
      Merchantprotector.report_transaction('st_12345', @request_data)
      assert_requested :post, Merchantprotector.configuration.endpoint
    end

    it 'should send valid JSON' do
      skip
    end

    it 'should send a user agent string' do 
      Merchantprotector.report_transaction('st_12345', @request_data)
      WebMock.should have_requested(:post, Merchantprotector.configuration.endpoint).with(:data => { :user_agent => 'Chrome v8' })
    end

    it 'should send a Stripe token' do
      stripe_transaction_id = "st_12321213"
      Merchantprotector.report_transaction(stripe_transaction_id, @request_data)
      WebMock.should have_requested(:post, Merchantprotector.configuration.endpoint).with(:data => { :stripe_token => stripe_transaction_id })
    end

    it 'should send the overridden IP address if provided' do
      override_ip = "2.3.4.5"
      Merchantprotector.report_transaction('st_12345', @request_data, { browser_ip: override_ip })
      WebMock.should have_requested(:post, Merchantprotector.configuration.endpoint).with(:data => { :browser_ip => override_ip })
    end

    it 'should return true when the request is successful' do
      Merchantprotector.report_transaction('st_12345', @request_data).should_return true
    end

    it 'should return false when the request fails' do
      stub_request(:post, Merchantprotector.configuration.endpoint).to_return(status: 500)
      Merchantprotector.report_transaction('st_12345', @request_data).should_return false
    end
  end

  # configure with some basic params
  def configure
    Merchantprotector.reconfigure do |config|
      # special test access token
      config.api_token = 'aaaabbbbccccddddeeeeffff00001111'
      config.logger = ::Rails.logger
      config.request_timeout = 60
      config.environment = ::Rails.env
    end
  end

end