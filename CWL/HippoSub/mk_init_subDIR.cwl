#!/usr/bin/env cwl-runner

cwlVersion: v1.0


requirements:
  - class: DockerRequirement
    dockerImageId: brainlife/freesurferhipposub
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: '$({"class": "Directory", "basename": inputs.subject_dir, "listing": []})'
        entryname: $(inputs.subject_dir)
        writable: true  

class: CommandLineTool

inputs:
  - id: subject_dir
    type: string
    inputBinding:
      position: 1
  

  
outputs:
  - id: init_subDir
    type: Directory
    outputBinding:
      glob: $(inputs.subject_dir)

baseCommand: [/mnt/initialize_subDir.sh]
