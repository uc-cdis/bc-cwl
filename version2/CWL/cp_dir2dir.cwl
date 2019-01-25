#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/freesurferhipposub"
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.kid_dir.basename)
        entry: $(inputs.kid_dir)
        writable: true
      - entryname: $(inputs.parent_dir.basename)
        entry: $(inputs.parent_dir)
        writable: true

class: CommandLineTool

inputs:
  

  - id: kid_dir
    type: Directory
    inputBinding:
      position: 1
  
  - id: parent_dir
    type: Directory
    inputBinding:
      position: 2

outputs:
  - id: out_dir
    type: Directory
    outputBinding:
      glob: $(inputs.parent_dir.basename)

baseCommand: [cp, -r]
