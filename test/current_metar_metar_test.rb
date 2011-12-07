require 'test/unit'
require 'current_metar'
require 'fakeweb'

class CurrentMetarMetarTest < Test::Unit::TestCase

  def setup
    @body = IO.read(File.join('test', 'fixtures', 'KSEA_example.xml'))
  end

  def setup_get_metar
    setup
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KSEA', :body => @body )
    @metar = CurrentMetar::Metar.get_metar('KSEA')
  end

  def setup_no_results
    @body = IO.read(File.join('test', 'fixtures', 'KCZQ_example.xml'))
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KCZQ', :body => @body )
    @metar = CurrentMetar::Metar.get_metar('KCZQ')
  end

  def test_no_results_metar_unavailable
    setup_no_results
    assert_equal false, @metar.available
  end

  def test_no_results_true
    setup_no_results
    assert_equal true, @metar.no_results
  end

  def test_get_metar
    setup_get_metar
    available_assertions
  end

  def test_new_from_xml
    document = REXML::Document.new(@body)
    @metar = CurrentMetar::Metar.new_from_xml(document.root.elements['data/METAR'])
    available_assertions
  end

  def available_assertions
    assert_equal 45.0, @metar.temperature
    assert_equal '110', @metar.wind_direction
    assert_equal '12', @metar.wind_speed
    assert_equal nil, @metar.wind_gust_speed
    assert_equal true, @metar.available
    assert_equal false, @metar.no_results
    assert_equal 'KSEA', @metar.icao
  end

  def test_get_metar_unavailable
    FakeWeb.register_uri(:get, 'http://weather.aero/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=true&stationString=KSEA', :body => 'error', :status => ['404', 'Not Found'] )
    metar = CurrentMetar::Metar.get_metar('KSEA')
    assert_equal false, metar.available
  end
end
