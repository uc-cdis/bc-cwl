# Brain analysis pipeline

Brain analysis pipeline pulls human MRI scans from the [Brain
Commons](https://data.braincommons.org/), performs post-processing and
calculations, and returns measures of the subfields of the human brain regions.
It allows to calculate hippocampal subfield volumes and subcortical volumes.

## Setup

The pipeline pulls python and environment images from quay.io/cdis. The
pipeline configuration and setup scripts are stored in the CWL directory, you
can copy them to your working directory.

### Dependencies

 - `cwltool`
 - `Docker`

### Recommended

 - `tmux` or similar tool allowing session management

### CWL tool Setup

The official cwltool installation page can be found
[here](https://github.com/common-workflow-language/cwltool/blob/master/README.rst).
It is highly recommended to install cwltool in the virtual environment as it is
indicated in the installation page.

### Docker Setup

This pipeline uses Docker to pull python and FreeSurfer image. The official
Docker installation page can be found
[here](https://docs.docker.com/install/#supported-platforms). Docker
[documentation](https://docs.docker.com/) is a good source of information to
familiarize yourself with containers.

### Session management with tmux

It takes several hours to execute this pipeline, it is recommended to use a
tool allowing to disconnect and connect to the server without interrupting the
pipeline. `tmux` and `screen` are examples of tools that keep your session
persistent. You can install tmux on Ubuntu with `sudo apt-get install tmux` and
on Mac with `brew install tmux`. The [official tmux
page](https://github.com/tmux/tmux/wiki) provides helpful links to guides to
tmux.

### Setting up Credentials

The brain analysis pipeline also requires credentials from the [Brain
Commons](https://data.braincommons.org/) in your working directory.  If you
already have a `credentials.json` file from the [Brain
Commons](https://data.braincommons.org/), just copy it to your working
directory. If you don't have this file, go to the [Brain
Commons](https://data.braincommons.org/), log in with your Google account,
click on the `Profile` link and then click on `Create API key` button. A new
window will pop up with your API key, click on `Download json` button and save
it in your working directory.

## Configuration

Parameters for the pipeline are controlled using *.yml files. Below you'll find
a description of parameters for hippocampal analysis in the
`hippo_sub_workflow_v2_input.yml`:

  - `c_file1` - the path to your credentials file

  - `p_id1` - project id in the [Brain Commons](https://data.braincommons.org/)

  - `s_id1` - list of MRI scans from the project

  - `img_out_dir1` - output directory for images

  - `hippo_sub_volume_fileName` - the filename of the output file containing
   volumes of the subfields of the hippocampal formations

Analogous parameters can be configured for subcortical workflow in the
`subcortical_volume_workflow_v2_input.yml`.

## Start running Brain analysis pipeline

1. Download all files in CWL folder to your working directory

2. Download credentials.json file to your working directory (see [Setting up
Credentials](#Setting-up-Credentials))

3. Start a new session with command `tmux` or `tmux new -s
  your_session_name`

4. Activate your virtual environment with CWL installed:

    ```bash
    source your_venv_name/bin/activate
    ```

5. To run the hippocampal subfield CWL workflow:

    ```bash
    cwl-runner --debug hippo_sub_workflow_v2.cwl hippo_sub_workflow_v2_input.yml
    ```

   To run the subcortical volume workflow:

    ```bash
    cwl-runner --debug subcortical_volume_workflow_v2.cwl subcortical_volume_workflow_v2_input.yml
    ```

