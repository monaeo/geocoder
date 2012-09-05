require 'geocoder/lookups/base'
require "geocoder/results/geonames"

module Geocoder::Lookup
  class Geonames < Base
    private
    def results(query, reverse = false)
      return [] unless doc = fetch_data(query, reverse)

      if doc['postalCodes'] && !doc['postalCodes'].empty?
        #returns the array of hashes from which each Result instance 
        #will be created
        doc['postalCodes']
      else
        raise_error(Geocoder::NoResultsError) ||
          warn("No results were found")
        []
      end
    end

    def query_url(query, reverse = false)
      lat, lng = query.is_a?(Array) ? query : query.split(/\,s*/)
      "http://api.geonames.org/findNearbyPostalCodesJSON?maxRows=1&lat=#{lat}&lng=#{lng}&username=#{Geocoder::Configuration.get_api_key(:geonames)}"
    end
  end
end
