module FacultiesHelper
  def faculty(controller)
    (current_user.faculty.name == "all") ? controller : controller.find_all { |x| x.faculty_id == current_user.faculty_id }
  end
end
