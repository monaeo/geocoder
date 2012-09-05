require 'geocoder/results/base'

module Geocoder::Result
  class Geonames < Base
    def coordinates
      %w|lat lng|.map{|p| @data[p]}
    end

    def address
      type_re = /adminName(?<pos>\d+)/

      mid = @data.select do |k, v|
        type_re =~ k
      end.sort_by do |k, v|
        type_re.match(k)["pos"]
      end.reverse.map{|(__, component)| component }

      [
        @data['placeName'],
        mid,
        @data['countryCode']
      ].flatten.compact.join(", ")
    end

    def city
      @data['placeName']
    end

    def state
      @data['adminName1']
    end

    def state_code
      @data['adminCode1']
    end

    def country
      @data['countryCode'].upcase rescue nil
    end
  end
end
