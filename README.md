# SUDO Terraform modules

Open source Terraform modules by SUDO for GitLab and other non-AWS providers.

## Org-wide defaults

- `.github/pull_request_template.md` and `.github/ISSUE_TEMPLATE/` apply to every repo that does not ship its own
- `profile/README.md` is the public org profile
- `labels.yml` is the label set; run `scripts/sync-labels.sh` after changing it or creating a repo, and add `--prune` to remove labels that are not in the file
