# Compile and install GCC 6.3.0 from source on Linux

This is a summary of the steps necessary for compiling `gcc` version 6.3.0 **on Linux**, based on the steps in the [install guide](https://gcc.gnu.org/install/index.html).

## 0. Working directory

```shell
mkdir -p ~/src/gcc/6.3.0
cd ~/src/gcc/6.3.0
```

## 1. [Prerequisites](https://gcc.gnu.org/install/prerequisites.html)

We require the _multiple precision complex floating-point library_ (`mpc`). To install it, run:
```shell
sudo apt install libmpc-dev
```

## 2. [Download](https://gcc.gnu.org/install/download.html)

The [GCC website](https://gcc.gnu.org) has a list of [releases](https://gcc.gnu.org/releases.html) and [mirrors](https://gcc.gnu.org/mirrors.html).

### 2.1. Obtaining the release

One way of obtaining the `tar` archive is via the [gcc-mirror on GitHub](https://github.com/gcc-mirror/gcc):
```shell
wget https://github.com/gcc-mirror/gcc/archive/releases/gcc-6.3.0.tar.gz
```

### 2.2. Extract files

```shell
mkdir -p srcdir
tar xzvf gcc-6.3.0.tar.gz -C srcdir --strip-components=1
```

### 2.3. Apply patch

We need to make [some edits](https://stackoverflow.com/a/48647715) to the downloaded files in `srcdir`. The two files attached below can both be used for this.

**`fix-gcc.sh`**
```shell
sh fix-gcc.sh .
```

**`fix-gcc.patch`**
```shell
patch -p1 < fix-gcc.patch
```

## 3. Build & Install

### 3.1. [Configure](https://gcc.gnu.org/install/configure.html)

```shell
mkdir -p objdir
cd objdir
../srcdir/configure --disable-multilib --enable-languages=c,c++,fortran
```

Exlanation of the options:
- The `--disable-multilib` flag is needed because without it, the build will fail.
- The `--enable-languages` option is there to exclude `java`, whose build will fail.

## 3.2. [Build](https://gcc.gnu.org/install/build.html)

We can `make` in parallel to significantly accelerate compilation:
```shell
make -j${NCPUS}
```
Here `${NCPUS}` is the number of cores we want to use, for example `make -j4`.

## 3.3. [Install](https://gcc.gnu.org/install/finalinstall.html)

To install the files, we use [`checkinstall`](https://asic-linux.com.mx/~izto/checkinstall/):
```shell
sudo checkinstall
```
