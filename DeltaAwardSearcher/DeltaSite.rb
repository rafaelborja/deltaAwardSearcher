require "net/http"
require "uri"
require 'open-uri'
require 'nokogiri'

# Connects to delta Site
# Install gems
#   gem install nokogiri
class DeltaSite
  def initialize()
  end

  #
  # Gets the authentication token
  #
  def getCohrAwdSessID
    uriAddress = 'http://www.delta.com/awards/selectFlights.do?dispatchMethod=processHomeRTR&EventId=PROCESS_HOME_RTR'
    params = {
      'oneWayOrRTR' => 'oneway',
      'dispatchMethod' => 'processHomeRTR',
      'deptCity%5B0%5D' => 'DTW',
      'returnCity%5B0%5D' => 'gru',
      'deptMonth%5B0%5D' => '5',
      'deptDay%5B0%5D' => '12',
      'deptTime%5B0%5D' => '12M',
      'noPax' => '1',
      'cabin' => 'First',
      'medallionTraveler' => '0',
      'awardshowMUUpgrade' => 'on',
      'awardMUUpgrade' => 'on',
      'displayPreferredOnly' => '0',
      'calendarSearch' => 'true',
      'pricingSearch' => 'true',
      'directServiceOnly' => 'off',
      'hiddenFieldsId' => '',
      'recentSearchBAU' => 'BAU'
    }

    uri = URI.parse(uriAddress)

    # Full control
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)

    response = http.request(request)

    all_cookies = response.get_fields('set-cookie')
    all_cookies.each { |c| if (c.include? 'cohrAwdSessID')
        return c.split('=')[1] end }

    raise 'cohrAwdSessID not found'
  end

  def test
    uriAddress = 'http://www.delta.com/awards/selectFlights.do?dispatchMethod=processHomeRTR&EventId=PROCESS_HOME_RTR'
    params = {
      'oneWayOrRTR' => 'oneway',
      'dispatchMethod' => 'processHomeRTR',
      'deptCity%5B0%5D' => 'GRU',
      'returnCity%5B0%5D' => 'DTW',
      'deptMonth%5B0%5D' => '5',
      'deptDay%5B0%5D' => '16',
      'deptTime%5B0%5D' => '12M',
      'noPax' => '1',
      'cabin' => 'First',
      'medallionTraveler' => '0',
      'awardshowMUUpgrade' => 'on',
      'awardMUUpgrade' => 'on',
      'displayPreferredOnly' => '0',
      'calendarSearch' => 'true',
      'pricingSearch' => 'true',
      'directServiceOnly' => 'off',
      'hiddenFieldsId' => '',
      'recentSearchBAU' => 'BAU'
    }

    uri = URI.parse(uriAddress)

    # Full control
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)

    response = http.request(request)

    File.open('deltaSearchRequest.html', 'w') { |file| file.write( response.body) }
  end

  def loadCalendar

    #    query
    #    http://www.delta.com/awards/selectFlights.do;cohrAwdSessID=a0kueQZn52BbdYK?EventId=VIEW_CALENDAR&hiddenFieldsId=a0kueQZn52BbdYK&dispatchMethod=processHomeRTR&checksum=1340569586*120&tSession=null&UIStatus=F&tSession_Cal=DeptNLI1118000&tSession_1DS=null&pricingSearch=true&ts=1399735734644&js_ts=1399735712540#jump

    #
    #    Querry string
    #    EventId=VIEW_CALENDAR
    #    hiddenFieldsId=a0kueQZn52BbdYK
    #    dispatchMethod=processHomeRTR
    #    checksum=1340569586*120
    #    tSession=null
    #    UIStatus=F
    #    tSession_Cal=DeptNLI1118000
    #    tSession_1DS=null
    #    pricingSearch=true
    #    ts=1399735734644
    #    js_ts=1399735712540

    #    Body request
    #    oneWayOrRTR=oneway&dispatchMethod=processHomeRTR&deptCity%5B0%5D=DTW&returnCity%5B0%5D=GRU&deptMonth%5B0%5D=6&deptDay%5B0%5D=16&deptTime%5B0%5D=12M&noPax=1&cabin=Coach&medallionTraveler=0&awardshowMUUpgrade=on&awardMUUpgrade=on&displayPreferredOnly=0&calendarSearch=true&pricingSearch=true&directServiceOnly=off&hiddenFieldsId=&recentSearchBAU=BAU
  end

  def getHiddenFieldsId(responseBody)

    
    
    uriAddress = 'http://www.delta.com/awards/selectFlights.do?dispatchMethod=processHomeRTR&EventId=PROCESS_HOME_RTR'
    uri = URI.parse(uriAddress)

    # Full control
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)

    response = http.request(request)
    
    

    doc = Nokogiri::HTML(responseBody.body)
    
    puts response.body
    
    return doc.css('input#hiddenFieldsId')[0]['value']
  end

end

puts DeltaSite.new().getHiddenFieldsId;