class NewBasesController < ApplicationController
  require "xmlrpc/client"

  include NewBasesHelper

  def group
    @tmp=TmpGroup.all
    edit_group unless params[:edit_base].nil?
    new_group unless params[:new_base].nil?

    g=TmpGroup.all
    g.delete_all(['user_id = ?', current_user.id])

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
          #g=Group.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015")
          #@group<<[groups.find{|x| x.old_id==r[0].to_i}]
          if (old=groups.find{|x| x.old_id==r[0].to_i}).nil?
            g=TmpGroup.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015", status: 0, user_id: current_user.id)
            g.save!
            @group<<[0,g]
          else
            g=TmpGroup.new(old_id:r[0], name:r[1], semester:r[2], kurs:r[3],faculty_id: Faculty.find_by(old_id:r[4]).id, year:"2014/2015", status: 1, user_id: current_user.id, group_id:old.id)
            new_old=old.dup
            old.name=g.name
            old.semester=g.semester
            old.kurs=g.kurs
            old.faculty_id=g.faculty_id
            old.year=g.year
            g.save! unless old.name==new_old.name and old.semester==new_old.semester and old.kurs==new_old.kurs and old.faculty_id==new_old.faculty_id and old.year==new_old.year
            @group<<[1,new_old,old] unless old.name==new_old.name and old.semester==new_old.semester and old.kurs==new_old.kurs and old.faculty_id==new_old.faculty_id and old.year==new_old.year
          end
        end
      end
    end
  end

  def student
    @tmp=TmpStudent.all
    edit_student unless params[:edit_base].nil?
    new_student unless params[:new_base].nil?

    g=TmpStudent.all
    g.delete_all(['user_id = ?', current_user.id])

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
          # p s
          if r[5]=="обучается"
            if (old=student_all.find{|x| x.old_id==r[0].to_i}).nil?
              s=TmpStudent.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3], status: 0, user_id: current_user.id)
              s.save!
              @student<<[0,s]
            else
              s=TmpStudent.new(old_id:r[0], surname:r[1], firstname:r[2], secondname:r[3], status: 1, user_id: current_user.id, student_id:old.id)
              new_old=old.dup
              old.surname=s.surname
              old.firstname=s.firstname
              old.secondname=s.secondname
              #old.save!
              p old
              s.save! unless old.surname==new_old.surname and old.firstname==new_old.firstname and old.secondname==new_old.secondname
              @student<<[1,new_old,old] unless old.surname==new_old.surname and old.firstname==new_old.firstname and old.secondname==new_old.secondname
            end
          end
        end
      end
    end
  end

  def student_group
    @tmp=TmpStudentGroup.all
    edit_student_group unless params[:edit_base].nil?
    new_student_group unless params[:new_base].nil?
    del_student_group unless params[:del_base].nil?

    g=TmpStudentGroup.all
    g.delete_all(['user_id = ?', current_user.id])

    new=[]
    date=Date.today.strftime("%d.%m.%Y").to_s#"06.11.2020"
    faculty_id=7
    group=[]
    @student_group=[]

    student_group_all=StudentGroup.includes({:group=>:faculty},:student)
    student_all=Student.all
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
              if (old=student_group_all.find{|x| x.group_id==g.id and x.student_id==s.id}).nil?
                sg=TmpStudentGroup.new(group_id: g.id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend: 0, status: 0, user_id: current_user.id)
                sg.type_stipend=3 if g.kurs==1 and g.semester==1 and !sg.commerce
                sg.student_id=s.id
                sg.save!
                @student_group<<[0,sg]
              else
                sg=TmpStudentGroup.new(group_id: g.id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend: 0, status: 1, user_id: current_user.id, student_group_id:old.id)
                sg.student_id=s.id
                new_old=old.dup
                new_old.commerce=sg.commerce
                sg.save! unless old.commerce==new_old.commerce
                @student_group<<[1,old,new_old] unless old.commerce==new_old.commerce
              end
            end
          else
            unless (s=student_all.find{|x| x.old_id==r[0].to_i}).nil? or (g=group_all.find{|x| x.old_id== id_old.to_i}).nil?
              old=student_group_all.find{|x| x.group_id== g.id and x.student_id== s.id}
              @student_group<<[2,old] unless old.nil?
            end
          end
        end

        unless result2.empty?
          for i in 0...result2.size
            r=result2[i][0]
            r1=result2[i][1]
            unless (s=student_all.find{|x| x.old_id==r[0].to_i}).nil? or (g=group_all.find{|x| x.old_id== id_old.to_i}).nil?
              unless (old=student_group_all.find{|x| x.group_id==g.id and x.student_id==s.id}).nil?
                sg=TmpStudentGroup.new(group_id: g.id, commerce: (r[4]=="бюджетный") ? 0 : 1, type_stipend:(r1=="другой")? 0 :( (r1=="хорошист") ? 1 : 2), status: 1, user_id: current_user.id, student_group_id:old.id)
                sg.student_id=s.id
                new_old=old.dup
                new_old.type_stipend=sg.type_stipend
                sg.save! unless old.type_stipend==new_old.type_stipend
                @student_group<<[1,old,new_old] unless old.type_stipend==new_old.type_stipend
              end
            end
          end
        end
      end
    end
  end

end
