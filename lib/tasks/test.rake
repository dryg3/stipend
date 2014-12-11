#!/usr/bin/env ruby
require "xmlrpc/client"
task :b => :environment do
begin

  client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
  client.timeout = 600

# scholarship.groups_list(study_year, term)
# term: 1-осень, 2-весна
# output format: [group_id, group_name, term, kurs, faculty_id, faculty_short_name, faculty_name]

# scholarship.students_list(group_id)
# output format: [[student_id, surname, name, pathname, type_learn, category],оценка]
#["263347", "Дудкин", "Константин", "Евгеньевич", "коммерческий", "обучается"], "другой"]
# date=Date.today.strftime("%d.%m.%Y").to_s
    date="18.11.2014"
    faculty=10
    result = client.call("scholarship.groups_list", '2014/2015', '1')
    result2 = client.call("scholarship.groups_list", '2013/2014', '2')
    group=[]


    p "\n=================group=================\n"
    for i in 0...result.size
      r=result[i]
      if Faculty.find_by(old_id:r[4]).id==faculty
        g=Group.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015")
        if (old=Group.find_by(old_id:r[0])).nil?
          p "new"
          p g
          #g.save!
        else
          old.name=g.name
          old.semester=g.semester
          old.kurs=g.kurs
          old.faculty_id=g.faculty_id
          old.year=g.year
          p old
          #old.save!
        end
      end
    end

    for i in 0...result.size
      r=result[i]
      if Faculty.find_by(old_id:r[4]).id==faculty
        group<<[r[0],r[1]] #[id,name]
      end
    end
#p  faculty.uniq!
    group.uniq!
# p group

    p "\n=================student=================\n"
    group.each do |id,name|
      result = client.call("scholarship.students_list_without_marks", "#{id}")
      p result
      for i in 0...result.size
        r=result[i]
        s=Student.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3])
        # p s
        if r[5]=="обучается"
          if (old=Student.find_by(old_id:r[0])).nil?
            # s.save!
            p "new"
            p s
          else
            old.surname=s.surname
            old.firstname=s.firstname
            old.secondname=s.secondname
            #old.save!
            p old
          end
        end
      end
    end

    p "\n=================student_group=================\n"

    new=[]
    group.each do |id,name|
      for i in 0...result2.size
        r=result2[i]
        r0= r[0]  if r[1]== name #[id,id_old]
      end
      #p new
      new << [r0,id]
    end
    p new



    new.each do |group_id,id_old|
      p group_id,id_old
      result = client.call("scholarship.students_list", "#{group_id}",date)

      if result.empty?

        result = client.call("scholarship.students_list_without_marks", "#{id_old}")
        p result
        for i in 0...result.size
          r=result[i]
          if r[5]=="обучается"
            s=Student.find_by(old_id: r[0])
            sg=StudentGroup.new(group_id: Group.find_by(old_id: id_old).id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend: 0)
            p s
            sg.student_id=s.id
            p sg
            if (old=StudentGroup.find_by(group_id: sg.group_id, student_id: sg.student_id)).nil?
              #sg.save!
              p "new1"

              p sg
            else
              old.commerce=sg.commerce
              #old.save!
              p "stold===1"
              p old
            end
          else
            unless (s=Student.find_by(old_id: r[0])).nil?
              old=StudentGroup.find_by(group_id: Group.find_by(old_id: id_old).id, student_id: s.id)
              p "del1"
              p old
              #old.delete unless old.nil?
            end

          end
        end

      else
        p result
        p "========="
        for i in 0...result.size
          r=result[i][0]
          r1=result[i][1]
          if r[5]=="обучается"
            s=Student.find_by(old_id: r[0])
            sg=StudentGroup.new(group_id: Group.find_by(old_id: id_old).id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend:(r1=="другой")? 0 :( (r1=="хорошист") ? 1 : 2))
            p s
            sg.student_id=s.id
            p sg
            if (old=StudentGroup.find_by(group_id: sg.group_id, student_id: sg.student_id)).nil?
              #sg.save!
              p "new2"

              p sg
            else
              p old
              old.commerce=sg.commerce
              if old.type_stipend>sg.type_stipend
                p "<<<<"
                old.type_stipend=sg.type_stipend
              elsif old.type_stipend<sg.type_stipend
                p ">>>>"
              end
              #old.save!
              p "stold===2"

            end
          else
            unless (s=Student.find_by(old_id: r[0])).nil?
              old=StudentGroup.find_by(group_id: Group.find_by(old_id: id_old).id, student_id: s.id)
              p "del2"
              p old
              #old.delete unless old.nil?
            end

          end
        end
        result2 = client.call("scholarship.students_list_without_marks", "#{id_old}")
        p "result2"
        for i in 0...result.size
          result[i]=result[i][0]
        end
        result3=result2-result
        p result3
        unless result3.empty?
          for i in 0...result3.size
            r=result3[i]
            if r[5]=="обучается"
              s=Student.find_by(old_id: r[0])
              sg=StudentGroup.new(group_id: Group.find_by(old_id: id_old).id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend: 0)
              p s
              sg.student_id=s.id
              p sg
              if (old=StudentGroup.find_by(group_id: sg.group_id, student_id: sg.student_id)).nil?
                #sg.save!
                p "new3"

                p sg
              else
                old.commerce=sg.commerce
                #old.save!
                p "stold===3"
                p old
              end
            else
              unless (s=Student.find_by(old_id: r[0])).nil?
                old=StudentGroup.find_by(group_id: Group.find_by(old_id: id_old).id, student_id: s.id)
                p "del3"
                p old
                #old.delete unless old.nil?
              end

            end
          end
        end
      end
    end

  rescue XMLRPC::FaultException => e
    puts "Error:"
    puts e.faultCode
    puts e.faultString
  end
end