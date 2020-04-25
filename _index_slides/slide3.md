---
---

## Extending the CoLoMoTo Docker

You can easily extend the CoLoMoTo Docker image to integrate your own tool and distribute it as its own Docker image, using a `Dockerfile` skeleton like this:
```
FROM colomoto/colomoto-docker:next

USER root
RUN <insert installation instructions>

USER user
```
You may want to replace `next` with any other suitable [colomoto/colomoto-docker tag](https://github.com/colomoto/colomoto-docker/releases). You should also consider using a [persistent tagging policy](https://github.com/colomoto/colomoto-docker#tagging-policy-and-re-executability-considerations). 

The Dockerfile can be built using the command

    docker build -t your-docker-image:your-tag .

The script `colomoto-docker` can then be used to run your own Docker image:

    colomoto-docker --image your-docker-image -V your-tag


## Contribute

Contributions are very welcome, being for adding new software or improving the user experience.

Consider opening an [issue on GitHub](https://github.com/colomoto/colomoto-docker/issues) and reading the 
[CONTRIBUTING](https://github.com/colomoto/colomoto-docker/blob/master/CONTRIBUTING.md) guidelines.

