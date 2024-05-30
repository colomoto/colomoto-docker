# Adding your tool

## General considerations

- **The software should integrate well in the Jupyter interface**: 
The software shoud be usable from the Jupyter notebook framework.
Typically, this can be achieved by developping a Python module which will perform the adequate commands.
But Python is not the only option as Jupyter offers alternative *kernels*, notably R.
Depending on your software, having a menu to help users input valid commands can also be a plus.
If are using a Python interface, you may have a look at
the [colomoto_jupyter](https://github.com/colomoto/colomoto-jupyter) module.

- **The software should connect with at least one other tool already in the Docker**:
Basically, there should be a way to design a notebook which involves the new software with an already integrated one.
It means that either your software can take input from another tool, or that your software can output
results which can serve as input to another tool.

## Integrating a new tool

We describe here the recommended procedure to integrate a new tool in the CoLoMoTo docker image.
See the [Recipes](#Recipes) section for additional help.

### Stage 0: extend the Docker image


Before modiying the main `Dockerfile` of the project, it is more efficient to build a new Docker image which inherits from the `colomoto/colomoto-docker` image. This can be done by creating a `Dockerfile` which will looks like this:

```Dockerfile
FROM colomoto/colomoto-docker:next

USER root
RUN <insert installation instructions>

USER user
```

It will allow you to make quick tests for integrating your software in the Docker and ensure that it runs correctly with the appropriate dependencies.


### Stage 1: create a conda package

To ease the management of the diverse dependencies of the software tools in the Docker, we rely on 
[Conda](http://conda.org) package manager.
It is therefore required that you provide a conda package for your software.
You can see some examples of conda recipes at https://github.com/colomoto/colomoto-conda and https://github.com/colomoto/colomoto-jupyter for instance.

If you already provide binary distribution for your tool, building a conda recipe is usually straightforward; the only matter is to indicate the dependencies with relevant constraints on their versions.

### Stage 2: create a short demo notebook

To demonstrate basic usage of the new software and its integration in the Jupyter notebook, we request you provide a short notebook example.
In addition to describing how using the main features of the software, the notebook should show how it can be related to other tools available in the Docker image.

The notebook will also serve to validate built Docker images by ensuring it can be executed properly.

### Stage 3: create a pull request

It is now time to modify the files of the colomoto-docker repository:
* [ ] Update the Dockerfile to include the conda package with its exact version. <br>
There are 3 `RUN` sections related to conda package installation, which depend on the expected frequency of version updates (the first section being the less frequently updated).
* [ ] Add the demo notebook in the `tutorials` folder, in a subfolder named after your tool.
* [ ] Include the notebook path in the `validate.sh` file.
* [ ] Build locally the Docker image and validate it (see [Recipes](#Recipes))
* [ ] Create a pull request with the `tool request` label


## Upgrading an existing software tool

Embedded tools are automatically upgraded following the conda package updates.


## Recipes

### Build the docker image
In the `colomoto-docker` directory, do
```
docker build -t colomoto/colomoto-docker:local .
```
Here, `local` is just a suggestion of tag you may want to use.

### Run the docker image for notebook editing
In the `colomoto-docker` directory, do
```
colomoto-docker -V [tag] --bind .
```
where `[tag]` is usually `local` for the image you built locally, or `next` for the pre-release image.

### Validate a docker image
```
colomoto-docker -V [tag] validate.sh
```
where `[tag]` is usually `local` for the image you built locally, or `next` for the pre-release image.
