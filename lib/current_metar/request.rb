class CurrentMetar::Request
  require 'net/http'
  require 'uri'
  require 'rexml/document'

  def self.query_adds(icao)
    url = URI.parse("http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=#{icao}")
    request = Net::HTTP.start(url.host, url.port) do |http|
      http.get(url.path + "?" + url.query)
    end
    return request.body
  end

end
