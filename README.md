# mvnclean

A tiny utility to remove older dependencies from your Maven repository.

## Usage

`mvnclean [options]`

Where options include:
- `--dry-run`: *mvnclean* will scan your repository, tell you what it would delete, but not try and do any deletions
- `--repository=<path>` if you don't want to rely on `M2_REPO` environment variable or the default location

## TODO
- Option support
- Ignores (e.g. morena)
- Gem Packaging
- Gem Deployment

## Future

Some avenues for future enhancements:
- Might be useful to have different thresholds for how old you want your dependencies to be allowed to be.
- Could have a prompt before deleting, and then an option for non-interactive invocation.

