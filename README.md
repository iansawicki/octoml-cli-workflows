# GitHub CI/CD with OctoML CLI

The [OctoML CLI](https://try.octoml.ai/cli) allows you to easily package your model into a
deployable container, which can then be deployed onto a local Docker instance, or a cloud
provider such as AWS.

This project contains example GitHub CI/CD workflow that make use of the OctoML CLI. 
Whenever you commit a newly trained model or change in pre/post-processing code to a branch
in your GitHub repository, your CI workflow can automatically validate end-to-end inference 
on the new changes locally. You can also use the OctoML CLI in a CD context, such that every
push to a `main` branch triggers OctoML to optimize the model for cheaper and lower-latency
inference on the cloud. After optimization, the CLI also builds a container and directly 
pushes the container into a Docker registry for cloud deployment.

## Workflows and Jobs

There are two jobs in the current workflows:
- **Local** jobs enable you to quickly deploy a model and test inferences end-to-end.
  These jobs package the model and deploy an inference-ready container to a local 
  Docker instance. Test programs call the inference 
  endpoint in the local Docker instance. Because local jobs never upload your model to the
  OctoML platform, some OctoML features (such as inference cost savings) are not available.
  Below is more detail on what each OctoML CLI command in the local job does:
  
  `octoml package`: Packages the models specified in the `octoml.yaml` file into a 
  Docker tarball that's ready to be built into an image on any machine that has Docker installed. 

  `octoml build`: Builds a deployment-ready Docker image from the specified tarball(s). 

  `octoml deploy`: Deploys a Docker container to a locally hosted endpoint.
  
  The diagram below shows an overview of the user journey for Local jobs: ![Local UX](/workflow-diagrams/Local-job.png)

- **Cloud** jobs package your model using the OctoML Platform, which lowers the inference
  latency of the model and **reduces your compute costs** when the model is used in 
  production. Cloud jobs also deploy the container to cloud providers.

  - `octoml package` and `octoml build` are used, as in the Local jobs. The main difference is the 
    addition of the `-a` flag when calling these commands, which requests OctoML
    to optimize the model's cost per inference and latency on cloud hardware.
  - In this example, the container is pushed to the GitHub Container Registry. Your existing deployment 
    infrastructure may look different and go beyond pushing to the registry. Feel free to add another 
    step in the Cloud job for deploying a container from the registry to generate a remote endpoint,
    using your preferred downstream cloud service (e.g. AzureML, AKS).
  - The diagram below shows an overview of the user journey for Cloud jobs: ![Cloud UX](/workflow-diagrams/Cloud-job.png)
 
Refer to the [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
for more detailed information about the CLI.

## Configuring the Workflow for Use with Your Model and Your Infrastructure

This repository uses local jobs in a CI context, where the model is packaged, deployed and
tested locally on every push to a non-`main` branch. Cloud jobs are used in a CD context,
where on every push to `main`, or a pull request is merged into `main`, the model is
packaged and accelerated using the OctoML Platform.

The model we use in this example is `yolov5s` and the path to it is 
`~/model-data/yolov5s/yolov5s.onnx`. We also use an image (`~/model-data/yolov5s/cat.jpg`)
to show that we can make inferences against the deployed model in `local-example.yml`.

To use this workflow on your custom use case, add a different model and sample test input(s)
for inference to the GitHub repo.

### Editing the Workflow

#### Local Jobs

Ensure you have the following requirements for local jobs in your repo:

- The model file (in ONNX, TensorFlow SavedModel, TensorFlow Graphdef, or Torchscript format).
- The `octoml.yaml` file. Make sure you update the `octoml.yaml` file to include information about your model.
Minimally, the model name and the path to the model must be provided. If your model is of TensorFlow Graphdef/Torchscript
format and has dynamic input shapes, you must also specify the input shapes.

Then, edit the `Run deployment and inference` step of the `local-example.yml` file to include any 
inference code specific to your model.

#### Cloud Jobs

Ensure you have the following requirements for cloud jobs in your repo:

- The model file (in ONNX, TensorFlow SavedModel, TensorFlow Graphdef, or Torchscript format).
- `OCTOML_ACCESS_TOKEN` must be present in the environment. Obtain one by 
  signing up for an OctoML account in the bottom of this [page](https://try.octoml.ai/cli/), then
  generating a token on your [Account Dashboard](https://app.octoml.ai/account/settings) on the OctoML Platform.
  Afterwards, [add your token as a Github Environment Variable](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository).
- The `octoml.yaml` file. Make sure you update the `octoml.yaml` file to include information about your model.
  Minimally, the model name and the path to the model must be provided. If your model is dynamically shaped,
  you also need to specify the model's input shapes. Additionally, the `hardware` key must be 
  present since it specifies the hardware target you want OctoML to optimize the model for.

If you use a container registry outside of GitHub, you may also wish to revise the section in `cloud-example.yml`
where the Docker image produced by the OctoML CLI is pushed to the GitHub container registry.

### Editing Triggers to Use Local or Cloud Jobs

In this example, local jobs start whenever there is a push to any non-`main` branches.
Cloud jobs start whenever there is a push to any `main` branches.

Edit the `on` clause in each job or workflow to control how the jobs are run. Refer to
[GitHub’s documentation](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow) 
for more information.

## Resources and Additional Links

- [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
- [Triton Client Libraries and Examples](https://github.com/triton-inference-server/client)
- [Workflows for this Repository](https://github.com/octoml/octoml-cli-workflows/actions)
