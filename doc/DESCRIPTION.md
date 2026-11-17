Freenet is a censorship-resistant peer-to-peer network: it stores and routes
encrypted data through its peers, and serves a local web interface ("fproxy")
for browsing freesites, forums and the upload/download queue.

This node runs in OpenNet mode: it connects to public seed nodes and its
presence on the network may be observable. Sensitive users should consider
darknet mode instead (configure it in the freenet interface under Security
levels after connecting trusted peers).

The first start initializes the datastore and connects to the network; it can
take a few minutes before pages load.
