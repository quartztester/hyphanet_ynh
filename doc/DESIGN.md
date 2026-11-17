# hyphanet — packaging design

Freenet's reference daemon (fred): a Java P2P node whose web UI (fproxy) emits root-absolute links, which shapes the whole package: dedicated subdomain, node-owned ini.

Anything not mentioned below is standard YunoHost boilerplate identical in most packages.

## Lifecycle
- **Install:** sources (8 jars + seedrefs zip) → state dirs under `$data_dir` → render `freenet.ini` → seed `noderef/seednodes.fref` → systemd start with wait on "Node initialization completed" → adopt rewritten ini checksum.
- **Upgrade:** jars re-extracted `--full_replace`; the node's own `freenet.ini` and all of `$data_dir` survive untouched (no re-render).
- **Backup/restore:** `$install_dir`, whole `$data_dir` (includes the datastore — archives are ~store_size), unit/nginx/logrotate, `/var/log/hyphanet`; nothing regenerated beyond nginx reload.

## Decisions
- **Source:** `freenet.jar` release asset + 6 dependency jars pinned by sha256 (verified against upstream `dependencies.properties`); `freenet-ext` comes from mvn.freenetproject.org, the rest from Maven Central. No archive build at install time — upstream ships the runnable jar. `seedrefs` zip is byte-equivalent to upstream's debian/rules seednodes.fref (concatenation done in install, not at build).
- **Runtime:** bookworm `default-jre-headless` (17) + `libservice-wrapper-java`; fred's main class calls `WrapperManager` but degrades gracefully without the native library (verified on Java 21/arm64).
- **Services:** single unit; classpath is `$install_dir/*` plus `/usr/share/java/wrapper.jar` (Debian path, not in install_dir) — [conf/systemd.service L10](../conf/systemd.service#L10).
- **Storage:** no DB; node state (identity `master.keys`, store, rewritten ini) under `$data_dir` because `ynh_setup_source --full_replace` wipes `$install_dir` — [scripts/upgrade L31](../scripts/upgrade#L31).
- **Auth:** `ldap/sso = "not_relevant"` (node has no user accounts). Main permission defaults to `all_users`: fproxy can reconfigure the node.
- **Email:** no mail.
- **Path:** domain-only (no `path` question): fproxy links (`/static/…`, `/config/…`) are root-absolute; change_url exists only for domain moves.
- **Ports/firewall:** fproxy binds 127.0.0.1:$port only; the UDP peer port is node-owned (not the $port resource) and deliberately not forwarded by the package.
- **Scheduler:** none.
- **Migration:** n/a (first package).
- **Sandboxing:** example_ynh baseline minus `@privileged` from SystemCallFilter — fred calls setpriority() at startup; `PrivateDevices=yes` kept (JNA is on the classpath for entropy and warns, does not crash).
- **Backup:** datastore included; restore starts the node before nginx reload.
- **Admin-surface:** no config panel; knobs (store size, bandwidth, listen port) applied at install to the ini the node then owns — [doc/ADMIN.md](ADMIN.md).

## Don't break
- Never re-render `$data_dir/freenet.ini` on upgrade: the node rewrites it at shutdown; re-rendering wipes resolved port, identity refs and wizard state.
- `node.listenPort=-1` in a *previously loaded* ini = hard crash on next start ("corrupted", Node.java:1731); empty question value therefore omits the line instead of writing -1 — [scripts/install L51-L53](../scripts/install#L51-L53).
- `fproxy.hasCompletedWizard=true` is pre-seeded — without it everything 301s to `/wizard/` and the CI curl gate fails — [conf/freenet.ini L32](../conf/freenet.ini#L32).
- `fproxy.bindTo` must stay loopback; `0.0.0.0` warnings the linter shows are for the peer ports (intentional, public P2P).
- `ynh_store_file_checksum` right after first start: the node rewrites the ini at startup, and a drifted checksum makes upgrade back it up out from under itself.
- README carries the generator header but is post-processed for a pre-catalog personal repo (repo-local logo, no org URLs) — the linter's "not generated" warning is accepted.
