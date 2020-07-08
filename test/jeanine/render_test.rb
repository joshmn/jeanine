require 'test_helper'
require 'tempfile'
describe Jeanine::App do
  include Jeanine::Mock
  include Rack::Test::Methods

  def app
    @app
  end

  describe 'render' do
    before do
      mock_app do
        append_view_path "test/fixtures/views"
        get "/comments/new" do
          @id = "new"
          render template: "comments/new.html.erb"
        end
        get "/comments/123" do
          render json: { id: 123 }
        end
        get "/comments/234" do
          render text: "234"
        end
      end
    end
    it 'returns form new.html' do
      get "/comments/new"
      expect(last_response.body).must_equal "form new.html\n"
    end

    it 'returns JSON' do
      get "/comments/123"
      expect(last_response.body).must_equal({ id: 123 }.to_json)
    end

    it 'returns text' do
      get "/comments/234"
      expect(last_response.body).must_equal("234")
    end
  end
end
