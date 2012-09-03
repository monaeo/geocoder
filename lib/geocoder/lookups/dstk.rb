require 'geocoder/lookups/base'
require "geocoder/results/dstk"

module Geocoder::Lookup
  class Dstk < Base
    private
    def results(query, reverse = false)
      return [] unless doc = fetch_data(query, reverse)
      doc
    end

    def query_url(query, reverse = false)
      lat, lng = query
      host = if Geocoder::Configuration.self_hosted 
               Geocoder::Configuration.geocoding_server
             else
               "http://www.datasciencetoolkit.org"
             end
      "#{host}/coordinates2politics/#{lat},#{lng}"
    end
  end
end
