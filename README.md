# Rubyvernac::Marathi


The idea was to enable writing Ruby in various spoken languages. 

I see two benefits to be able to write programmes in mother tongue -

- Those who don't know English, learning programming to understand how computers work would be easier, rather than just mugging English keywords.

- Those who already do programming professionally, but do not have English as their mother tongue, can find writing programming in mother tongue a good exercise to rethink about programming concepts.


## Installation

Add this line to your application's Gemfile:

    gem 'rubyvernac-marathi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem build rubyvernac-marathi.gemspec
    $ sudo gem install rubyvernac-marathi-0.0.1.gem

## Usage

Install Go 1.4 or later - https://golang.org/doc/install
Install keyword-parser package.

    $ go get github.com/RainingClouds/keyword-parser

Run any example code using - 

    $ keyword-parser examples/{file.rb} ruby lib/tranlsations/keywords.txt  

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rubyvernac-marathi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
