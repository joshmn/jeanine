require 'test_helper'

describe Jeanine::App do
  include Jeanine::Mock
  include Rack::Test::Methods

  def app
    @app
  end

  describe 'callbacks' do
    before do
      mock_app do
        plugin :Rescuing
        rescue_from NoMethodError do |exception|
          response.status = 404
          exception.message
        end

        get "/is-a-handled-error" do
          raise NoMethodError, "This is an error message"
        end

        get "/not-an-error" do
          "Not an error"
        end

        get "/is-an-unhandled-error" do
          raise StandardError
        end
      end
    end

    it 'returns an error message' do
      get "/is-a-handled-error"
      expect(last_response.body).must_equal "This is an error message"
      expect(last_response.status).must_equal(404)
    end

    it 'returns an error message' do
      proc do
        get "/is-an-unhandled-error"
      end.must_raise(StandardError)
    end

    it 'returns not an error' do
      get "/not-an-error"
      expect(last_response.body).must_equal "Not an error"
    end
  end
end
