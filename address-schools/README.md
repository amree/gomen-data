# Output

Please check output directory to see the end result. Most of the files are based
on their original filename, however there are some files combined together for
easier viewing:

```
output/all.csv                Combination of every files
output/all_menengah.csv       Combination of every secondary school
output/all_rendah.csv         Combination of every secondary school
```

# Installation

Install all required gems

```
bundle install
```

# Run

Using existing pdfs

```
bundle exec ruby app.rb
```

Redownload all pdf files

```
bundle exec ruby app.rb -r
```

# Output

```
265,JOHOR,PPD SEGAMAT,SM Kebangsaan,JEB7030,SMK  SEG HWA (CF),"PETI SURAT 513,",SEGAMAT,85009,079311235,079311235
266,JOHOR,PPD SEGAMAT,SM Kebangsaan,JEB7031,SMK CANOSSIAN CONVENT (M),JALAN BULOH KASAP,SEGAMAT,85000,079312130,079312130
267,JOHOR,PPD SEGAMAT,SM Kebangsaan,JEB7032,SMK LABIS,"JALAN MUAR,",LABIS,85300,079251306,079251306
268,JOHOR,PPD SEGAMAT,SM Kebangsaan,JEB7034,SMK PADUKA TUAN,"JALAN GENUANG, SEGAMAT",SEGAMAT,85000,079431341,079437376
```
# Columns

* BIL
* NEGERI
* PPD
* JENIS
* SEKOLAH
* KOD
* SEKOLAH
* NAMA SEKOLAH
* ALAMAT
* DAERAH
* POSKOD
* NO TELEFON
* NO FAKS

# Source

[http://emisportal.moe.gov.my/emis/emis2/emisportal2/](http://emisportal.moe.gov.my/emis/emis2/emisportal2/)
