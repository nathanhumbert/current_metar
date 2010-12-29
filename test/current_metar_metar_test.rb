require 'test/unit'
require 'current_metar'
require 'current_metar/request'
require 'current_metar/metar'
require 'fakeweb'

class CurrentMetarMetarTest < Test::Unit::TestCase

  def setup 
    @body = IO.read(File.join('test', 'fixtures', 'KSEA_example.xml'))
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KSEA', :body => @body )
    @metar = CurrentMetar::Metar.get_metar('KSEA')
  end

  def test_get_metar_sets_temperature
    setup
    assert_equal 45.0, @metar.temperature
  end

  def test_get_metar_sets_wind_direction
    setup
    assert_equal '110', @metar.wind_direction
  end

  def test_get_metar_sets_wind_speed
    setup
    assert_equal '12', @metar.wind_speed
  end

  def test_get_metar_does_not_set_wind_gust_speed
    setup
    assert_equal nil, @metar.wind_gust_speed
  end

  def test_get_metar_available
    setup
    assert_equal true, @metar.available
  end

  def test_get_metar_unavailable
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KSEA', :body => 'error', :status => ['404', 'Not Found'] )
    metar = CurrentMetar::Metar.get_metar('KSEA')
    assert_equal false, metar.available
  end
end
