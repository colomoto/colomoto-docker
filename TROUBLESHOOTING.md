# Troubleshooting

This page collects common issues arising with the installation and use of the CoLoMoTo docker image.

## Errors during pip install

* `pip install -U colomoto-docker` fails with the following error, related to SSL verification:
```
Collecting colomoto-docker
  Could not fetch URL https://pypi.python.org/simple/colomoto-docker/:
There was a problem confirming the ssl certificate: [SSL:TLSV1_ALERT_PROTOCOL_VERSION] tlsv1 alert protocol version (_ssl.c:661)
- skipping
```
**Solution**: this is due to an outdated pip/python installation. On Linux, upgrade your packages. On macOS, you can upgrade pip as follows:
```
curl https://bootstrap.pypa.io/get-pip.py | sudo python
```
see https://stackoverflow.com/questions/49768770/not-able-to-install-python-packages-ssl-tlsv1-alert-protocol-version for more help.

