require "net/http"
require "uri"
require 'open-uri'

# Connects to delta Site
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
end