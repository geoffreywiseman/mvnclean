# mvnclean

A tiny utility to remove older dependencies from your Maven repository.

## Usage

`mvnclean [options]`

Where options include:
- `-r <repository path>` if you want to specify this explicitly; otherwise mavenclean will check your M2_REPO environment variable and also the default location in `~/.m2/repository`
- `-?` to see the help and options

## Status

At the moment, this is under development, and as such may not be completely operational. Use at your own risk.

## Future

Some avenues for future enhancements:
- Might be useful to have different thresholds for how old you want your dependencies to be allowed to be.
- Could have a prompt before deleting, and then an option for non-interactive invocation.

