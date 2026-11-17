The node's web interface (fproxy) is only bound to 127.0.0.1 and is exposed
through the app URL, gated by the SSO permission you chose at install.

Node state (identity keys, datastore, rewritten freenet.ini) lives in
`__DATA_DIR__`. Losing `state/master.keys` means losing the node identity.

The app's Java process is managed by systemd as `$app.service`; logs are in
`/var/log/__ID__/` (node log: `freenet-latest.log`).

To change the peer listen port, datastore size or bandwidth limit later, edit
`__DATA_DIR__/freenet.ini` while the service is stopped (the node rewrites the
file on clean shutdown), then restart the service.
