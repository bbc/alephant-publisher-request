# Alephant::Publisher::Request

Dynamic publishing based on data from an API.

[![Build Status](https://travis-ci.org/BBC-News/alephant-publisher-request.png?branch=master)](https://travis-ci.org/BBC-News/alephant-publisher-request) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-publisher-request.png)](https://gemnasium.com/BBC-News/alephant-publisher-request) [![Gem Version](https://badge.fury.io/rb/alephant-publisher-request.png)](http://badge.fury.io/rb/alephant-publisher-request)

## Dependencies

- JRuby 1.7.8

## Migrating from [Alephant::Publisher](https://github.com/BBC-News/alephant-publisher)

Add the new gem to your Gemfile:

    gem 'alephant-publisher-request'

Run:

    bundle install

Require the new gem in your app:

    require 'alephant/publisher/request'


**Note** - the namespace has changed from `Alephant::Publisher` to `Alephant::Publisher::Request`.

## Installation

Add this line to your application's Gemfile:

    gem 'alephant-publisher-request'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alephant-publisher-request

## Setup

You need to run the gem as a rack application, and pass it the necessary dependencies. Below is a simple example of the minimum needed to run the server:

### Folder structure

```bash
src
├── components
│   ├── my_test_component
│   │   ├── fixtures
│   │   │    ├── responsive.json
│   │   ├── templates
│   │   │    ├── my_test_component.mustache
│   │   ├── models
│   │   │    ├── my_test_component.rb
│   │   ├── mapper.rb
```

#### Model example

The model must extend either the JSON or HTML base from the [alephant-renderer](https://www.github.com/BBC-News/alephant-renderer) `Alephant::Renderer::Views::Html` or `Alephant::Renderer::Views::Json`.

```ruby
require 'alephant/renderer/views/html'

module SomeNameSpace
  class MyTestComponent < Alephant::Renderer::Views::Html

    def some_method
	  @body.some_method
	end

  end
end
```

#### Data mapper

When getting data from an API, we use data mappers that give us access to the query string parameters allowing us to construct the correct API path.

An example of a mapper for an example component would be:

> components/my_test_component/mapper.rb

```ruby
class MyTestComponentMapper < Alephant::Publisher::Request::DataMapper
  def data
    #we have a variable 'context' available that gives us access to the query string params passed to the request.
    #There's a 'get' method available that is passed the constructed API uri and will return the parsed JSON data.
    get "/some/endpoint/#{context['qs_param']}"

  end
end
```

### Application

> config.ru

```ruby
require 'lib/application'
run Application.create
```

> lib/application.rb

```ruby
module Application

  def self.create
    Alephant::Publisher::Request.create(processor, data_mapper_factory)
  end

  def self.processor
    Alephant::Publisher::Request::Processor.new(base_path)
  end

  def self.base_path
    File.absolute_path(File.join(File.dirname(__FILE__), '..', 'components'))
  end

  def self.data_mapper_factory
    Alephant::Publisher::Request::DataMapperFactory.new(connection, base_path)
  end

  def self.connection
    Faraday.new(:url => 'http://www.some-api-endpoint.com')
  end

end
```

## Usage

The server is a simple rack server, so you just need to run:

```bash
rackup
```

in the `src` directory where the `config.ru` file is.

To view components, use the name (the name of the component in the components folder) and any params in the browser:

```bash
curl http://localhost:9292/my_test_component?some=param
```

## Preview Server

`alephant preview`

The included preview server allows you to see the html generated by your
templates, both standalone and in the context of a page.

**Standalone**

`/component/:id/?:fixture?`

### Full page preview

When viewing the component in the context of a page, you'll need to retrieve a
mustache template to provide the page context.

When performing an update a regex is applied to replace the static hostnames in
the retrieved html.

**Environment Variables**

```sh
STATIC_HOST_REGEX="static.(sandbox.dev|int|test|stage|live).yourapp(i)?.com\/"
PREVIEW_TEMPLATE_URL="http://yourapp.com/template"
```

**Example Remote Template**

`id` is the component/folder name

`template` is the mustache template file name

`location_in_page` should be something like (for example) `page_head` (specified within a `preview.mustache` file that the consuming application needs to create).

- `http://localhost:4567/component/id/template`
- `http://localhost:4567/preview/id/template/location_in_page`

`alephant update`

**In page**

`/preview/:id/:region/?:fixture?`

## Contributing

1. [Fork it!](http://github.com/BBC-News/alephant-publisher-request/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/BBC-News/alephant-publisher-request/pulls).

Feel free to create an [issue](https://github.com/BBC-News/alephant-publisher-request/issues/new) if you find a bug.
