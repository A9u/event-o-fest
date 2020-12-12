require 'csv'

desc 'Upload users from csv'
task :user_upload, [:file_name] => :environment do |t, args|
  errors = []
  CSV.foreach(args[:file_name], headers: true) do |row|
    user = User.create(username: row['username'], email: row['email'], phone_number: row['phone'])

    errors.push(row.to_a.map{|s| s[1] } + [user.errors.full_messages.join(". ")]) if user.invalid?
  end

  File.write(args[:file_name]+'_errors', errors) if errors.length > 0
end
