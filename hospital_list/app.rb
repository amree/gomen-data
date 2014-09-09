require 'nokogiri'
require 'open-uri'
require 'csv'

def show_status(msg)
  current_time = Time.now.strftime('%H:%M:%S')
  puts "[#{current_time}] #{msg}"
end

url = 'http://www.moh.gov.my/index.php/database_stores/store_view/3'

show_status "Fetching data from #{url}"

page = Nokogiri::HTML(open(url))

columns = page.css('.database_store_grid_view_div  .ds_view_row_3')

show_status "Extracting data"

hospitals = []
columns.each do |column|
  arrays = column.text.split("\n\n\n")

  name     = arrays[1]
  address1 = arrays[2]
  address2 = arrays[3]
  address3 = arrays[4]
  address4 = arrays[5]
  phone    = arrays[6]
  fax      = arrays[7]

  # Cleanups
  name.strip!
  address1.strip!
  address2.strip!
  address3.strip!
  address4.strip!
  phone.strip!
  fax.strip!

  phone.sub! "Tel : ", ""
  fax.sub! "Fax : ", ""
  address4.gsub! "\u00A0", ""

  # hospitals << "#{name};#{address1};#{address2};#{address3};#{address4};#{phone};#{fax}"
  hospitals << [name, address1, address2, address3, address4, phone, fax]
end

show_status "Writing data"

CSV.open("output/output.csv", "w") do |csv|
  csv << %w( NAMA ALAMAT1 ALAMAT2 ALAMAT3 ALAMAT4 TELEFON FAKS)

  hospitals.each do |hospital|
    csv << hospital
  end
end

show_status "Done"
