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
  sub_dir: string
  sub_dir_temp: string
  sub_list_file: File
  hippo_sub_volume_fileName: string 

outputs:
  final_sub_dir:
    type: Directory
    outputSource: FS_hippoSub/sub_dir_with_hippoSub
    
  hippo_sub_vol_file:
    type: File
    outputSource: ex_sub_vol/subfields_volume

steps:
  image_download:
    run: imageDownloading.cwl
    in:
      credential_file: c_file
      project_id: p_id      
      subject_id: s_id
      output_dirname: img_out_dir
    out: [image_path]
  
  init_sub_dir:
    run: mk_init_subDIR.cwl
    in:
      subject_dir: sub_dir
    out: [init_subDir]
  
  fs_all:
    run: FS_all.cwl
    in: 
      subject: s_id
      input_img: image_download/image_path
      subDir_name: sub_dir_temp
    out: [out_dir]
    
  cp_FS_result2subDir:
    run: cp_dir2dir.cwl
    in: 
      kid_dir: fs_all/out_dir
      parent_dir: init_sub_dir/init_subDir
    out: [out_dir]
    
  FS_hippoSub:
    run: FS_hippo_sub.cwl
    in: 
      subject: s_id
      subDir: cp_FS_result2subDir/out_dir
    out: [sub_dir_with_hippoSub]
    
  ex_sub_vol:
    run: extract_subfields_volume.cwl
    in: 
      subDir: FS_hippoSub/sub_dir_with_hippoSub
      subject_list: sub_list_file
      hippo_subfields: hippo_sub_volume_fileName      
    out: [subfields_volume]
    
    
label: cwltool --debug  hippo_sub_workflow.cwl  --c_file credentials.json --p_id bhc-cnp-open-fmri --s_id sub-10228 img_out_dir results --sub_dir subjectDir --sub_dir_temp subjectDir_temp --sub_list_file list_subjects.txt --hippo_sub_volume_fileName out_hippo_sub_volume
