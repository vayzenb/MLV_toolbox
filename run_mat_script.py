curr_dir = '/user_data/vayzenbe/GitHub_Repos/MLV_toolbox'
import sys
sys.path.append(curr_dir)
import os
import subprocess
from glob import glob as glob

import pdb


script_name = 'convert_to_linedrawings.m'

input_dir = '/user_data/vayzenbe/image_sets/kornet_images'
output_dir = '/user_data/vayzenbe/image_sets/outline_kornet'

folders = glob(input_dir + '/*/')

for folder in folders:
    #remove last slash
    folder = folder[:-1]
    folder_name = folder.split('/')[-1]

    bash_cmd = f"matlab -batch \"convert_to_linedrawings('{folder}','{output_dir}/{folder_name}')\""
    subprocess.run(bash_cmd, shell=True)
    break

    


