# Minecraft Datapack Template

Use this as a starting point for your own data pack. The template provides
starting pack structure, and scripts to package and install your datapack.

## Prerequisites

You will need to install these programs to use the scripts with this template:

- `find`
- `git`
- `make`
- `jq`
- `sed`
- `zip`

Most Linux systems come with `find` and `sed` pre-installed.

## Getting Started

1. Clone this repository.
2. Rename the directory `src/data/your_datapack_namespace` to a name of your
   choice.
3. Edit all of the files in `src/data/minecraft/tags/functions/` to change
   `your_datapack_namespace` to the exact name you picked for the directory in
   step 2.
3. Modify `src/pack.mcmeta` and change the `"description"` property to set the
   name and description for your datapack.
4. Replace `src/pack.png` with your own icon.

## Where To Put Your Code

The template includes some example code that prevents creepers from breaking
blocks when they explode. You probably want to replace the example code with
your own.

There are three functions provided in the
`src/data/your_datapack_namespace/functions/` directory. Each `.mcfunction` file
defines a function.

- `load.mcfunction` runs when the datapack is installed - use this function for
  setup steps that need to run once, like adding scoreboards
- `tick.mcfunction` runs every game tick
- `uninstall.mcfunction` runs when the datapack is uninstalled - use this for
  cleanup, for example for removing the scoreboards that you added in
  `load.mcfunction`.

Note that those three functions are set up by the configuration in the JSON
files in `src/data/minecraft/tags/functions/`. It is important that your
datapack directory name matches the function namespace in those files!

You can adjust special scheduling for functions. For example if you don't want
a function that runs on every tick for example you can delete
`src/data/minecraft/tags/functions/tick.json` and delete
`src/data/your_datapack_namespace/functions/tick.mcfunction`.

### Reducing Lag

One way to reduce lag from your datapack is to remove the `tick`, and to instead
schedule a function that runs less often - for example once every second. To do
that use the `schedule` command in your `load` function:

```mcfunction
schedule function your_datapack_namespace:do_something_every_second 1s
```

That schedules a function called
`your_datapack_namespace:do_something_every_second`. You need to define that
function by creating a new file called
`src/data/your_datapack_namespace/functions/do_something_every_second.mcfunction`.

Make sure to clean up by stopping the scheduled function in your `uninstall`
function:

```mcfunction
schedule clear your_datapack_namespace:do_something_every_second
```

## Building the Datapack

To package your datapack into a zip file run,

    $ make

## Installing

To install the datapack to your local Minecraft install run,

    $ make install

This will automatically build the datapack package if there have been changes to
source files since the package was last built.

The install script attempts to find your Minecraft directory automatically. It
will install to the first directory it finds in this order:

- ~/.var/app/com.mojang.Minecraft/data/minecraft
- ~/.minecraft

If the script picks the wrong directory, or if it does not find your minecraft
directory, you can override the directory path with an environment variable like
this:

    $ minecraft_directory=~/my/minecraft/directory make install
