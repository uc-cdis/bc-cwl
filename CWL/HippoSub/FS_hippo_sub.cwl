#!/usr/bin/env cwl-runner

cwlVersion: v1.0

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
  - id: subject
    type: string
    inputBinding:
      prefix: -s

  - id: hippoSub
    type: boolean
    default: true
    inputBinding:
      prefix: -hippocampal-subfields-T1

  - id: subDir
    type: Directory
    inputBinding:
      prefix: -sd

outputs:
  - id: sub_dir_with_hippoSub
    type: Directory
    outputBinding:
      glob: $(inputs.subDir.basename)

 
baseCommand: [recon-all]
label: cwltool --debug FS_hippo_sub.cwl --subject subj10159 --subDir subjectDir
