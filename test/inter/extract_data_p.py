import re
import os

directory = "./result"
os.chdir(directory)
cwd = os.getcwd()  

with open("result_temp.csv","w") as file_object:
    file_object.write("bitrate(kb/s) , psnr(Y) , psnr(U) , psnr(V) , Sequence\n")

files = os.listdir(os.getcwd())
for file in files:
    if "log" in file.split("."):
        y_psnr = 0
        u_psnr = 0
        v_psnr = 0
        bitrate = 0
        cout = 0
        with open(file) as file_object:
            lines = file_object.readlines()
        for line in lines:
            if re.match(r'\s+\d+\s+(P).',line):
                element  = line.split(" ")
                while '' in element:
                    element.remove('')
                bitrate = element[2]
                y_psnr  = element[4]
                u_psnr  = element[5]
                v_psnr  = element[6]
                with open("result_temp.csv","a") as file_object:
                    file_object.write(str(bitrate) +",")
                    file_object.write(str(y_psnr ) +",")
                    file_object.write(str(u_psnr ) +",")
                    file_object.write(str(v_psnr ) +",")
                    file_object.write(str(file)+"\n")

#sort
with open("result.csv","w") as file_object:
    file_object.write("bitrate(kb/s) , psnr(Y) , psnr(U) , psnr(V) , Sequence\n")

file_list = ["BasketballPass"  ,
             "BQSquare"        ,
             "BlowingBubbles"  ,
             "RaceHorses"      ,
             "BasketballDrill" ,
             "BQMall"          ,
             "PartyScene"      ,
             "RaceHorsesC"     ,
             "FourPeople"      ,
             "Johnny"          ,
             "KristenAndSara"  ,
             "Kimono"          ,
             "ParkScene"       ,
             "Cactus"          ,
             "BasketballDrive" ,
             "BQTerrace"       ,
             "Traffic"         ,
             "PeopleOnStreet"
            ]
qp_list = [22,27,32,37]

for file_name in file_list:
    with open("result_temp.csv") as file_read:
        lines = file_read.readlines()
        for line in lines:
            if re.match(r'.*?%s\_'%(file_name),line):
                with open("result.csv","a") as file_write:
                    file_write.write(line)

# os.remove("result_temp.csv")  
