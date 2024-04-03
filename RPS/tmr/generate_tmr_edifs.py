from lib import *


import os
for file in os.listdir("./input_edifs"):
    if file.endswith(".edf"):
        print(file)
        name = os.path.splitext(file)[0]
        print(name)
        if (os.path.exists("./output_edifs/"+name+"_tmr.edf")):
            print("TMR edf exsits!")
        else:
            print("TMR edf needs to be generated!")
            generate_tmr("./input_edifs/"+file,"./output_edifs/"+name+"_tmr.edf")
            print("generated")