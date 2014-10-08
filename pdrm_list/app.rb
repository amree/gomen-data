require 'nokogiri'
require 'open-uri'
require 'csv'
require 'byebug'

def show_status(msg)
  current_time = Time.now.strftime('%H:%M:%S')
  puts "[#{current_time}] #{msg}"
end

base_url = 'http://www.rmp.gov.my'
dir_url  = 'direktori/direktori-pdrm'
states   = %w(
            johor
            melaka
            negeri-sembilan
            kuala-lumpur
            selangor
            perak
            kedah
            pulau-pinang
            perlis
            kelantan
            terengganu
            pahang
            sarawak
            sabah)

urls       = []
state_urls = []
states.each do |state|
  state_urls << "#{base_url}/#{dir_url}/#{state}"

  show_status "Fetching urls from #{state_urls.last}..."

  page = Nokogiri::HTML open(state_urls.last)

  page.css("a[href^='/direktori']").each do |p|
    urls << "#{base_url}#{p.attribute('href')}"
  end
end

# Cleaning up URL
#
# PDRM put state links in every page for district and since we just
# one district links, we should remove state links
urls = urls - state_urls

show_status "Extracted #{urls.size} links"

types = ['Ibu Pejabat Polis Daerah (IPD)', 'Balai Polis', 'Pondok Polis']

addresses = []
urls.each do |url|
  show_status "Extracting addresses from #{url}"
  page = Nokogiri::HTML open(url)

  type = ''
  page.css(".sfContentBlock table[bordercolor='#3372a9']").each_with_index do |table, i|
    tds = table.css('td')
    tds.each_with_index do |td, i|

      text = td.text.strip

      if types.include? text
        type = text
        next
      end

      if text.empty?
        next
      end

      if td.text.strip.match /Alamat/
        address   = tds[i + 1].text.strip
        telephone = tds[i + 3].text.strip
        fax       = tds[i + 5].text.strip
        email     = tds[i + 7].text.strip

        address1, address2, address3, address4, address5 = address.split("\n").map { |addr| addr.strip! }
        addresses << [type, address1, address2, address3, address4, address5, telephone, fax, email]
        next
      end
    end

  end
end

CSV.open("output/output.csv", "w") do |csv|
  csv << %w( JENIS ALAMAT1 ALAMAT2 ALAMAT3 ALAMAT4 ALAMAT5 TELEFON FAX EMAIL )

  addresses.each do |address|
    csv << address
  end
end
