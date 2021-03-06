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
        plugin :Callbacks
        before do
          @name = "Jeanine"
        end
        before /posts/ do
          @name = "Josh"
        end
        before /foods/ do
          @favorite = params[:favorite]
        end

        get "/name" do
          response.status = 302
          @name
        end

        get "/foods" do
          @favorite
        end

        path "/posts" do
          get do
            @name
          end
        end
      end
    end

    it 'returns Jeanine' do
      get "/name"
      expect(last_response.body).must_equal "Jeanine"
    end

    it 'returns Josh' do
      get "/posts"
      expect(last_response.body).must_equal "Josh"
    end

    it 'returns favorite food' do
      get "/foods?favorite=water"
      expect(last_response.body).must_equal "water"
    end
  end
end
