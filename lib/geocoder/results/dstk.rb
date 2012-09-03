require 'geocoder/results/base'

module Geocoder::Result
  class Dstk < Base
    def coordinates
      ['latitude', 'longitude'].map do |part|
        location[part].to_f
      end
    end

    def address
      type_re = /admin(?<level>\d+)/

      politics.filter do |e|
        type_re =~ e["type"]
      end.sort_by do |e|
        type_re.match(e["type"])["level"]
      end.reverse.map{|admin_component| admin_component["name"] }.join(", ")
    end

    %w[city state country].each do |address_component|
      define_method address_component do
        address_component_by_type address_component
      end
    end

    def address_component_by_type(type)
      politics.find{ |e| e["friendly_type"] == type.to_s  }["name"] rescue nil
    end

    def location
      @data['location']
    end

    def politics
      @data['politics']
    end
  end
end
