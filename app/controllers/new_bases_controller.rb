class NewBasesController < ApplicationController
  require "xmlrpc/client"
  def group
    unless params[:edit_base].nil?
      params[:edit_base].each{|x| @group[x].save! }
    end
    #raise params.inspect
    faculty=Faculty.includes(:groups=>:faculty)
    groups=faculty.map{|x| x.groups}.flatten

    @group=[]
    begin
      faculty_id=7
      client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
      client.timeout = 600
      result = client.call("scholarship.groups_list", '2014/2015', '1')
      for i in 0...result.size
        r=result[i]
        if faculty.find{|x| x.old_id==r[4].to_i}.id==faculty_id
          g=Group.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015")
          #@group<<[groups.find{|x| x.old_id==r[0].to_i}]
          if (old=groups.find{|x| x.old_id==r[0].to_i}).nil?
            p "new"
            p g
            #g.save!
            @group<<[0,g]
          else
            new_old=old.dup
            old.name=g.name
            old.semester=g.semester
            old.kurs=g.kurs
            old.faculty_id=g.faculty_id
            old.year=g.year
            p old
            #old.save!
            @group<<[1,new_old,old] unless old.name==new_old.name and old.semester==new_old.semester and old.kurs==new_old.kurs and old.faculty_id==new_old.faculty_id and old.year==new_old.year
          end
        end
      end
    end
  end

  def student
    student_all=Student.all
    faculty_all=Faculty.all
    faculty_id=7
    group=[]
    @student=[]
    begin
      client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
      client.timeout = 600
      result = client.call("scholarship.groups_list", '2014/2015', '1')

      for i in 0...result.size
        r=result[i]
        if faculty_all.find{|x| x.old_id==r[4].to_i}.id==faculty_id
          group<<[r[0],r[1]] #[id,name]
        end
      end
      group.uniq!

      group.each do |id,name|
        result = client.call("scholarship.students_list_without_marks", "#{id}")
        p result
        for i in 0...result.size
          r=result[i]
          s=Student.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3])
          # p s
          if r[5]=="обучается"
            if (old=student_all.find{|x| x.old_id==r[0].to_i}).nil?
              # s.save!
              p "new"
              p s
              @student<<[0,s]
            else
              new_old=old.dup
              old.surname=s.surname
              old.firstname=s.firstname
              old.secondname=s.secondname
              #old.save!
              p old
              @student<<[1,new_old,old] unless old.surname==new_old.surname and old.firstname==new_old.firstname and old.secondname==new_old.secondname
            end
          end
        end
      end
    end
  end

  def student_group
    new=[]
    date=Date.today.strftime("%d.%m.%Y").to_s#"06.11.2020"
    faculty_id=7
    group=[]
    @student_group=[]

    student_group_all=StudentGroup.includes({:group=>:faculty},:student)
    student_all=student_group_all.map{|x| x.student}
    group_all=student_group_all.map{|x| x.group}
    faculty_all=Faculty.all
    begin
      client = XMLRPC::Client.new("portal.msiu.ru", "/RPC2", 8070)
      client.timeout = 600
      result = client.call("scholarship.groups_list", '2014/2015', '1')
      result2 = client.call("scholarship.groups_list", '2013/2014', '2')

      for i in 0...result.size
        r=result[i]
        if faculty_all.find{|x| x.old_id==r[4].to_i}.id==faculty_id
          group<<[r[0],r[1]] #[id,name]
        end
      end
      group.uniq!

      group.each do |id,name|
        for i in 0...result2.size
          r=result2[i]
          r0= r[0]  if r[1]== name #[id,id_old]
        end
        new << [r0,id]
      end

      new.each do |group_id,id_old|
        result = client.call("scholarship.students_list_without_marks", "#{id_old}")
        result2 = client.call("scholarship.students_list", "#{group_id}",date)
        for i in 0...result.size
          r=result[i]
          if r[5]=="обучается"
            unless (s=student_all.find{|x| x.old_id==r[0].to_i}).nil? or (g=group_all.find{|x| x.old_id== id_old.to_i}).nil?
              sg=StudentGroup.new(group_id: g.id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend: 0)
              sg.student_id=s.id
              if (old=student_group_all.find{|x| x.group_id==sg.group_id and x.student_id==sg.student_id}).nil?
                p "new1"
                @student_group<<[0,sg]
              else
                new_old=old.dup
                old.commerce=sg.commerce
                p "stold===1"
                @student_group<<[1,new_old,old] unless old.commerce==new_old.commerce
              end
            end
          else
            unless (s=student_all.find{|x| x.old_id==r[0].to_i}).nil? or (g=group_all.find{|x| x.old_id== id_old.to_i}).nil?
              old=student_group_all.find{|x| x.group_id== g.id and x.student_id== s.id}
              p "del1"
              @student_group<<[2,old] unless old.nil?
            end
          end
        end

        unless result2.empty?
          p "========="
          for i in 0...result2.size
            r=result2[i][0]
            r1=result2[i][1]
            unless (s=student_all.find{|x| x.old_id==r[0].to_i}).nil? or (g=group_all.find{|x| x.old_id== id_old.to_i}).nil?
              sg=StudentGroup.new(group_id: g.id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend:(r1=="другой")? 0 :( (r1=="хорошист") ? 1 : 2))
              sg.student_id=s.id
              unless (old=StudentGroup.find_by(group_id: sg.group_id, student_id: sg.student_id)).nil?
                new_old=old.dup
                if old.type_stipend>sg.type_stipend
                  p "<<<<"
                  old.type_stipend=sg.type_stipend
                elsif old.type_stipend<sg.type_stipend
                  p ">>>>"
                  old.type_stipend=sg.type_stipend
                end
                p "stold===2"
                @student_group<<[1,new_old,old] unless old.type_stipend==new_old.type_stipend
              end
            end
          end
        end
      end
    end
  end


  def new
    raise params.inspect
  end
end
