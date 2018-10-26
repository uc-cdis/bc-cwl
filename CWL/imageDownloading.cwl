cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerImageId: python3/downloadimg
  - class: InitialWorkDirRequirement
    listing:
      - entry: '$({"class": "Directory", "basename": inputs.output_dirname, "listing": []})'
        entryname: $(inputs.output_dirname)
        writable: true  

baseCommand: ["python", "/downloadImage.py"]

inputs:
  credential_file:
    type: File
    inputBinding:
      prefix: -c
      
  project_id:
    type: string
    inputBinding:
      prefix: -p
      
  subject_id:
    type: string
    inputBinding:
      prefix: -sub
      
  output_dirname:
    type: string
    inputBinding:
      prefix: -o


outputs:
  image_path:
    type: File
    outputBinding:
      glob: $(inputs.output_dirname+'/' + inputs.project_id + '/' + inputs.subject_id + '_T1w.nii.gz')

label: cwltool --debug imageDownloading.cwl   --credential_file credentials.json  --project_id bhc-cnp-open-fmri  --subject_id sub-10228 --output_dirname results