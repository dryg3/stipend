#!/usr/bin/env ruby

require "xmlrpc/client"
task :newbase => :environment do
begin

  client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
  client.timeout = 600

# scholarship.groups_list(study_year, term)
# term: 1-осень, 2-весна
# output format: [group_id, group_name, term, kurs, faculty_id, faculty_short_name, faculty_name]

   result = client.call("scholarship.groups_list", '2013/2014', '2')

#==========faculty
  # faculty=[]
  # for i in 0...result.size
  #   faculty<<[result[i][4],result[i][5],result[i][6]]
  # end
  # #p  faculty.uniq!
  # faculty.uniq!
  #
  # faculty.each  do |faculty|
  #     f=Faculty.new(old_id:faculty[0],short_name:faculty[1],name:faculty[2])
  #     p f.name
  #     if (old=Faculty.find_by(old_id:faculty[0])).nil?
  #       p f
  #        f.save!
  #     else
  #        p old
  #       old.old_id = f.old_id
  #       old.short_name=f.short_name
  #       old.name=f.name
  #        old.save!
  #     end
  # end

 # p result

#=================group

  # for i in 0...result.size
  #    r=result[i]
  #
  #    if Faculty.find_by(old_id:r[4]).id==7
  #
  #       g=Group.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015")
  #
  #       if (old=Group.find_by(old_id:r[0])).nil?
  #         p g
  #         #p g.name.size
  #         g.save!
  #       else
  #         # p old
  #         old.old_id = g.old_id
  #         old.name=g.name
  #         old.semester=g.semester
  #         old.kurs=g.kurs
  #         old.faculty_id=g.faculty_id
  #         old.year=g.year
  #          p old
  #         #old.save!
  #       end
  #    end
  # end


#   old=Group.find_by(id:271)
#   result = client.call("scholarship.students_list", "#{old.old_id}")
# r1=result[0][1]
#    p r1
# scholarship.students_list(group_id)
# output format: [student_id, surname, name, pathname, type_learn, category]


=begin
  group=[]
  for i in 0...result.size
    r=result[i]
    if Faculty.find_by(old_id:r[4]).id==3
    group<<result[i][0]
     end
  end
  #p  faculty.uniq!
  group.uniq!
  p group
  group.each do |group_id|
    p group_id
    # group_id=14169
    result = client.call("scholarship.students_list_without_marks", "#{group_id}")
    # p ">>>>>>>>>"
    p result
    for i in 0...result.size
       r=result[i][0]
       r1=result[i][1]
       s=Student.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3])
      sg=StudentGroup.new(group_id: Group.find_by(old_id:group_id).id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend:(r1=="другой")? 0 :( (r1=="хорошист") ? 1 : 2))
       p s
       p sg
       if (old=Student.find_by(old_id:r[0])).nil?
        # s.save!
         sg.student_id=s.id
       else
         old.old_id = s.old_id
         old.surname=s.surname
         old.firstname=s.firstname
         old.secondname=s.secondname
         #old.save!
         sg.student_id=old.id
       end

        # if (old=StudentGroup.find_by(group_id:sg.group_id,student_id:sg.student_id)).nil?
        #   p sg
        #  # sg.save!
        #   p sg
        # else
        #   old.group_id=sg.group_id
        #   old.student_id=sg.student_id
        #   old.commerce=sg.commerce
        #   old.type_stipend=sg.type_stipend
        #   p old
        #  # old.save!
        #   p old
        # end
        # p sg
    end
  end
=end

  result = client.call("scholarship.students_list", "14401")
  p result

#===========student student_group
  group=[]
  for i in 0...result.size
    r=result[i]
    if Faculty.find_by(old_id:r[4]).id==7
      group<<result[i][0]
    end
  end
  #p  faculty.uniq!
  group.uniq!
  p group
  # group.each do |group_id|
  #   p group_id
  #   # group_id=14169
  #   result = client.call("scholarship.students_list", "#{group_id}")
  #   # p ">>>>>>>>>"
  #   p result
  #   for i in 0...result.size
  #     r=result[i][0]
  #     r1=result[i][1]
  #     s=Student.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3])
  #     sg=StudentGroup.new(group_id: Group.find_by(old_id:group_id).id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend:(r1=="другой")? 0 :( (r1=="хорошист") ? 1 : 2))
  #     p s
  #     p sg
  #     if (old=Student.find_by(old_id:r[0])).nil?
  #        # s.save!
  #       sg.student_id=s.id
  #     else
  #       old.old_id = s.old_id
  #       old.surname=s.surname
  #       old.firstname=s.firstname
  #       old.secondname=s.secondname
  #       # old.save!
  #       sg.student_id=old.id
  #     end
  #
  #     if (old=StudentGroup.find_by(group_id:sg.group_id,student_id:sg.student_id)).nil?
  #       p sg
  #      # sg.save!
  #       p sg
  #     else
  #       old.group_id=sg.group_id
  #       old.student_id=sg.student_id
  #       old.commerce=sg.commerce
  #       old.type_stipend=sg.type_stipend
  #       p old
  #      # old.save!
  #       p old
  #     end
  #     p sg
  #   end
  # end

rescue XMLRPC::FaultException => e
  puts "Error:"
  puts e.faultCode
  puts e.faultString
  end
end