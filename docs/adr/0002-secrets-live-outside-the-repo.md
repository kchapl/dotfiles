# Secrets live outside the repository, guarded by a pre-commit hook

Status: accepted

Credentials are exported from `~/.secrets`, a plain shell script that `~/.bashrc` sources when it exists, and `~/.secrets` is never committed. Exporting the variables from a script keeps the shell configuration honest — `~/.bashrc` stays a description of how the shell behaves, not a store of tokens — while keeping the secret itself on the machine that needs it.

The alternative, keeping exports inline in `shell/.bashrc`, is how the repository ends up publishing a live API key. Because `shell/.bashrc` is stowed into `~/.bashrc` it is easy to edit the *live* file and forget that every edit is a tracked change, so the path of least resistance writes the secret straight into a commit.

Two mechanisms keep secrets out. `.githooks/pre-commit` scans staged *additions* for credential-shaped values and for secret-bearing filenames, and blocks the commit; `install` enables it with a repository-local `core.hooksPath`, so it guards this repository without touching the user's other ones. `.gitignore` covers the filenames as a second line of defence. Only staged content is scanned, which is what makes removing a secret a normal commit rather than an error.

`shell/.secrets.example` is committed and stowed to `~/.secrets.example`. It carries the format and no values, and the hook exempts `*.example`, `*.sample` and `*.template` for that reason.

## Considered options

- **Secret manager.** Pull values from 1Password, `pass`, or `sops`/`age` at shell startup. Stronger at rest and auditable, but each adds a binary and a key or account dependency to a repository whose setup is otherwise just GNU Stow, and none of them fit a secrets file that is meant to be read and edited by hand.
- **Encrypted file in the repository.** Commit `~/.secrets` under `age` or `git-crypt`. The ciphertext is publishable, but the passphrase to open it becomes the new secret to store, and every shell startup pays a decrypt.
- **Global `core.hooksPath`.** Guard every repository on the machine at once. Rejected because it silently takes over hooks in unrelated repositories; the guard is worth a decision per repository, and `install` already makes that decision for this one.
