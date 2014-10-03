#!/usr/bin/env ruby

require "xmlrpc/client"
task :b => :environment do
begin

  client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
  client.timeout = 600
  result2 = client.call("scholarship.groups_list", '2013/2014', '2')
result = client.call("scholarship.students_list", "14217","01.07.2014")
  p result2
  p result
end
end


