require 'test/unit'
require 'current_metar'
require 'current_metar/request'
require 'fakeweb'

class CurrentMetarRequestTest < Test::Unit::TestCase

  def test_query_adds
    @body = IO.read(File.join('test', 'fixtures', 'KSEA_example.xml'))
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KSEA', :body => @body )
    assert_equal @body,  CurrentMetar::Request.query_adds('KSEA')
  end
end
