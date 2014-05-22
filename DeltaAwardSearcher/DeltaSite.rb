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

  def getTSession_Cal(response)
    if response.body =~ /(?m)tSession_Cal=\K\w*/
      return checksum = $&
    end

    raise 'tSession_Cal not found'
  end

  #
  # Gets the authentication token
  #
  def getCohrAwdSessID(response)

    all_cookies = response.get_fields('set-cookie')
    all_cookies.each { |c| if (c.include? 'cohrAwdSessID')
        return c.split('=')[1] end }

    raise 'cohrAwdSessID not found'
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
    #    oneWayOrRTR=oneway&dispatchMethod=processHomeRTR&deptCity[0]=DTW&returnCity[0]=GRU&deptMonth[0]=6&deptDay[0]=16&deptTime[0]=12M&noPax=1&cabin=Coach&medallionTraveler=0&awardshowMUUpgrade=on&awardMUUpgrade=on&displayPreferredOnly=0&calendarSearch=true&pricingSearch=true&directServiceOnly=off&hiddenFieldsId=&recentSearchBAU=BAU
  end

  def getTS(cohrAwdSessID, hiddenFieldsId, checksum, tSession_Cal)
    uriString = 'http://www.delta.com/awards/wait.do;cohrAwdSessID=' + cohrAwdSessID

    paramsGet = {:hiddenFieldsId => hiddenFieldsId,
      :checksum => checksum,
      :tSession => 'null',
      :tSession_1DS => 'null',
      :tSession_Cal => tSession_Cal,
      :pricingSearch => 'true',
      :dispatchMethod => 'processHomeRTR',
      :poll => '1',
      :reqType => 'ajax' }

    uri = URI.parse( uriString );

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.path)
    request.set_form_data( paramsGet )

    # instantiate a new Request object
    request = Net::HTTP::Get.new( uri.path+ '?' + request.body )

    response = http.request(request)

    if response.body =~ /(?m)ts=\K\d*/
      return checksum = $&
    end

    raise 'ts not found'

    # expected response
    # /awards/selectFlights.do;cohrAwdSessID=jbreW9yA8R0xh9b?EventId=VIEW_CALENDAR&hiddenFieldsId=jbreW9yA8R0xh9b&dispatchMethod=processHomeRTR&checksum=1611650547*42&tSession=null&UIStatus=F&tSession_Cal=DeptNLI8261138&tSession_1DS=null&pricingSearch=true&ts=1400532554086#top
  end

  def getJs_Ts
    return DateTime.now.strftime('%Q')
  end

  # Extract and returns the checksum field
  def getCheckSum(response)
    if response.body =~ /(?m)checksum=\K\d*\*\d*/
      return checksum = $&
    end

    raise 'cohrAwdSessID not found'
  end

  def getHiddenFieldsId
    uriAddress = 'http://www.delta.com/awards/selectFlights.do?dispatchMethod=processHomeRTR&EventId=PROCESS_HOME_RTR'
    uri = URI.parse(uriAddress)

    # Full control
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)

    response = http.request(request)

    doc = Nokogiri::HTML(response.body)

    return doc.css('input#hiddenFieldsId')[0]['value']
  end

  
def requestSearchFlights(origim, destination, day, month, businessClass=true)
  begin
    requestSearch(origim, destination, day, month, businessClass)
  rescue
    puts "Trying again..."
    requestSearch(origim, destination, day, month, businessClass)
  end
