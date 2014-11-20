require 'nokogiri'
require 'open-uri'
require 'curb'
require 'byebug'
require 'csv'

class String
  def remove_non_ascii
    require 'iconv'
    Iconv.conv('ASCII//IGNORE', 'UTF8', self)
  end
end

def show_status(msg)
  current_time = Time.now.strftime('%H:%M:%S')
  puts "[#{current_time}] #{msg}"
end

show_status "Getting total record..."

url = 'http://www.istiadat.gov.my/index.php/component/semakanlantikanskp/'

http = Curl.post(url, { start: 0 })

page = Nokogiri::HTML(http.body_str)

total_records = page.css('.notis').first.text.match(/[0-9]+/)[0].to_i

show_status "#{total_records} available"


# Write CSV header
CSV.open("output/output.csv", "w") do |csv|
  csv << %w( NAMA ANUGERAH SINGKATAN TAHUN )
end


if total_records > 0
  counter = 0
  while (counter <= total_records)

    show_status "Getting and writing record from #{counter} to #{counter + 20}"

    begin
      http = Curl.post(url, { start: counter })

      page = Nokogiri::HTML(http.body_str)

      rows = page.css('table.border.header tr')

      rows.each_with_index do |row, row_index|
        if row_index > 0
          nama = row.css('td')[1].text.strip.gsub(/\u00a0/, ' ')
          anugerah = row.css('td')[2].text.strip
          singkatan = row.css('td')[3].text.strip
          tahun = row.css('td')[4].text.strip

          CSV.open("output/output.csv", "a+") do |csv|
            csv << [ nama, anugerah, singkatan, tahun ]
          end
        end
      end
    rescue e
      show_status "Error at #{counter}"
    end

    counter = counter + 20

    # break if counter == 100
  end
end

show_status "Done"
