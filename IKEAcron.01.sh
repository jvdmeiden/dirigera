#!/bin/bash

# source the Python venv
source <my env>projects/dirigera/bin/activate

# Run the python script that reads from the dirigera and inserts values in the database
python3 <my env>projects/dirigera/IKEARead.01.py

# Get information from the weather service regarding current weather
KNMI=`curl -s https://www.knmi.nl/nederland-nu/weer/waarnemingen  | grep 'td class' |  grep -A 9 'De Bilt' | sed 's/<\/td>/|/' | html2text | tr -d '\n'` 
IFS="|"
set $KNMI
sqlite3 <my env>projects/dirigera/measurements.db "insert into weather (place,weather_description,temperature,humidity,wind,wind_speed,wind_gust,visibility,pressure) \
         values (\"${1}\",\"${2}\",\"${3}\",\"${4}\",\"${5}\",\"${6}\",\"${7}\",\"${8}\",\"${9}\");"


# Create a web page with recent measurements
cat <my env>projects/dirigera/start.html > <my env>projects/dirigera/index.html
sqlite3 <my env>projects/dirigera/measurements.db -header -html "select * from sensor_measurement where room = '<myroom>' order by timestamp desc limit 50;" >> <my env>projects/dirigera/index.html

sqlite3 <my env>projects/dirigera/measurements.db -header -html "select * from weather order by timestamp desc limit 100;" >> <my env>projects/dirigera/index.html
cat <my env>projects/dirigera/end.html >> <my env>projects/dirigera/index.html
