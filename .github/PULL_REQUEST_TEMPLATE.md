
[TIP]:  # ( PR including a tool: set the title above ^^ with the form "Include tool <TOOL NAME>" )

[NOTE]: # ( PR including a tool: provide a short description of the tool )

The image can be tested using
```
colomoto-docker -V pr<PULL REQUEST ID>
```

[NOTE]: # ( Checklist for including a new tool, remove if it is not appropriate )
## Checklist
[NOTE]: # ( Please go over all the following points. )
[NOTE]: # ( Remove any lines which don't apply. )
[NOTE]: # ( Uncheck missing items if you need help completing them )
- [X] The conda package is added in one of the 3 install section of `Dockerfile` **[REQUIRED]**
- [X] There is at least one tutorial notebook in `tutorials/<tool>` folder **[REQUIRED]**
- [X] Tutorial notebooks are referenced in `validate.sh` **[REQUIRED]**
- [X] Tool is referenced in the `hooks/release_changes.json` **[REQUIRED]**
- [ ] Tool is referenced in the `tools/index.md` file
- [ ] Tool has `tools/{package-name}.md` file (from `tools/TEMPLATE.md`)
