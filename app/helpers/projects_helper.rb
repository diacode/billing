module ProjectsHelper
  def project_deadline(days_left)
    if days_left > 0
      "Quedan #{days_left} días"
    else
      "Sobrepasado #{days_left.abs} días"
    end
  end

  def project_deadline_class(days_left)
    if days_left > 0 then "on-time" else "overdue" end
  end
end