#!/usr/bin/env ruby

require "xmlrpc/client"

begin

client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
client.timeout = 600

# scholarship.groups_list(study_year, term)
# term: 1-осень, 2-весна
# output format: [group_id, group_name, term, kurs, faculty_id, faculty_short_name, faculty_name]

result = client.call("scholarship.groups_list", '2013/2014', '1')
puts result

# scholarship.students_list(group_id)
# output format: [student_id, surname, name, pathname, type_learn, category]

#result = client.call("scholarship.students_list", '14169')
#puts result

rescue XMLRPC::FaultException => e
puts "Error:"
puts e.faultCode
puts e.faultString
end
