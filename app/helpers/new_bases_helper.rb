module NewBasesHelper

  def edit_group
    params[:edit_base].each do |x|
      tmp=@tmp.find{|q| q.group_id==x.to_i}
      unless tmp.nil?
        old=Group.find(x.to_i)
        old.name=tmp.name
        old.year=tmp.year
        old.faculty_id=tmp.faculty_id
        old.kurs=tmp.kurs
        old.semester=tmp.semester
        old.save!
      end
    end
  end

  def new_group
    params[:new_base].each do |x|
      tmp=@tmp.find{|q| q.id==x.to_i}
      unless tmp.nil?
        old=Group.new
        old.name=tmp.name
        old.year=tmp.year
        old.faculty_id=tmp.faculty_id
        old.old_id=tmp.old_id
        old.kurs=tmp.kurs
        old.semester=tmp.semester
        old.save!
      end
    end
  end

  def edit_student
    params[:edit_base].each do |x|
      tmp=@tmp.find{|q| q.student_id==x.to_i}
      unless tmp.nil?
        old=Student.find(x.to_i)
        old.surname=tmp.surname
        old.firstname=tmp.firstname
        old.secondname=tmp.secondname
        old.save!
      end
    end
  end

  def new_student
    params[:new_base].each do |x|
      tmp=@tmp.find{|q| q.id==x.to_i}
      unless tmp.nil?
        old=Student.new
        old.surname=tmp.surname
        old.firstname=tmp.firstname
        old.secondname=tmp.secondname
        old.old_id=tmp.old_id
        old.save!
      end
    end
  end

end
