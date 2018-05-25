---
---

## Extending the CoLoMoTo Docker

You can easily extend the CoLoMoTo Docker image to integrate your own tool and distribute it as its own Docker image:

```
FROM colomoto/colomoto-docker:next

USER root
RUN <insert installation instructions>

USER user
```
You may want to replace `next` with any other suitable [colomoto/colomoto-docker tag](https://hub.docker.com/r/colomoto/colomoto-docker/tags/).
You should also consider using a [persistent tagging policy](https://github.com/colomoto/colomoto-docker#tagging-policy-and-re-executability-considerations). 
The script `colomoto-docker` can then be used to run your own Docker image using `colomoto-docker --image your-docker-image`.


## Contribute

Contributions are very welcome, being for adding new software or improving the user experience.

Consider opening an [issue on GitHub](https://github.com/colomoto/colomoto-docker/issues) and reading the 
[CONTRIBUTING](https://github.com/colomoto/colomoto-docker/blob/master/CONTRIBUTING.md) guidelines.

