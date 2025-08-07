# Dot
Dot is an elegant and simple dotfiles manager for *unix, inspired by [GNU Stow](https://www.gnu.org/software/stow/).

## Usage
Initially, place you dotfiles in the folder you use to manage them. Then, map the structure to a config file called `dot.toml` like this:

```toml
[dot]
source_path = 'dotfiles' # the base folder where your dotfiles are centralized

[dotfiles]
files = [ # list of dotfiles
    { 
        source = '.gitconfig', # source dotfile (considering the source path as base)
        destination = '~/.gitconfig' # place where you be in your machine (use absolute path or the ~ to represent HOME
    },
    { source = '.bashrc', destination = '~/.bashrc' },
]
```

With your *dot* packages available, you can sync them to the right place in your machine:


```sh
dot sync
```

> `dot sync` works by creating symbolic links.

## Roadmap 
- [X] Move away from Swift adopting Rust or Zig languages
- [ ] Include support to "dot-" prefix pre-processing based on a --dotfiles flag (similar to `stow <package> --dotfiles` behavior);
- [ ] Include a command to add a package in the dot directory, using --adopt flag (running the `mkdir` and `mv` commands can be quite boring);

## Installation
Dot is still under development and I decided to only make a release when it's core features are unit-tested.
Given this scenario, if you want to use Dot's binary, you will need to build it yourself.

Check [Zig](https://ziglang.org/learn/getting-started/)'s guide on how to install it, after that, clone the Dot project:

```sh
git clone https://github.com/avantguarda/dot.git

```

Then, enter the directory and run:

```sh
zig build --release
```

The binary will be available under `zig-out/bin/dot`.

## Contribution
Dot is developed completely in the open source model, and your contributions are more than welcome.

This project does not come with GitHub Issues-based support, and users are instead encouraged to become active participants in its continued development — by fixing any bugs that they encounter, or by improving the documentation wherever it’s found to be lacking.

If you wish to make a change, open a Pull Request — even if it just contains a draft of the changes you’re planning, or a test that reproduces an issue — and we can discuss it further from there.

Hope you’ll enjoy using Dot!

## License
This project is licensed under GNU GPLv3 License. Check [LICENSE](LICENSE) for more information.
