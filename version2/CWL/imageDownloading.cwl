cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: "quay.io/cdis/py-bc-pipeline"
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

stdout: file_path

outputs:
  image_path:
    type: File
    outputBinding:
      glob: file_path
      loadContents: true
      outputEval: |
        ${
          var img_path = self[0].contents.trim()
          return {"class": "File", "path": img_path}
        }
    

label: cwltool --debug imageDownloading.cwl   --credential_file credentials.json  --project_id mjff-training  --subject_id t1-image-04 --output_dirname results