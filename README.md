# mvnclean

A tiny utility to remove older dependencies from your Maven repository.

## Usage

`mvnclean [options]`

Where options include:
- `-r <repository path>` if you want to specify this explicitly; otherwise mavenclean will check your M2_REPO environment variable and also the default location in `~/.m2/repository`
- `-m <months>` to specify how recently-accessed a file has to be in order to be retained
- `i <pattern>` to ignore specific patterns if you have items that you don't want to delete even though they haven't been accessed recently
- `-?` to see the help and options

## Status

This is basically operational, but I'd like to clean it up a little before turning it into a Ruby gem for others to consume. If you'd like me to hurry up, [drop me a line](http://www.geoffreywiseman.ca/contact/).

## Future

Some avenues for future enhancements:
- Might be useful to have different thresholds for how old you want your dependencies to be allowed to be.
- Could have a prompt before deleting, and then an option for non-interactive invocation.

