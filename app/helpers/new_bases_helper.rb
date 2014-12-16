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
        if old.save
          @flash_s << "Данные группы #{old.name} изменены<br>"
        else
          @flash_e << "Ошибка (#{old.id})"
        end
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
        if old.save
          @flash_s << "Группа #{old.name} добавлена<br>"
        else
          old.errors.messages.each do |_,msg|
            msg.each do |x|
              @flash_e << "Группа #{old.name} - ошибка  при записи (#{x})<br>"
            end
          end
        end
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
        if old.save
          @flash_s << "Данные студента #{old.surname} #{old.firstname} #{old.secondname} изменены<br>"
        else
          @flash_e << "Ошибка (#{old.id})"
        end
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
        if old.save
          @flash_s << "Данные студента #{old.surname} #{old.firstname} #{old.secondname} добавлены<br>"
        else
          @flash_e << "Ошибка (#{old.id})"
        end
      end
    end
  end

  def edit_student_group
    params[:edit_base].each do |x|
      tmp=@tmp.find{|q| q.student_group_id==x.to_i}
      unless tmp.nil?
        old=StudentGroup.includes(:student).find(x.to_i)
        old.type_stipend=tmp.type_stipend
        old.commerce=tmp.commerce
        if old.save
          @flash_s << "Данные студента #{old.student.surname} #{old.student.firstname} #{old.student.secondname} изменены<br>"
        else
          @flash_e << "Ошибка (#{old.id})"
        end
      end
    end
  end

  def new_student_group
    params[:new_base].each do |x|
      tmp=@tmp.find{|q| q.id==x.to_i}
      unless tmp.nil?
        old=StudentGroup.includes(:student).new
        old.type_stipend=tmp.type_stipend
        old.commerce=tmp.commerce
        old.student_id=tmp.student_id
        old.group_id=tmp.group_id
        if old.save
          @flash_s << "Данные студента #{old.student.surname} #{old.student.firstname} #{old.student.secondname} добавлены<br>"
        else
          @flash_e << "Ошибка (#{old.id})"
        end
      end
    end
  end

  def del_student_group
    params[:del_base].each do |x|
      old=StudentGroup.includes(:student).find(x.to_i)
      unless old.nil?
        @flash_s << "Данные студента #{old.student.surname} #{old.student.firstname} #{old.student.secondname} удалены<br>"
        old.delete
      end
    end
  end
end
