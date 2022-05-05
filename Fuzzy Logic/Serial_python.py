import serial.tools.list_ports
import pyrebase
import time
from getpass import getpass
config = {
  "apiKey": "AIzaSyCjkTs3gHZtIGcPoenF1BUa_Dg7PjJ7xEE",
  "authDomain": "mdp-auth-bf341.firebaseapp.com",
  "databaseURL": "https://mdp-auth-bf341-default-rtdb.firebaseio.com",
  "projectId": "mdp-auth-bf341",
  "storageBucket": "mdp-auth-bf341.appspot.com",
  "messagingSenderId": "351409448135",
  "appId": "1:351409448135:web:df5da6e40634d3c64c8ae2",
  "measurementId": "G-7WVD5M0S4P"
}
#  config ={
#     "apiKey": "AIzaSyCjkTs3gHZtIGcPoenF1BUa_Dg7PjJ7xEE",
#     "authDomain": "mdp-auth-bf341.firebaseapp.com",
#   "databaseURL": "https://mdp-auth-bf341-default-rtdb.firebaseio.com",
#   "projectId": "mdp-auth-bf341",
#   "storageBucket": "mdp-auth-bf341.appspot.com",
#   "messagingSenderId": "351409448135",
#   "appId": "1:351409448135:web:df5da6e40634d3c64c8ae2",
#   "measurementId": "G-7WVD5M0S4P"
# }
firebase = pyrebase.initialize_app(config)

auth = firebase.auth()

arduinoSerial=serial.Serial('com4',9600)


##email = input("Please Enter Your Email Address: \n ")
##password = getpass("Please Enter Your Password: \n ")
email="group19@fuzzylogicpv.com"
password="group19mdp"
user = auth.sign_in_with_email_and_password(email, password)
print("Success ...")

db = firebase.database()

while(True):
    i=0
    if(arduinoSerial.inWaiting()>0):
        Data=arduinoSerial.readline()
        Data=Data.decode('utf').rstrip('\n').rstrip('\r')
        l1=Data.split(',')
        print(l1)
        data={
            "Decision":float(l1[0]),
            "Decision Name":l1[1],
            "Hour":int(l1[2]),
            "Day":int(l1[3]),
            "Month":int(l1[4]),
            "Year":int(l1[5]),
            "Minute":int(l1[6])
        }
        time.sleep(5)
        print(data)
        i+=1
        db.child("Delivered number "+str(i)).set(dat a)
