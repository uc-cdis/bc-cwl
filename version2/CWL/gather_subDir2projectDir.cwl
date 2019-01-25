#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.destination_dir.basename)
        entry: $(inputs.destination_dir)
        writable: true

baseCommand: [mv]


inputs:
  dirIn:
    type: Directory[]
    inputBinding:
      position: 1
      
  destination_dir:
    type: Directory
    inputBinding:
      position: 2

outputs:
  result_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.destination_dir.basename)

