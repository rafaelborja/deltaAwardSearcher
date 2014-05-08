require "net/http"
require "uri"
require 'open-uri'
require 'DeltaSite'

# uri = URI.parse("http://www.delta.com/awards/dwr/call/plaincall/AwardsScreenProcessor.getCalendar.dwr")

params = {
  "callCount"  => "1",
  "page" => "/awards/selectFlights.do?EventId=VIEW_CALENDAR&hiddenFieldsId=lopIR49ojV4Ao5T&dispatchMethod=processHomeRTR&checksum=1373325507*109&tSession=null&UIStatus=F&tSession_Cal=DeptNLI3609280&tSession_1DS=null&pricingSearch=true&ts=1398737906693&js_ts=1398727138008",
  "httpSessionId"  => "0000mXjHPYy8PCMA9yqFMWxUNrV:-1",
  "scriptSessionId"  => "37507890165F8A24645AE380832DEEB2391",
  "c0-scriptName"  => "AwardsScreenProcessor",
  "c0-methodName"  => "getCalendar",
  "c0-id"  => "0",
  "c0-param0"  => "boolean:false",
  "c0-param1"  => "string:",
  "c0-param2"  => "string:DeptNLI3004411",
  "c0-param3"  => "boolean:false",
  "c0-param4"  => "string:GRU",
  "c0-param5"  => "string:DTW",
  "c0-param6"  => "string:24",
  "c0-param7"  => "string:Jun",
  "c0-param8"  => "string:1",
  "c0-param9"  => "string:Coach",
  "c0-param10"  => "string:Outbound",
  "batchId"  => "3"
}

paramsGet = {:EventId => 'VIEW_CALENDAR',
  :hiddenFieldsId => 'KdL3vjvOOLe6KBx',
  :dispatchMethod => 'processHomeRTR',
  :checksum => '1660819092*49',
  :tSession => 'null',
  :UIStatus => 'F',
  :tSession_Cal => 'DeptNLI6301614',
  :tSession_1DS => 'null',
  :pricingSearch => 'true',
  :ts => '1399580594852',
  :js_ts => '1399580572983' }

# Gets the sessionID
d = DeltaSite.new()
cohrAwdSessID =  d.getCohrAwdSessID()

uri = URI.parse( "http://www.delta.com/awards/selectFlights.do;cohrAwdSessID=" + cohrAwdSessID);

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.path)
request.set_form_data( paramsGet )

# instantiate a new Request object
request = Net::HTTP::Get.new( uri.path+ '?' + request.body )

response = http.request(request)
responsePage =  response.body

File.open('delta.html', 'w') { |file| file.write(responsePage) }

uri = URI.parse('')
# Add params to URI
uri.query = URI.encode_www_form( paramsGet )
# Shortcut

puts Net::HTTP.get(uri)

# response = Net::HTTP.get('http://www.delta.coSm/awards/selectFlights.do;cohrAwdSessID=CuLXkSf0uPhaBRg?EventId=VIEW_CALENDAR&hiddenFieldsId=CuLXkSf0uPhaBRg&dispatchMethod=processHomeRTR&checksum=1577656521*127&tSession=null&UIStatus=F&tSession_Cal=DeptNLI1945970&tSession_1DS=null&pricingSearch=true&ts=1399578818171&js_ts=1399578796335#jump')

#all_cookies = esponse.get_fields('set-cookie')
#puts all_cookies;
#puts '###'

# class="lw_active" id="cal_0_day_0_2_03Jun_d"
# class="md_active" id="cal_0_day_0_2_03Jun_d"

# Full control
#http = Net::HTTP.new(uri.host, uri.port)
#
#request = Net::HTTP::Post.new(uri.request_uri)
#request.set_form_data(params)

response = http.request(request)

puts response.body

#require 'net/http'
#
#require 'uri'
#
#uri = URI("http://delta.com")
#https = Net::HTTP.new(uri.host, uri.port)
#https.use_ssl = false
#
#request = Net::HTTP::Post.new(uri.path)
#
#request["HEADER1"] = 'VALUE1'
#request["HEADER2"] = 'VALUE2'
#
#response = https.request(request)
#puts response

#callCount=1
#page=/awards/selectFlights.do?EventId=VIEW_CALENDAR&hiddenFieldsId=lopIR49ojV4Ao5T&dispatchMethod=processHomeRTR&checksum=2088917077*37&tSession=null&UIStatus=F&tSession_Cal=DeptNLI3004411&tSession_1DS=null&pricingSearch=true&ts=1398736404015&js_ts=1398725635338
#httpSessionId=0000mXjHPYy8PCMA9yqFMWxUNrV:-1
#scriptSessionId=37507890165F8A24645AE380832DEEB2944
#c0-scriptName=AwardsScreenProcessor
#c0-methodName=getCalendar
#c0-id=0
#c0-param0=boolean:false
#c0-param1=string:
#c0-param2=string:DeptNLI3004411
#c0-param3=boolean:false
#c0-param4=string:GRU
#c0-param5=string:DTW
#c0-param6=string:24
#c0-param7=string:Jun
#c0-param8=string:1
#c0-param9=string:Coach
#c0-param10=string:Outbound
#batchId=3

#source = Net::HTTP.get('www.delta.com', '/awards/dwr/call/plaincall/AwardsScreenProcessor.getCalendar.dwr')

# puts source