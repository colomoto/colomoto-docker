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

## Citation

> Aurélien Naldi, Céline Hernandez, Nicolas Levy, Gautier Stoll, Pedro T Monteiro, Claudine Chaouiya, Tomáš Helikar, Andrei Zinovyev, Laurence Calzone, Sarah Cohen-Boulakia, Denis Thieffry, Loïc Paulevé.
> *The CoLoMoTo Interactive Notebook: Accessible and Reproducible Computational Analyses for Qualitative Biological Networks*.
> Frontiers in Physiology, 2018. | doi: [10.3389/fphys.2018.00680](http://doi.org/10.3389/fphys.2018.00680)



