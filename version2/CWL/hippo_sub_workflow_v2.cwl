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
  hippo_sub_volume_fileName: string

  
outputs:
  final_project_dir:
    type: Directory
    outputSource: gather_result_dir/result_dir
   
  hippo_sub_vol_file:
    type: File
    outputSource: ex_sub_vol/subfields_volume 
 
steps:
  subworkflow1:
    run: hippo_sub_workflow_part1.cwl
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
  
  ex_sub_vol:
    run: extract_subfields_volume.cwl
    in: 
      subDir: gather_result_dir/result_dir
      hippo_subfields: hippo_sub_volume_fileName 
      subject_list: s_id1     
    out: [subfields_volume]