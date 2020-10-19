import re
import os

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
directory = "."
os.chdir(directory + '/result')
cwd = os.getcwd()  

with open("result.csv","w") as file_object:
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
            # print (file)
            lines = file_object.readlines()
        for line in lines:
            element  = line.split()
            # print (element)
            if 'CModel::POC' in element and 'QP' in element and element[1] != '0':
                y_psnr  += float(element[7 ])
                u_psnr  += float(element[10])
                v_psnr  += float(element[13])
                bitrate += float(element[4 ])
                cout += 1
        with open("result.csv","a") as file_object:
            if cout != 0:
                file_object.write(str(bitrate*60/cout/1000) +",")
                file_object.write(str(y_psnr/cout) +",")
                file_object.write(str(u_psnr/cout) +",")
                file_object.write(str(v_psnr/cout) +",")
                file_object.write(str(file)+"\n")
                print ('statistic '+str(cout)+' frames')


# os.remove("result_temp.csv")  


## ************ origin version ************ ##

# directory = "."
# os.chdir(directory + )
# cwd = os.getcwd()  

# with open("result_temp.csv","w") as file_object:
#     file_object.write("bitrate(kb/s) , psnr(Y) , psnr(U) , psnr(V) , Sequence\n")

# files = os.listdir(os.getcwd())
# for file in files:
#     if "csv" in file.split("."):
#         y_psnr = 0
#         u_psnr = 0
#         v_psnr = 0
#         bitrate = 0
#         cout = 0
#         with open(file) as file_object:
#             lines = file_object.readlines()
#         for line in lines:
#             if re.match('^P_SLICE.',line): 
#                 element  = line.split(",")
#                 y_psnr  += float(element[4])
#                 u_psnr  += float(element[5])
#                 v_psnr  += float(element[6])
#                 bitrate += float(element[8])
#                 cout += 1
#         with open("result_temp.csv","a") as file_object:
#             if cout != 0:
#                 file_object.write(str(bitrate/cout) +",")
#                 file_object.write(str(y_psnr /cout) +",")
#                 file_object.write(str(u_psnr /cout) +",")
#                 file_object.write(str(v_psnr /cout) +",")
#                 file_object.write(str(file)+"\n")

# #sort
# with open("result.csv","w") as file_object:
#     file_object.write("bitrate(kb/s) , psnr(Y) , psnr(U) , psnr(V) , Sequence\n")

# for file_name in file_list:
#     with open("result_temp.csv") as file_read:
#         lines = file_read.readlines()
#         for line in lines:
#             if re.match(r'.*?%s\_'%(file_name),line):
#                 print(line)
#                 with open("result.csv","a") as file_write:
#                     file_write.write(line)

# os.remove("result_temp.csv")  
