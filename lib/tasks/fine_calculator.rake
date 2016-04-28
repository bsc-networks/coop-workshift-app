require 'pp'

namespace :fine_calculator do
  desc "Runs every n hours depending on Heroku's scheduler setup
        * Calculate blown shifts Sunday at midnight
        * When you blow a shift you should be subtracted double 
                the hrs that the shift (eg. 2 hrs of pots = -4 hrs if blown)
        * Every fining date you are fined the fining 
                rate*hrs down and your hrs are reset to 0"
  task :start => :environment do
    pp "Scheduler woke up at #{Time.now}, iterating over recent shifts"

    pp getShiftsForLastNDays(7)
  end
  
  def getShiftsForLastNDays(n)
      Shift.all.where(date: (Date.current - n.days)..Date.current)
  end 
end