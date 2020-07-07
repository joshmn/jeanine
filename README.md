# Brody

A Ruby micro-web-framework that gives you enough training wheels to be productive, while being as nearly as fast as Rack itself.

Its design (and some parts of the code) is influenced by/inherited from (thanks!) Ruby on Rails, Rack::App, Hobbit, and Cuba. Without them this is nothing.
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brody'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install brody

## Basic usage

Drop this into `config.ru`:

```ruby
require 'bundler/setup'
require 'brody'

class App < Brody::App
  get "" do
    "Hello world"
  end
end

run App 
```

`$ rackup`

## Advanced usage 

```ruby
class App < Brody::App 
  path "/posts" do 
    get do 
      "Posts get"
    end 
    get "new" do 
      "Posts new"
    end
    post do 
      "Posts post"
    end 
    path ":id" do 
      get do 
        "Posts #{params[:id]}"
      end
      match via: [:put, :patch] do 
        "Posts #{request.via} #{params[:id]}"
      end
      delete do
        "Posts delete #{params[:id]}" 
      end 
      path "/comments" do
        get do 
          "Posts #{params[:id]} comments"
        end 
      end
    end 
  end 
end 
```

### Callbacks 

Supports `before` and `after` callbacks (same DSL): 

```
class App < Brody::App
  before do 
    puts "All"
  end
  before /posts/ do
    puts "Before posts"
  end 
  before /posts\/\d*/, /comments\/\d*/  do 
    puts "Before posts/:id, comments/:id"
    response.headers['X-Thing-Id'] = params[:id]
  end 
end 
```

### Rendering

Basic support for rendering. Be explicit.

```ruby 
class App < Brody::App
  # loads views/root.html.erb and views/layouts/application.html.erb
  root do 
    @title = "My cool app"
    render template: "root.html.erb", layout: "application.html.erb"
  end
end 
```

## Development

### Ideologies

* No meaningless metaprogramming = fast 

## Benchmarks 

### Requests/second

```
Framework            Requests/sec  % from best
----------------------------------------------
rack                     17299.31      100.00%
broding                  16087.19       92.99%
brody                    16022.71       92.62%
rack-response            15462.50       89.38%
syro                     15416.13       89.11%
watts                    15307.52       88.49%
roda                     14550.56       84.11%
hanami-router            14342.92       82.91%
cuba                     14246.23       82.35%
hobbit                   14132.20       81.69%
rambutan                 12526.40       72.41%
rack-app                 11696.66       67.61%
flame                     7931.61       45.85%
rails-metal               7761.75       44.87%
sinatra                   4616.81       26.69%
grape                     2401.66       13.88%
hobby                     1805.93       10.44%
rails-api                 1593.77        9.21%
```

### Memory

```
Framework       Allocs/Req Memsize/Req
--------------------------------------
rack                    40        3408
roda                    43        4016
syro                    44        4288
cuba                    44        4056
watts                   46        3648
hobbit                  48        4416
brody                   50        4496
hobby                   52        5416
broding                 54        4656
rack-response           55        5128
rails-metal             59        5848
hanami-router           63        5184
rambutan                79        6944
rack-app                80        8424
flame                  115        9648
sinatra                179       13440
grape                  250       26704
rails-api              383       34949
```

## Todo 

* Callback constraints 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/brody.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
