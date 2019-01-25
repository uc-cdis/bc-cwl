#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: |
  - run extract_subcortical.sh in docker
  
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

  - id: subcortical_subfields
    type: string
    inputBinding:
      position: 3

outputs:
  - id: subfields_volume
    type: File
    outputBinding:
      glob: $(inputs.subDir.basename)/$(inputs.subcortical_subfields)

baseCommand: [/mnt/extract_subcortical.sh]
label: cwltool --debug extract_subcortical.cwl  --subDir subjectDir --subject_list list_subjects.txt --subcortical_subfields out_subcortical_volume
