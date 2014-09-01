require 'open-uri'
require 'tabula'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby senarai_sekolah.rb [options]"

  opts.on("-r", "--redownload", "Redownload all files") do |v|
    options[:redownload] = v
  end
end.parse!

if options[:redownload]
  # Download
  #
  urls = %w(
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/JohorR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/JohorM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/KedahR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/KedahM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/KelantanR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/KelantanM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/MelakaR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/MelakaM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/N9R.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/N9M.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/PahangR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/PahangM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/PerakR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/PerakM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/PerlisR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/PerlisM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/PenangR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/PenangM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/SabahR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/SabahM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/SarawakR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/SarawakM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/SelangorR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/SelangorM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/TerengganuR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/TerengganuM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/wpklR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/wpklM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/wpLabuanR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/wpLabuanM.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Rendah/wpPutrajayaR.pdf
    http://emisportal.moe.gov.my/emis/emis2/emisportal2/doc/fckeditor/File/senarai_sekolah_jun2014/Menengah/wpPutrajayaM.pdf
  )

  urls.each do |url|
    uri = URI.parse(url)
    name = File.basename(uri.path)

    File.open("./input/#{name}", "wb") do |saved_file|
      open(url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end

    puts "-- [FINISHED] Download for #{name}"
  end
else
  puts "No redownload. Using existing files."
end

# Converting
#
pdfs = Dir.glob(File.join('./input/', '*.pdf'))

pdfs.each do |pdf|
  filename = File.basename(pdf)
  output   = "./output/#{File.basename(pdf, '.pdf')}.csv"
  out      = open(output, 'w')

  puts "-- [START] Converting #{filename}"

  extractor = Tabula::Extraction::ObjectExtractor.new(pdf, :all )
  extractor.extract.each do |pdf_page|
    pdf_page.spreadsheets.each do |spreadsheet|
      out << spreadsheet.to_csv
      out << "\n\n"
    end
  end
  out.close

  lines = File.open(output) {|f| count = f.read.count("\n")}
  puts "-- [FINISHED] #{filename} [#{lines} lines]"
end

# Cleaning
#
Dir.glob(File.join('./output', '*.csv')).each do |output|
  filename = File.basename(output)
  system "tr -d $'\r' < #{output} | sed '/^\s*$/d;/^BIL/d' > ./output/output-#{filename}.csv"
  File.rename("./output/output-#{filename}.csv", output)
end
puts 'Cleaning files done...'

# Combine Files
#
system 'cat ./output/* > ./all.csv'
system 'mv ./all.csv ./output/all.csv'
system 'cat ./output/*M.csv > ./output/all_menengah.csv'
system 'cat ./output/*R.csv > ./output/all_rendah.csv'
puts 'Combining files done...'
