#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: |
  - run ENIGMA_plots.R in docker to get basic statistics from volume measures 
  
requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/r-subcortical"
  - class: InlineJavascriptRequirement


class: CommandLineTool

inputs:
  - id: sub_volumes
    type: File
    inputBinding:
      position: 1

  - id: stat_file_name
    type: string
    inputBinding:
      position: 2

outputs:
  - id: summary_state
    type: File
    outputBinding:
      glob: $(inputs.stat_file_name)

baseCommand: ["Rscript", "/usr/local/src/ENIGMA_plots.R"]
label: cwltool --debug subcorticalStat.cwl  --sub_volumes subcortical_volume --stat_file_name summary_stat

