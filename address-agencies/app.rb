#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'byebug'

class AgencyScraper
  include Capybara::DSL

  def initialize
    Capybara.default_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end

    @agencies = []
  end

  def scrape
    show_status "Starting"

    visit 'https://www.malaysia.gov.my/agencies'

    find('.agcMenu2').click_link('Agensi Berdasarkan Abjad A hingga Z')

    links = find('.alphabetArea').all('a[href]')
    show_status "Found #{links.size} agencies"

    links.each_with_index do |link, link_index|
      show_status "[#{link_index + 1}/#{links.size}] Extracting #{link.text}..."

      @agencies << { nama: '',
                     latitude: '',
                     longitude: '',
                     keterangan: '',
                     alamat: '',
                     telefon: '',
                     fax: '',
                     email: '',
                     website: '',
                     facebook: '',
                     linkedin: '',
                     twitter: '',
                     blogspot: '',
                     flickr: '',
                     rss: '',
                     youtube: '' }

      page = nil

      begin
        page = Nokogiri::HTML(open(link['href']))
      rescue OpenURI::HTTPError
        @agencies.last[:nama] = link.text
      else
        page.css('.agencyContainer table tr').each_with_index do |row, index|

          case index
          when 0
            @agencies.last[:nama] = row.text.strip
          when 1
            @agencies.last[:keterangan] = row.css('td')[2].text.strip
            @agencies.last[:latitude], @agencies.last[:longitude] = row.css('td')[3].text.scan /[0-9]+\.[0-9]+/
          when 2
            @agencies.last[:alamat] = row.css('td')[2].text.strip
          when 3
            @agencies.last[:telefon] = row.css('td')[2].text.strip
          when 4
            @agencies.last[:fax] = row.css('td')[2].text.strip
          when 5
            @agencies.last[:email] = row.css('td')[2].text.strip
          when 6
            @agencies.last[:website] = row.css('td')[2].text.strip
          when 7
            @agencies.last[:facebook] = extract_social_link(0, row)
            @agencies.last[:linkedin] = extract_social_link(1, row)
            @agencies.last[:twitter]  = extract_social_link(2, row)
            @agencies.last[:blogspot] = extract_social_link(3, row)
            @agencies.last[:flickr]   = extract_social_link(4, row)
            @agencies.last[:rss]      = extract_social_link(5, row)
            @agencies.last[:youtube]  = extract_social_link(6, row)
          end
        end # page
      end # begin
    end

    show_status "Writing data"

    CSV.open("output/output.csv", "w") do |csv|
      csv << %w( NAMA LATITUDE LONGITUDE KETERANGAN ALAMAT TELEFON FAX EMAIL WEBSITE FACEBOOK LINKEDIN TWITTER BLOGSPOT FLICKR RSS YOUTUBE)

      @agencies.each do |agency|
        csv << agency.values
      end
    end

    # page.save_screenshot('screenshot.png')

    show_status "Done"
  end

  private

  def show_status(msg)
    current_time = Time.now.strftime('%H:%M:%S')
    puts "[#{current_time}] #{msg}"
  end

  def extract_social_link(position, row)
    if row.css('table td')[position].css('a').count > 0
      row.css('table td')[position].css('a')[0]['href']
    end
  end
end

AgencyScraper.new.scrape
