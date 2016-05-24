class AddCurrenciesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :currency, :string, nil: false, default: MoneyRails.default_currency.to_s

    rename_column :projects, :budget, :old_budget
    rename_column :projects, :ratio, :old_ratio

    add_monetize :projects, :budget, currency: { present: true }
    add_monetize :projects, :ratio, currency: { present: true }

    Project.all do |project|
      project.budget = Money.new(project.old_budget*100) if project.old_budget
      project.ratio = Money.new(project.old_ratio*100) if project.old_ratio
      project.save if project.changed?
    end

    remove_column :projects, :old_budget
    remove_column :projects, :old_ratio
  end
end
