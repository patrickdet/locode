# Locode

[![Build Status](https://travis-ci.org/niels-s/locode.png)](https://travis-ci.org/niels-s/locode)

The Locode gem gives you the ability to lookup UN/LOCODE codes. You can read more about the UN/LOCODE specifications here: [wiki](http://en.wikipedia.org/wiki/UN/LOCODE).

All data used by this gem has been taken from the *UN Centre for Trade Facilitation and E-business* official website. **No guarantees for the accuracy or up-to-dateness are given.**

`http://www.unece.org/cefact/locode/welcome.html` and `http://www.unece.org/cefact/codesfortrade/codes_index.html`

## Installation

Add this line to your application's Gemfile:

    gem 'locode'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install locode

## Usage

Find Locations whose full name or full name without diacritics matches the search string

	Locode.find_by_name('Göteborg')
  	#=> [<Locode::Location: 'SE GOT'>]

Find Locations that partially match the Search String. This means you can search by just the country code or a whole LOCODE.

	Locode.find_by_locode('US')
    #=> [<Locode::Location: 'US NYC'>,>
         <Locode::Location: 'US LAX'>, ... ]

You can also retrieve Locode's by the different functions, for example:

	Locode.seaports()
	#=> [<Locode::Location: 'DE HAM'>, ..]

There are a lot of locations so you can also limit the amount of locations returned by passing a amount:

	Locode.inland_clearance_depots(1)
	#=> [<Locode::Location: 'DE HAM'>]

These are the possible function calls:

* seaports(limit)
* rail_terminals(limit)
* road_terminals(limit)
* airport(limit)
* postal_exchange_offices(limit)
* inland_clearance_depots(limit)
* fixed_transport_functions(limit)
* border_crossing_functions(limit)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
