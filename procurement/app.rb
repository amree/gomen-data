#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'byebug'

class ProcurementBot
  include Capybara::DSL

  def initialize(type = 'sh')
    Capybara.default_driver = :poltergeist

    @type         = type
    @procurements = []
  end

  def scrape
    show_status "Starting for #{@type}"
    get_links
    print_csv
    show_status "Done"
  end

  def get_links
    visit 'https://www.eperolehan.com.my/qt.notice.board.main.ac?languageId=571'

    # click_link 'Sebutharga baru bagi tempoh 7 hari yang lepas'
    # click_link 'Lihat Kesemua Sebutharga'

    if @type == 'sh'
      find("a[href*='newQuotation']").click
    else
      find("a[href*='newTender']").click
    end

    # Got to all page
    find("a[href*='all']").click

    # Get totol pages
    text = find('td', text: /^Memaparkan hasil/).text
    total = (text.split(' ').last.to_i / 10.0).ceil
    # total = 1

    (1..total).each do |i|

      show_status "In Page #{i}"

      fill_in 'pagerPageNoUser', with: i
      click_button 'Pergi ke Mukasurat'

      proc_index = []
      find('.Thin_tbl').all('tr').each_with_index do |tr, tr_i|
        next if tr_i == 0

        no, no_msg   = parse_no tr.all('td')[1].text
        kementerian  = tr.all('td')[2].text
        jabatan      = tr.all('td')[3].text
        ptj          = tr.all('td')[4].text
        tarikh_iklan = tr.all('td')[5].text
        taklimat     = tr.all('td')[6].text
        tarikh_tutup = tr.all('td')[7].text
        perihal      = tr.all('td')[8].text

        show_status "Found #{no} in Page #{i} - Row #{tr_i}"

        # Search for duplicates
        found_dup = false
        @procurements.each do |procurement|
          if procurement.first == no
            found_dup = true
          end
        end

        unless found_dup
          @procurements << [no, no_msg, kementerian, jabatan, ptj, tarikh_iklan, taklimat, tarikh_tutup, perihal, nil]
        end
        proc_index   << @procurements.size - 1
      end

      # Click links in the page to get the codes
      proc_index.each do |index|
        procurement = @procurements[index]
        show_status "In Page #{i} - Getting Procurement #{procurement[0]}"

        click_link procurement[0]

        td_pos = nil
        all('td').each_with_index do |td, td_i|
          if td.text == 'Kod Bidang'
            td_pos = td_i + 1
            break
          end
        end

        # Replace last element with procurement code
        procurement[-1] = all('td')[24].text

        click_button "Kembali"
      end
    end

    @procurements.each do |procurement|
      puts procurement.to_s
    end

    puts "Total: #{@procurements.size}"
  end

  def print_csv
    CSV.open("output/output.csv", "w") do |csv|
      csv << %w( NO MSG KEMENTERIAN JABATAN PTJ TARIKH_IKLAN TAKLIMAT TARIKH_TUTUP PERIHAL KOD )

      @procurements.each do |procurement|
        csv << procurement
      end
    end
  end

  private

  def parse_no(str)
    no  = str.split(' ')[0]
    msg = str.sub(no, '').strip

    [no, msg]
  end

  def show_status(msg)
    current_time = Time.now.strftime('%H:%M:%S')
    puts "[#{current_time}] #{msg}"
  end
end

ProcurementBot.new('sh').scrape

