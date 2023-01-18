# GitHub CI/CD with OctoML CLI

The [OctoML CLI](https://try.octoml.ai/cli) allows you to easily package your model into a
deployable container, which can then be deployed onto a local Docker instance, or a cloud
provider such as AWS.

This project contains example GitHub CI/CD pipelines that make use of the OctoML CLI. We show how the CLI is used in a CI context, where your Machine Learning model is deployed and
tested locally, and in a CD context, where the container created by the CLI is
directly pushed into a Docker registry and then deployed on the cloud.

## Pipeline and Jobs

There are two jobs in the current pipeline:
- **Local** jobs enable you to quickly deploy a model and test inferences end-to-end.
  These jobs package the model and deploy an inference-ready container to a local 
  Docker instance. Test programs call the inference 
  endpoint in the local Docker instance. Because local jobs never upload your model to the
  OctoML platform, some OctoML features (such as inference cost savings) are not available.

- **Cloud** jobs package your model using the OctoML Platform, which lowers the inference
  latency of the model and **reduces your compute costs** when the model is used in 
  production. Cloud jobs also deploy the container to cloud providers. Test programs 
  call the inference endpoint in the deployed Docker instance.

  - In this example, the container is pushed to the GitHub Container Registry.
  - Your deployment needs and setup will likely go beyond this; refer to the Configuring the 
    Pipeline for Use with Your Model and Your Infrastructure section below for more 
    information about configuration.

## Configuring the Pipeline for Use with Your Model and Your Infrastructure

This repository uses local jobs in a CI context, where the model is packaged, deployed and
tested locally on every push to a non-`main` branch. Cloud jobs are used in a CD context,
where on every push to `main`, or a pull request is merged into `main`, the model is
packaged and accelerated using the OctoML Platform.

The model we use in this example is `yolov5s` and the path to it is 
`~/model-data/yolov5s/yolov5s.onnx`. We also use an image (`~/model-data/yolov5s/cat.jpg`)
to show that we can make inferences against the deployed model in `local-example.yml`.

To use this pipeline on your custom use case, add a different model and sample test input(s)
for inference to the Gitlab repo.

### Preparing Model to be Packaged by the OctoML CLI

Start by updating the `octoml.yaml` file to include information about your model.
Minimally, the model name and the path to the model must be provided. 

Refer to the [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
for information.

### Editing the Pipeline

#### Local Jobs

These are the requirements for local jobs:

- The model file (in ONNX, TensorFlow SavedModel, TensorFlow Graphdef, or Torchscript format).
- The `octoml.yaml` file.

Edit the `Run deployment and inference` step of the `local-example.yml` file to include any 
inference code specific to your model..

#### Cloud Jobs

If you wish to use cloud jobs, there are a few requirements:

- The model file (in ONNX, TensorFlow SavedModel, TensorFlow Graphdef, or Torchscript format).
- To package the model and take advantage of the acceleration the OctoML Platform
  provides, `OCTOML_ACCESS_TOKEN` must be present in the environment. Obtain one in the
  [Account Dashboard](https://app.octoml.ai/account/settings) on the OctoML Platform.
  Then [add your token as a Github Environment Variable](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository).
- The `octoml.yaml` file. Specifically, the `hardware` key must be present since it
  specifies the hardware target the model will run on. This enables the OctoML Platform to
  find the best achievable degree of acceleration.

Edit the `octoml.yaml` file and adjust the adjust the parameters used to call `cloud-example.yml`. 
You may wish to revise the section in `cloud-example.yml` where the Docker image produced by 
the OctoML CLI is pushed to the container registry and adapt it to your setup.

### Editing Triggers to Use Local or Cloud Jobs

You may wish to specify which job gets triggered.

In this example, local jobs start whenever there is a push to any non-`main` branches.
Cloud jobs start whenever there is a push to any `main` branches.

Edit the `on` clause in each job or pipeline to control how the jobs are run. Refer to
[GitHub’s documentation](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow) 
for more information.

## Resources and Additional Links

- [OctoML CLI Tutorials and Documentation](https://github.com/octoml/octoml-cli-tutorials)
- [Triton Client Libraries and Examples](https://github.com/triton-inference-server/client)
- [Pipelines for this Repository](https://github.com/octoml/octoml-cli-workflows/actions)