end

  #
  # The search is done here. The results are read in another request.
  #
  def requestSearch(origim, destination, day, month, businessClass=true)
    uriAddress = 'http://www.delta.com/awards/selectFlights.do?dispatchMethod=processHomeRTR&EventId=PROCESS_HOME_RTR'
    if (businessClass)
      cabin = 'First'
    else
      cabin = 'Coach'
    end
    
    params = {
      "oneWayOrRTR" => "oneway",
      "dispatchMethod" => "processHomeRTR",
      "deptCity[0]" => origim,
      "returnCity[0]" => destination,
      "deptMonth[0]" => month-1,
      "deptDay[0]" => day,
      "deptTime[0]" => "12M",
      "noPax" => "1",
      "cabin" => cabin,
      "medallionTraveler" => "0",
      "awardshowMUUpgrade" => "on",
      "awardMUUpgrade" =>  "on",
      "displayPreferredOnly" => "0",
      "calendarSearch" =>  "true",
      "pricingSearch" => "true",
      "directServiceOnly" => "off",
      "hiddenFieldsId" =>  "",
      "recentSearchBAU" => "BAU"
    }
    
    puts "Searching %s-%s on %s/%s - %s" % [origim, destination, day, month, cabin]

    uri = URI.parse(uriAddress)

    # Full control
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)

    response = http.request(request)

    # cohrAwdSessID = getCohrAwdSessID(response)
    hiddenFieldsId= getHiddenFieldsId()
    cohrAwdSessID = hiddenFieldsId;
    tSession_Cal = getTSession_Cal(response)
    checksum = getCheckSum(response)

    ts = getTS(cohrAwdSessID, hiddenFieldsId, checksum, tSession_Cal)
    
    gerCalendarResuls( hiddenFieldsId, checksum, tSession_Cal, ts, getJs_Ts(), cohrAwdSessID)
  end

  def get
    # http://www.delta.com/awards/selectFlights.do;cohrAwdSessID=jbreW9yA8R0xh9b?EventId=VIEW_CALENDAR&hiddenFieldsId=jbreW9yA8R0xh9b&dispatchMethod=processHomeRTR&checksum=1611650547*42&tSession=null&UIStatus=F&tSession_Cal=DeptNLI8261138&tSession_1DS=null&pricingSearch=true&ts=1400532554086&js_ts=1400532526891
  end

  #
  # Load final results
  #
  def gerCalendarResuls(hiddenFieldsId, checksum, tSession_Cal, ts, js_ts, cohrAwdSessID)
    paramsGet = {
      :EventId => 'VIEW_CALENDAR',
      :hiddenFieldsId => hiddenFieldsId,
      :dispatchMethod => 'processHomeRTR',
      :checksum => checksum,
      :tSession => 'null',
      :UIStatus => 'F',
      :tSession_Cal => tSession_Cal,
      :tSession_1DS => 'null',
      :pricingSearch => 'true',
      :ts => ts,
      :js_ts => js_ts
    }

    uri = URI.parse( "http://www.delta.com/awards/selectFlights.do;cohrAwdSessID=" + cohrAwdSessID);

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.path)
    request.set_form_data( paramsGet )

    # instantiate a new Request object
    request = Net::HTTP::Get.new( uri.path+ '?' + request.body )

    response = http.request(request)
    
    extractLowFare(response)
  end

  def extractLowFare(response)
    response.body.each_line do |line|
      fareMatch =  /<span id="cal_\d+_day_\d+_\d+_(?<day>\d*)(?<month>\w\w\w)_.+" class="mileageLevel">(?<fare>Low)<\/span>/m.match(line)
      if (!fareMatch.nil?)
        puts fareMatch['day'] +  fareMatch['month']
      end
    end
  end

end

DeltaSite.new().requestSearchFlights("GRU", "DTW", 7, 7)
DeltaSite.new().requestSearchFlights("GRU", "ATL", 7, 7)
DeltaSite.new().requestSearchFlights("GRU", "JFK", 7, 7)
DeltaSite.new().requestSearchFlights("GIG", "ATL", 7, 7)
DeltaSite.new().requestSearchFlights("BSB", "ATL", 7, 7)
DeltaSite.new().requestSearchFlights("DTW", "SFO", 7, 7)
DeltaSite.new().requestSearchFlights("GRU", "DTW", 7, 7, false)
DeltaSite.new().requestSearchFlights("GRU", "ATL", 7, 7, false)
DeltaSite.new().requestSearchFlights("GRU", "JFK", 7, 7, false)
DeltaSite.new().requestSearchFlights("GIG", "ATL", 7, 7, false)
DeltaSite.new().requestSearchFlights("BSB", "ATL", 7, 7, false)

DeltaSite.new().requestSearchFlights("DTW", "SFO", 7, 7, false)
DeltaSite.new().requestSearchFlights("DTW", "LAX", 7, 7, false)
DeltaSite.new().requestSearchFlights("DTW", "LAS", 7, 7, false)

DeltaSite.new().requestSearchFlights("ATL", "SFO", 7, 7, false)
DeltaSite.new().requestSearchFlights("ATL", "LAX", 7, 7, false)
DeltaSite.new().requestSearchFlights("ATL", "LAS", 7, 7, false)

DeltaSite.new().requestSearchFlights("SFO", "JFK", 7, 7, false)
DeltaSite.new().requestSearchFlights("LAX", "JFK", 7, 7, false)
DeltaSite.new().requestSearchFlights("LAS", "JFK", 7, 7, false)

DeltaSite.new().requestSearchFlights("GRU", "YUL", 7, 7)
DeltaSite.new().requestSearchFlights("GRU", "YUL", 7, 7, false)





def search(origins, destinations, day, month)
  # ["gru"], ["ATL, JFK", "DTW"]
end