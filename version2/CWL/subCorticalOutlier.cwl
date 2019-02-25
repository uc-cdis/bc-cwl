#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: |
  - run outlierDetection.sh in docker
  
requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/freesurferhipposub"
  - class: InlineJavascriptRequirement



class: CommandLineTool

inputs:


  - id: summaryStat
    type: File
    inputBinding:
      position: 1
      
  - id: subcortical_volumes
    type: File
    inputBinding:
      position: 2

  - id: outlier
    type: string
    inputBinding:
      position: 3

outputs:
  - id: outlier_log
    type: File
    outputBinding:
      glob: $(inputs.outlier)

baseCommand: [/mnt/outlierDetection.sh]
label: cwltool --debug subCorticalOutlier.cwl  --summaryStat SummaryStats.txt --subcortical_volumes LandRvolumes.csv --outlier outlier_detail

