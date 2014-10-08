require 'csv'
require 'byebug'

file = File.read("./output/output.csv")

key   = 'KOD'
codes = %w(020101
           020401
           020701
           020801
           020802
           050301
           220503)

numbers = %w(X0143010200140066
             X0143080100140021
             X0143080100140023
             X0143080100140024
             X0232010101140018
             X0269010200140041
             X0301010600140023
             X0351070101140061)

csv = CSV.parse(file, :headers => true)

# puts csv.find { |row| row['KOD'].scan('210102').count > 0 }

csv.find do |row|
  found = false
  codes.each do |code|
    # puts "--- #{row['KOD']} - #{code}"
    if row['KOD'].scan(code).count > 0
      status = 'NEW'

      if numbers.include? row['NO']
        status = 'OLD'
      end

      puts "#{status} - #{row['NO']} - #{row['TARIKH_TUTUP']} - #{row['KOD']}"
      break
    end
  end

  found
end
