class User < ApplicationRecord
    has_secure_password



    def age
        now = Time.now.utc.to_date
        now.year - self.dob.year - ((now.month > self.dob.month || (now.month == self.dob.month && now.day >= self.dob.day)) ? 0 : 1)
    end

    def birthday
        bday = Date.new(Date.today.year, self.dob.month, self.dob.day)
        bday += 1.year if Date.today >= bday
        (bday - Date.today).to_i == 0
    end
    
end
