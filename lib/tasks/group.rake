task :group => :environment do
  sg=StudentGroup.where("social = ?",true)
  sg.each do |x|
     p x.student.surname
    #   s=StudentGroup.where("student_id=? AND id != ?",x.student_id,x.id).first
    # # unless s.nil?
    # #   p s.group.name
    # #   s.type_stipend=x.type_stipend
    # #   s.save!
    # # end
    # p x.group.name

  end
p sg.size
end