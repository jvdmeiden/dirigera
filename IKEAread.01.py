import dirigera
import sqlite3

conn = sqlite3.connect('<my measurement db')
cursor = conn.cursor()

hub = dirigera.Hub(
  token="<my token>",
  ip_address="<IP of my DIRIGERA>"
)
current = hub.get_environment_sensors()
for i in range(len(current)):
  cursor.execute('''INSERT INTO sensor_measurement(room,temperature,humidity,pm2_5,tvoc) 
    VALUES (?,?,?,?,?)''',
    [current[i].attributes.custom_name,current[i].attributes.current_temperature,current[i].attributes.current_r_h,current[i].attributes.current_p_m25,current[i].attributes.voc_index])
  conn.commit()
conn.close()
