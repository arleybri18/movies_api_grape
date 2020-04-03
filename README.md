## Booking Movies API

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating, and use [sequel](https://github.com/jeremyevans/sequel) like a database toolkit including ORM. 


## Usage

All following commands can and should be adapted/replaced to your needs.

- [Requirements](#requirements)
- [Clone](#clone)
- [Setup](#setup)
- [Test](#test)
- [Run](#run)

#### `Requirements`
For use this API you need install:

- Ruby 2.6.5, install from [ruby-page](https://www.ruby-lang.org/en/downloads/) and confirm using:
```
$ ruby --version
```
- Bundler, [oficial-page](https://bundler.io/)

```
$ gem install bundler
```

#### `Clone`
Clone this repository on your machine using the following command:

```
$ git clone https://github.com/arleybri18/movies_api_grape.git
```

#### `Setup`
Execute the following command to install all dependencies of the project and run migrations:

```
$ cd movies_api_grape
$ bundle install
$ rake db:migrate
```

#### `Test`
For execute the automation test use:
```
$ bundle exec rspec
```

#### `Run`
Execute the command for running on default port 9292

```
$ rackup
```
and go to: [http://localhost:9292/api/v1/swagger_doc](http://localhost:9292/api/v1/swagger_doc)
to access the API endpoints documentation.

For production, set `RACK_ENV=production`
```
$ RACK_ENV=production
$ rackup
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/name/arleybri18.
