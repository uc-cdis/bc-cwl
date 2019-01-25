#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/freesurferhipposub"
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
      outputEval: |
        ${
           var curr = {"class": "Directory", "path": inputs.subDir.basename + '/' + inputs.subject}
           return(curr)
         }

 
baseCommand: [recon-all]
label: cwltool --debug FS_hippo_sub.cwl --subject subj10159 --subDir subjectDir
