# GitHub CI/CD with OctoML CLI

The [OctoML CLI](https://try.octoml.ai/cli) allows you to automatically optimize your ML models for
lowest cost per inference and best user experience. This project contains an example GitHub CI/CD workflow 
that makes use of the OctoML CLI. Whenever you commit a newly trained model or change in pre/post-processing 
code to `main`, the workflow triggers OctoML CLI to optimize the model 
for cheaper and lower-latency inference on the cloud. After optimization, the CLI also builds a container 
and directly pushes the container into a Docker registry for cloud deployment.

## Workflow and Jobs
- The cloud-example.yml file specifies jobs that use the OctoML CLI to optimize your model for cloud inference.

  - `octoml package -a`: Requests OctoML to optimize your model's cost per inference and latency on cloud hardware.
     Packages the model into a  Docker tarball that's ready to be built into an image on any machine that has Docker installed.
  - `octoml build`: Builds a deployment-ready Docker image from the specified tarball(s). 
  - In this example, the built container is then pushed to the GitHub Container Registry. Your existing deployment 
    infrastructure may look different and go beyond pushing to the registry. Feel free to add another 
    step in the Cloud job for deploying a container from the registry to generate a remote endpoint,
    using your preferred downstream cloud service (e.g. AzureML, AKS).
  - The diagram below shows an overview of the user journey for Cloud jobs: ![Cloud UX](/workflow-diagrams/Cloud-job.png)
 
Refer to the [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
for more detailed information about the CLI.

## Configuring the Workflow for Use with Your Model and Your Infrastructure

The model we use in this example is `yolov5s` and the path to it is 
`~/model-data/yolov5s/yolov5s.onnx`. To use this workflow on your custom use case, 
add a different model and sample test input(s) for inference to the GitHub repo.

Ensure you have the following requirements in your repo:

- The model file (in ONNX, TensorFlow SavedModel, TensorFlow Graphdef, or Torchscript format).
- `OCTOML_ACCESS_TOKEN` must be present in the environment. Obtain one by 
  signing up for an OctoML account [here](https://octoml.ai/contact-sales/), then
  generating a token on your [Account Dashboard](https://app.octoml.ai/account/settings) on the OctoML Platform.
  Afterwards, [add your token as a Github Environment Variable](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository).
- The `octoml.yaml` file. Make sure you update the `octoml.yaml` file to include information about your model.
  Minimally, the model name and the path to the model must be provided. If your model is dynamically shaped,
  you also need to specify the model's input shapes. Additionally, the `hardware` key must be 
  present since it specifies the hardware target you want OctoML to optimize the model for.

If you use a container registry outside of GitHub, you may also wish to revise the section in `cloud-example.yml`
where the Docker image produced by the OctoML CLI is pushed to the GitHub container registry.

Your can trigger our example workflow upon every push to `main` or merge of a pull request into `main`. 
If you want to change the trigger, edit the `on` clause in each job or workflow. Refer to
[GitHub’s documentation](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow) 
for more information.


## Resources and Additional Links

- [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
- [Triton Client Libraries and Examples](https://github.com/triton-inference-server/client)
- [Workflows for this Repository](https://github.com/octoml/octoml-cli-workflows/actions)
