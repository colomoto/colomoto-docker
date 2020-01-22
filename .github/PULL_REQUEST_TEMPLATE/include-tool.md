
[TIP]:  # ( Title above ^^ of the form "Include tool <TOOL NAME>" )

[NOTE]: # ( Provide a short description of the tool )

The image can be tested using
```
colomoto-docker -V pr<PULL REQUEST ID>
```

## Checklist
[NOTE]: # ( Please go over all the following points. )
[NOTE]: # ( Remove any lines which don't apply. )
[NOTE]: # ( Uncheck missing items if you need help completing them )
- [X] The conda package is added in one of the 3 install section of `Dockerfile` **[REQUIRED]**
- [X] There is at least one tutorial notebook in `tutorials/<tool>` folder **[REQUIRED]**
- [X] Tutorial notebooks are referenced in `validate.sh` **[REQUIRED]**
- [ ] Tool is referenced in the README.md file
