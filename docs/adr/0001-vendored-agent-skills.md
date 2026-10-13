# Vendored agent skills, delivered by a stowed symlink

Status: accepted

Third-party agent skills are committed into this repository under `agents/.agents/skills/` and delivered to `~/.agents/skills` by GNU Stow, rather than being fetched during setup. Stow folds that directory into a single symlink into the checkout, so a global `npx skills add` writes new skills straight into the working tree — which is how they end up committed, and why `.skills.lock` records their sources.

The trade-off is deliberate. Setup needs neither network access nor Node.js, and every skill is pinned by git to the revision it was installed at. The cost is that vendored skills do not track upstream on their own: updating one is an explicit `npx skills update` (or `add`) followed by a commit, and a vendored skill that differs from upstream is therefore normal rather than a symptom of breakage.

## Considered options

- **Declare-only.** Commit the source list and fetch skills during setup. Always fresh, but setup then requires network and Node.js, and each machine can silently drift to a different revision.
- **Structural split.** Keep authored skills in a separate directory so the layout itself marks ownership. Rejected because it breaks the folded symlink and the flat install target `npx skills` expects, and because it still cannot say *which* upstream a skill came from — only the inventory can.
