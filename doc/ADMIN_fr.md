L'interface web du nœud (fproxy) n'est liée qu'à 127.0.0.1 et est exposée via
l'URL de l'app, protégée par la permission SSO choisie à l'installation.

L'état du nœud (clés d'identité, magasin de données, freenet.ini réécrit) se
trouve dans `__DATA_DIR__`. Perdre `state/master.keys` signifie perdre
l'identité du nœud.

Le processus Java est géré par systemd (`$app.service`) ; les journaux sont
dans `/var/log/__ID__/` (journal du nœud : `freenet-latest.log`).

Pour changer plus tard le port d'écoute, la taille du magasin ou la limite de
bande passante, éditez `__DATA_DIR__/freenet.ini` service arrêté (le nœud
réécrit ce fichier à l'arrêt propre), puis redémarrez le service.
