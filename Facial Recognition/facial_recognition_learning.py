import numpy as np
import cv2
import pickle
import os
import threading
import socket
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
# 27 - 40

RED = 40
BLUE = 38
GREEN = 37
BUTTON = 35
# motor is 29 and 31

GPIO.setup(RED, GPIO.OUT)
GPIO.setup(BLUE,GPIO.OUT)
GPIO.setup(GREEN, GPIO.OUT)
GPIO.setup(BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.output(RED, True)
isPerson = True

GPIO.output(BLUE, False)
#time.sleep(1000)

GPIO.setup(31, GPIO.OUT)


# loop never ends
while True:
    # if the button is pressed
    if(GPIO.input(BUTTON)):
        GPIO.output(BLUE, True)
        GPIO.output(RED, False)
        # do something
        time.sleep(1)
        #assume that isPerson is modified by yash's algorithm
        s = socket.socket()
        s.bind(("", 1919))
        s.listen(1)

        recognized = False
        unlock = False


        def loopforuhhhhhhhhhhhhhhhhhhhhhlockingtoggle(c):
            global unlock

            while True:
                data = c.recv(1024).decode("utf-8")
                if data == "unlock_door":
                    unlock = True
                if data == "lock_door":
                    unlock = False
                #TODO: ADD SHIT THAT TURNS LEDs ON/OFF HERE
                print(unlock)


        def loopshit(c):
            while not recognized:
                c.send("n".encode("utf-8"))

            # This transfers the image.
            with open(os.getcwd() + "\\send_to_pi.jpg", "rb") as f:
                c.sendfile(f)

            # This signals the app that the image is done transferring.
            print("sending d")
            c.send("d".encode("utf-8"))
            print("sent d")


        def socketloopaaaaaaahelp():
            print("socket =-====+Server loop started")
            while True:
                # more socket stuff
                c, addr = s.accept()
                print("Client connected!")

                threading.Thread(target=loopshit, args=[c]).start()
                threading.Thread(target=loopforuhhhhhhhhhhhhhhhhhhhhhlockingtoggle, args=[c]).start()


        face_cascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_default.xml')
        recognizer = cv2.face.LBPHFaceRecognizer_create()
        recognizer.read("./recognizers/face-trainner.yml")

        labels = {"person_name": 1}
        with open("pickles/face-labels.pickle", 'rb') as f:
        	og_labels = pickle.load(f)
        	labels = {v:k for k, v in og_labels.items()}

        cap = cv2.VideoCapture(0)

        # start socket server thread
        threading.Thread(target=socketloopaaaaaaahelp).start()

        while(True):
            # Capture frame-by-frame
            ret, frame = cap.read()

            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = face_cascade.detectMultiScale(gray, scaleFactor = 1.5, minNeighbors = 5)

            for (x,y,w,h) in faces:
                #print(x,y,w,h)

                roi_gray = gray[y:y+h, x:x+w]
                roi_color = frame[y:y+h, x:x+w]

                id_,conf = recognizer.predict(roi_gray)
                if conf >= 45 and conf <= 70:
                    print(conf)
                    print(labels[id_])
                    font = cv2.FONT_HERSHEY_SIMPLEX
                    name = labels[id_]
                    color = (255, 255, 255)
                    stroke = 2
                    cv2.putText(frame, name, (x,y), font, 1, color, stroke, cv2.LINE_AA)
                    isPerson = True

                else:
                    print("unknown")
                    img_item = "send_to_pi.jpg"
                    cv2.imwrite(img_item, frame)
                    isPerson = False

                color = (122,0,122)#BGR
                stroke = 2
                width = x + w
                height = y + h

                cv2.rectangle(frame, (x,y), (width, height), color, stroke)

            # Display the resulting frame
            cv2.imshow('frame',frame)
            if cv2.waitKey(20) & 0xFF == ord('q'):
                break


        # When everything done, release the capture
        cap.release()
        cv2.destroyAllWindows()

        if(isPerson):
            GPIO.output(BLUE, False)
            GPIO.output(GREEN, True)

            GPIO.setup(29, GPIO.IN)
            GPIO.setup(31,GPIO.OUT)

            GPIO.output(31, True)


            time.sleep(1)
            GPIO.output(31, False)


        else:
            GPIO.output(BLUE, False)
            GPIO.output(RED, True)

            GPIO.setup(31, GPIO.IN)
            GPIO.setup(29,GPIO.OUT)

            GPIO.output(29, True)
            time.sleep(1)
            GPIO.output(29, False)



GPIO.cleanup()
# socket stuff
