class User < ActiveRecord::Base
    has_secure_password
    validates :email, uniqueness: true
    
    def self.import(file)
        # puts file
        spreadsheet = open_spreadsheet(file)
        # puts spreadsheet.info
        header = spreadsheet.row(1)
        added = []
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          #   print row
          # puts
          # puts row["email"]
          user = find_by(email: row["email"]) || new
          puts user.sent_confirmation
          user.attributes = row.to_hash.slice(*row.to_hash.keys)
          user.password = User.random_pw
          if (not user.sent_confirmation) and user.save
            added += [user]
          end
        end
        return added
    end
    
    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"           
      end
    end
    
    def full_name
      return first_name + " " + last_name
    end 
    
    def self.send_confirmation(id)
      user = find(id)
      if user
        email = user.email
        user.update_attribute(:sent_confirmation, true)
        puts "Sending confirmation to " + user.full_name + " at " + email
      else
        puts "Couldnt find user"
      end
    end
    
    def self.random_pw
      ('0'..'z').to_a.shuffle.first(8).join
    end
end
