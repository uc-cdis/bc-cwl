#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: |
  - asdfasdf
  - adafsdf
  - asdfasdf
  	
requirements:
  - class: DockerRequirement
    dockerImageId: brainlife/freesurferhipposub
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.subDir.basename)
        entry: $(inputs.subDir)
        writable: true


class: CommandLineTool

inputs:
  - id: subDir
    type: Directory
    inputBinding:
      position: 1

  - id: subject_list
    type: File
    inputBinding:
      position: 2

  - id: hippo_subfields
    type: string
    inputBinding:
      position: 3

outputs:
  - id: subfields_volume
    type: File
    outputBinding:
      glob: $(inputs.subDir.basename)/$(inputs.hippo_subfields)

baseCommand: [/mnt/extract_subfields.sh]
label: cwltool --debug extract_subfields_volume.cwl  --subDir subjectDir --subject_list list_subjects.txt --hippo_subfields out_subfields_volume
