require 'test_helper'

describe Jeanine::App do
  include Jeanine::Mock
  include Rack::Test::Methods

  def app
    @app
  end

  before do
    mock_app do
      %w(DELETE GET HEAD OPTIONS PATCH POST PUT).each do |verb|
        class_eval "#{verb.downcase}('/') { '#{verb}' }"
        class_eval "#{verb.downcase}('/route.json') { '#{verb} /route.json' }"
        class_eval "#{verb.downcase}('/route/:id.json') { request.params[:id] }"
        class_eval "#{verb.downcase}('/params/:name') { request.params[:name] }"
      end
    end
  end

  %w(DELETE GET HEAD OPTIONS PATCH POST PUT).each do |verb|
    str = <<EOS
  describe "::#{verb.downcase}" do
    it 'must extract the params' do
      route = app.to_app.class.router.routes[:#{verb}].last
      expect(route[:params]).must_equal [:name]
    end
  end
EOS
    class_eval str
  end
end

