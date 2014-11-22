# README

# Usage

```
# Make sure ruby and bundle is installed
$ bundle
$ bundle exec ruby app.rb
```

## Output

Example:

```
Hospital Tumpat,Jalan Kelaburan,"Tumpat, Kelantan",62000 Tumpat,Kelantan,09-7263000,09-7257082
Hospital Umum Kuching,Jalan Tun Ahmad Zaidi Adruce,"Kuching, Sarawak",93586 Kuching,Sarawak,082-276666,082-242751
Hospital Wanita dan Kanak-Kanak Sabah,Karung Berkunci 187,"Kota Kinabalu, Sabah",88996 Kota Kinabalu,Sabah,088-522600,088-438512
Hospital Yan,Batu 25 Jalan Yan,"Yan, Kedah",06900 Yan,Kedah,04-4655333,04-4655960
Institut Perubatan Respiratori,Jalan Pahang,"Kuala Lumpur, WP Kuala Lumpur",53000 Kuala Lumpur,WP Kuala Lumpur,03-40232966,03-40218807
```

## Columns

* NAMA
* ALAMAT1
* ALAMAT2
* ALAMAT3
* ALAMAT4
* TELEFON
* FAKS

## Problems

These two data has not been properly extracted and I think I'm going to leave it as it is:

```
Hospital Orang Asli,"KM 24, Jalan Pahang Lama, 53100 Gombak, Selangor","",53100 Gombak,Selangor,Tel :,Fax :
Hospital Duchess Of Kent,"KM 3.2, Jalan Utara","Sandakan, Sabah",90000 Sandakan,Sabah,089-248 600                     Talian_Kecemasan:089-255 022,089-213 607                        Emel:hdok@moh.gov.my
```

## Source

[http://www.moh.gov.my/index.php/database_stores/store_view/3](http://www.moh.gov.my/index.php/database_stores/store_view/3)
