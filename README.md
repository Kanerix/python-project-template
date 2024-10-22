# python-project-template

My template for Python3 projects.

**INFO:** In the future this template will use UV when the tool is more developed.

## Features

- Proper Python type checking
- Proper Python dependency locking
- Automatically managed environments
- Visual of outdated dependencies
- Very customizable linting
- Linting of code before push to main/master and staging branches

## Setup project

Prerequisites:

- [Poetry](https://python-poetry.org/docs/#installation)

Start off by giving the project a name. The name should be set in these places:

- [`package`](package): Change folder name.
- [`pyproject.toml`](pyproject.toml#L2): Change to project name.
- [`Dockerfile`](Dockerfile#L999): Change Dockerfile entrypoint.

First you have to active your environment:

```shell
poetry shell
```

That's it. Now install missing dependencies for local development:

```shell
$ poetry install --with dev
Installing dependencies from lock file
```

Now you are ready to start developing!

**NOTE:** If you have issues like missing dependencies, you might have to select the Poetry interpreter.
You can do this by opening the VSCode command pallette (`F1`) and search for `Python: Select interpreter`.
Then locate the poetry interpreter for your project (it will say `Poetry` or `Recommended`). The name of
the interpreter should look something like this:

```text
Python 3.13.0 ('[package]-DncAA2aN-py3.13': Poetry)
```

## Tools

### Poetry

This section is referenced from the [Poetry documentation](https://python-poetry.org/docs/).

Poetry is the tool used to manage dependencies. Poetry creates a dependency lock file. This will make sure
that the same version of dependencies will be used for every install. Poetry also has other powerful features like
dependency groups which is explained below.

#### Installing dependencies

You can install dependencies using `Poetry` with the following command:

```shell
$ poetry install
Installing dependencies from lock file
```

You can also use [Poetry dependency groups](https://python-poetry.org/docs/managing-dependencies/)
to create groups, not required for running the application (test, dev, etc..). In this template there is
a group called `dev` used to install dependencies required for development only. Install these dependencies
with the following command.

```shell
$ poetry install --with dev
Installing dependencies from lock file
```

#### Adding dependencies

To add new dependencies using Poetry, you can use the following command:

```shell
$ poetry add prefect
Using version ^3.0.10 for prefect

$ poetry add prefect==2.18.3
Using version ^2.18.3 for prefect
```

If you wan't to add them to a specif group you can use the flag `--group <group>`.

```shell
$ poetry add ipykernel --group dev
Using version * for ipykernel 
```

### Updating dependencies

To update dependencies, it is very simple. Just run the following command.

```shell
$ poetry update
Updating dependencies
```

Then make sure the project still runs and you are have updated.

### Ruff

This section is referenced from the [Ruff documentation](https://docs.astral.sh/ruff/).

Ruff is the default linter and formatter for this template. Ruff is extremely powerful
because it is very customizable. As en example you can freely choose between different linters
and even combine them. You can see the list of available linters running the command below.

```shell
$ ruff linter
     ...
   F Pyflakes
 E/W pycodestyle
 DOC pydoclint
     ...
```

These linter can be added to the [ruff.toml](ruff.toml) file.

#### Linting your code

Linting your code with Ruff is very easy. You just need to run the command below.

```shell
$ ruff check
...
Found 1 error.
```

You can also use the `--fix` flag to fix all autofixable issues.

```shell
$ ruff check --fix
...
Found 1 error.
```

### Githooks

Githooks is an opt-in feature. It will automatically use `ruff` to check code before pushing
code to the remote on branches main/master and staging. To enable this feature you will have to
change the default folder that `git` checks for hooks.

```bash
git config --local core.hooksPath .githooks/
```

**NOTE:** Here we used the `--local` flag which only enables it for this repository. If desired, this
can also be added as a global config value using the `--global` flag.
