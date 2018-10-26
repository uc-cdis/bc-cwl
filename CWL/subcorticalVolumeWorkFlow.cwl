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
  subcortical_volume_fileName: string 
  stat_file: string
  outlier_file: string

outputs:
  final_sub_dir:
    type: Directory
    outputSource: cp_FS_result2subDir/out_dir
    
  subcortical_vol_file:
    type: File
    outputSource: ex_subcortical/subfields_volume
    
  subcortical_outlier_file:
    type: File
    outputSource: find_outlier/outlier_log

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
        
  ex_subcortical:
    run: extract_subcortical.cwl
    in: 
      subDir: cp_FS_result2subDir/out_dir
      subject_list: sub_list_file
      subcortical_subfields: subcortical_volume_fileName      
    out: [subfields_volume]
    
  subcorStat:
    run: subcorticalStat.cwl
    in: 
      sub_volumes: ex_subcortical/subfields_volume
      stat_file_name: stat_file
    out: [summary_state]
    
  find_outlier:
    run: subCorticalOutlier.cwl
    in: 
      summaryStat: subcorStat/summary_state
      subcortical_volumes: ex_subcortical/subfields_volume
      outlier: outlier_file
    out: [outlier_log]
    
    
label: cwltool --debug  subcorticalVolumeWorkFlow.cwl  --c_file credentials.json --p_id bhc-cnp-open-fmri --s_id sub-10228 --img_out_dir results --sub_dir subjectDir --sub_dir_temp subjectDir_temp --sub_list_file list_subjects.txt --subcortical_volume_fileName out_subcortical_volume --stat_file summaryStat --outlier_file outlier_detail

