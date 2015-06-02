module ApplicationHelper
  def js_class_name
    action = case action_name
      when 'create' then 'New'
      when 'update' then 'Edit'
      else action_name
    end.camelize

    "Smithers.Views.#{controller.class.name.gsub('::', '.').gsub(/Controller$/, '')}.#{action}View"
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @markdown.render(content)
  end

  def get_current_date_filter
    if @a && @b
      "#{l(@a.to_date)} - #{l(@b.to_date)}"
    end
  end
end
