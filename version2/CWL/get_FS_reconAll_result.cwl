#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  c_file: File
  p_id: string
  s_id: string
  img_out_dir: string



outputs:
  final_sub_dir:
    type: Directory
    outputSource: fs_all/out_dir


steps:
  image_download:
    run: imageDownloading.cwl
    in:
      credential_file: c_file
      project_id: p_id      
      subject_id: s_id
      output_dirname: img_out_dir
    out: [image_path]
  
  fs_all:
    run: FS_all.cwl
    in: 
      subject: s_id
      input_img: image_download/image_path
      subDir_name: p_id
    out: [out_dir]

    

    

    
    
label: cwltool --debug  hippo_sub_workflow.cwl  --c_file credentials.json --p_id bhc-cnp-open-fmri --s_id sub-10228 img_out_dir results  --sub_dir_temp subjectDir_temp 
