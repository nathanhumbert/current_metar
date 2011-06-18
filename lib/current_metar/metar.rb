class CurrentMetar::Metar
  require 'rexml/document'
  attr_accessor :wind_speed, :wind_direction, :wind_gust_speed, :observation_time, :visibility, :temperature, :available, :no_results
  attr_reader :icao

  METAR_ATTRIBUTE_MAPPING = { 
    :wind_speed => "wind_speed_kt",                                                                                  
    :wind_direction => "wind_dir_degrees",                                                                           
    :wind_gust_speed => "wind_gust_kt",                                                                              
    :visibility => "visibility_statute_mi"                                                                           
  } 

  def initialize(icao)
    @icao = icao
  end

  def self.get_metar(icao)
    
    metar = CurrentMetar::Metar.new(icao) 
    begin
      metar_response_body  = REXML::Document.new(CurrentMetar::Request.query_adds(metar.icao)) 
      if metar_response_body.root.elements['data'].attributes.get_attribute('num_results').value == '0'
        metar.available = false 
        metar.no_results = true
      else
        metar_response_body.root.elements.each("data/METAR") do |metar_xml|
          unless metar_xml.elements['temp_c'].nil?
            metar.temperature = (9/5.0 * metar_xml.elements['temp_c'].text.to_i + 32).round
          end
          metar.parse_standard_attributes(metar_xml)
        end
        metar.available = true
        metar.no_results = false
      end
    rescue
      metar.available = false 
      metar.no_results = false
    ensure
      return metar
    end
  end

  def parse_standard_attributes(metar_xml)                                                                          
    METAR_ATTRIBUTE_MAPPING.each do |key, value|
      unless metar_xml.elements[value].nil?  
        self.send( "#{key}=", metar_xml.elements[value].text)                                                       
      end                                                                                                              
    end
  end 
      
end
