# Data

## Origin
All data used by this gem has been taken from the *UN Centre for Trade Facilitation and E-business* official website. **No guarantees for the accuracy or up-to-dateness are given.**

`http://www.unece.org/cefact/locode/welcome.html` and `http://www.unece.org/cefact/codesfortrade/codes_index.html`

## License
Nowhere on the site of the *UN Centre for Trade Facilitation and E-business* is the license stated under which this data is published. There is a Disclaimer under `http://www.unece.org/legal_notice/termsandconditions.html` which sounds as if the materials on the UNECE website can be used freely. **Should this not be the case send me an email** and I will change whatever is required to conform with the data's license.

## Dataimport/-update
In order to update the data you first have to download the latest CSV files from one of the above stated UNECE websites. Extract the zip file and place all CSV files in the `data/csv` directory.
The last time I downloaded the csv files they were in the **iso-8859-1** format which the dataimport script cannot handle. You can check the file encoding with the following command:

	file -I csv/1.csv
	# csv/1.csv: text/plain; charset=iso-8859-1

In this case you need to convert all csv files to the UTF8 file encoding. You can accomplish that with the following command for each of the files:

	iconv -f ISO-8859-1 -t UTF-8 csv/1.csv > csv/1.utf8.csv
	rm csv/1.csv

Now that all csv files are in the UTF8 file encoding you can proceed to the next step.

 After this you have to  run the **dataupdate** Rake task like this:

  	rake dataupdate

This parses the CSV files, builds a new objecttree with the data, and then dumps all objects into the YAML files. From then on, when loading the gem the new data will be used.
