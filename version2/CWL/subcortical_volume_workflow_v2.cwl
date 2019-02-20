#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  c_file1: File
  p_id1: string
  s_id1: string[]
  img_out_dir1: string
  subcortical_volume_fileName: string 
  stat_file: string
  outlier_file: string

  
outputs:
  final_project_dir:
    type: Directory
    outputSource: gather_result_dir/result_dir
   
  subcortical_vol_file:
    type: File
    outputSource: ex_subcortical/subfields_volume
    
  subcortical_outlier_file:
    type: File
    outputSource: find_outlier/outlier_log
 
steps:
  subworkflow1:
    run: get_FS_reconAll_result.cwl
    in:
      c_file: c_file1
      p_id: p_id1
      s_id: s_id1
      img_out_dir: img_out_dir1
          
    scatter: s_id
    scatterMethod: dotproduct
    out: [final_sub_dir]
  
  init_final_dir:
    run: mk_init_subDIR.cwl
    in:
      subject_dir: p_id1
    out: [init_subDir]  
    
  gather_result_dir:
    run: gather_subDir2projectDir.cwl
    in:
      dirIn: subworkflow1/final_sub_dir
      destination_dir: init_final_dir/init_subDir
    out: [result_dir]
  
  ex_subcortical:
    run: extract_subcortical.cwl
    in: 
      subDir: gather_result_dir/result_dir
      subcortical_subfields: subcortical_volume_fileName 
      subject_list: s_id1      
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