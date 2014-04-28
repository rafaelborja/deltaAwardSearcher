require "net/http"
require "uri"

uri = URI.parse("http://www.delta.com/awards/dwr/call/plaincall/AwardsScreenProcessor.getCalendar.dwr")

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

# Shortcut
response = Net::HTTP.post_form(uri, params)

# Full control
http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data(params)

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