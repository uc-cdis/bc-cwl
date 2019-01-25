cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/freesurferhipposub"
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: '$({"class": "Directory", "basename": inputs.subDir_name, "listing": []})'
        entryname: $(inputs.subDir_name)
        writable: true 
class: CommandLineTool

inputs:
  - id: subject
    type: string
    inputBinding:
      prefix: -s

  - id: input_img
    type: File
    inputBinding:
      prefix: -i

  - id: running_option
    type: boolean
    default: true
    inputBinding:
      prefix: -all

  - id: subDir_name
    type: string
    inputBinding:
      prefix: -sd

outputs:
  - id: out_dir
    type: Directory
    outputBinding:
      glob: $(inputs.subDir_name)/$(inputs.subject)

baseCommand: [recon-all]
label: cwltool --debug FS_all.cwl --subject sub-10228 --input_img sub-10228_T1w.nii.gz  --subDir_name subDir
