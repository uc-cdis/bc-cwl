#from scipy import stats
#import statsmodels.api as sm
#import matplotlib.pyplot as plt
#import matplotlib.patches as patches
#import matplotlib.image as mpimg
#from scipy.stats import ranksums
import pandas as pd
import numpy as np
import datetime
import requests
import glob
import json
import os
from utils import utils
#from operator import add
#from scipy.stats import expon
#from pydoc import help
#from scipy.stats.stats import pearsonr



import getopt
import argparse

import time
import json
import os.path
parser = argparse.ArgumentParser(description="downloadImageFile")
parser.add_argument('-c', '--credentials', required=True, help='credential file for downloading')
parser.add_argument('-p', '--project', required=True, help='project ID')
parser.add_argument('-sub', '--subject', required=True, help='subject ID')
parser.add_argument('-o', '--outDir', required=True, help='output directory')

args = parser.parse_args()
api_url = 'https://data.braincommons.org/'
def add_keys(filename):
    ''' Get auth from our secret keys '''

    global auth 
    json_data=open(filename).read()
    keys = json.loads(json_data)
    auth = requests.post(api_url + 'user/credentials/cdis/access_token', json=keys)
    
def query_api(query_txt, variables = None):
    ''' Request results for a specific query '''

    if variables == None:
        query = {'query': query_txt}
    else:
        query = {'query': query_txt, 'variables': variables}        
    
    output = requests.post(api_url + 'api/v0/submission/graphql', headers={'Authorization': 'bearer '+ auth.json()['access_token']}, json=query).text
    data = json.loads(output)    
    
    if 'errors' in data:
        print(data)   
    
    return data 

def run_freesurfer_test(project_id, subject_id, outDir,mri_type = "T1-weighted"):
    ''' Run FreeSurfer for ENIGMA cortical pipeline'''

    # Query data
    query_txt = """query {
                      case(project_id: "%s", submitter_id: "%s"){
                         mri_exams(scan_type: "%s"){
                            mri_images{
                               id
                               file_name
                            }
                         }
                      }
                }""" % (project_id, subject_id, mri_type)
    
    data = query_api(query_txt)
    # Get file from S3
    filename = data['data']["case"][0]['mri_exams'][0]['mri_images'][0]['file_name']
    fileid =  data['data']["case"][0]['mri_exams'][0]['mri_images'][0]['id']
    
    #localpath = utils.get_file_from_s3(filename, project_id)
    localpath = outDir+'/' + project_id + '/' + filename
    if not os.path.exists(outDir):
        os.mkdir(outDir)
        os.mkdir(outDir+'/' + project_id)
    elif os.path.exists(outDir) and not os.path.exists(outDir+'/' + project_id):
        os.mkdir(outDir+'/' + project_id)
    response = utils.download_file(auth, api_url, fileid, localpath)
    inputPath=(localpath[2:]).encode("ascii")
    return(inputPath)
add_keys(args.credentials)
#print (run_freesurfer_test('bhc-cnp-open-fmri','sub-10228'))
run_freesurfer_test(args.project,args.subject,args.outDir)
#python downloadImage.py -c credentials.json  -p bhc-cnp-open-fmri -sub sub-10228 -o results