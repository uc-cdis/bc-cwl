#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: |
  - run ENIGMA_plots.R in docker to get basic statistics from volume measures 
  
requirements:
  - class: DockerRequirement
    dockerPull: "bids/antscorticalthickness"
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.input_BIDS_dir.basename)
        entry: $(inputs.input_BIDS_dir)
        writable: true
      - entryname: $(inputs.output_dir)
        entry: '$({"class":"Directory","basename":inputs.output_dir,"listing": []})'
        writable: true
  
  
class: CommandLineTool

inputs:
  - id: input_BIDS_dir
    type: Directory
    inputBinding:
      position: 1

  - id: output_dir
    type: string
    inputBinding:
      position: 2

  - id: analysis_level
    type: string
    inputBinding:
      position: 3

  - id: sub_label
    type: string
    inputBinding:
      position: 4
      prefix: --participant_label

outputs:
  - id: out_dir
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)/sub-$(inputs.sub_label)

baseCommand: []
label: cwltool --debug BIDS_ACT.cwl --input_BIDS_dir Balloon_Analog_Risk-taking_Task --output_dir ACT_output --analysis_level participant --sub_label 01

