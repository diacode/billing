every 4.hours do
  runner "BankRecordImporter.new.import_last"
end

# We refresh hours spent counters of all active projects 
# everyday (except sunday) from 10 am to 10 pm.
every "0 10-22 * * 1-6" do
  runner "Project.refresh_projects_hours_spent"
end