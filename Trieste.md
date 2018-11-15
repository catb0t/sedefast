# Trieste

dead simple file-oriented language-agnostic dependency manager

## Files / model

SDO "Sidef Data Object" refers to a file containing valid Sidef code, which when evaluated returns a single object like an array, class instance, etc


All are SDOs:

* `<module>.smm` Sidef Module Manifest, describes one Sidef module and its own files with a ModMan object
* `package.smf` or `packages.mf` Package Manifest, lists the Modules declared here, where vendor code should go and global dependencies
* `<module>.sums` (generated) List of checksums of a module's source files / directories as specified by `<module>.smm`

---

## Revision-forwarding

A revision is unlike a "version"; you cannot "require" a specific revision as though it were obtainable. You may only specify that revision is required as a minimum.

This is for simplicity and because (git / VCS) cannot "version" a specific file; they version a whole repository, but we want multiple file-based modules per repository, and we would otherwise have to re-implement half of `git` per-file, which sounds worse than this.

If a revision of 0 is required or declared, it acts as "any" or "un-revisioned"

If you have held a revision of a module (40) which is older than you specify (60), it will only be updated to the newest one (73) upon request (`--update`) -- to prevent auto-breaking / clobbering dependencies

Otherwise, when fetching new versions of vendor code, the newest -- and only, and current -- revision is fetched.

A diagnostic will always be issued when you have specified a nonzero revision, but a higher (current) one is fetched.

A warning will always be issued when your requested revision cannot be at least satisfied, but the current revision will be fetched anyway.

The point of Trieste is not to provide a complete dependency versioning system, it is *simply* to fetch file-based dependencies in any language from any host **without a central package list**, and assume they will work with your code, assuming you have kept your code up-to-date with upstream API changes.


Alternative implementations possibilities:
* `git tag <module>-<verison>`; tag the entire repository in order to version a few files and directories
* per-file / per-module version-record-keeping, but in the most bare-bones way, without re-implementing Git
