# Customising the HPC environment on Imperial College London's Research Computing Service

## dev

### conda package manager

Recommended conda channels:
- defaults
- conda-forge
- anaconda
- `imperial-college-research-computing` (added by default when installing via the `anaconda3/personal` module)

### Jupyter notebook

Inside a jupyter notebook, execute the following to get a custom conda environment activated.

```Python
import rcs
envs = rcs.environments()  # lists all personal anaconda environments
rcs.activate("MY_ENV_NAME")  # activate the one of your choice
```

## emails

To make sure emails from jobs go to you, execute `echo "YOUR.EMAIL@ADDRESS.COM" > ~/.forward`. You should probably create a rule to save your inbox.

## bugs

### perl5

The `~/perl5` directory is created when a session starts. This clutters the home directory. Deleting does not help, as it gets re-created if missing, which causes a warning message every time you start a job (might interfere with your workflow if you rely on the `.e` file to be empty). See this [bug report](https://bugzilla.redhat.com/show_bug.cgi?id=789146) for more details.

This can be fixed by adding the following to `.profile` ([./profile](./profile)):
```bash
# prevent ~/perl5 directory
test -f ${HOME}/.perl-homedir || echo PERL_HOMEDIR=0 > ${HOME}/.perl-homedir
test -d ${HOME}/perl5 && rmdir ${HOME}/perl5
```

### intel

The `~/intel/ism/rm` directory is created when the Intel compiler is used. See [here](https://software.intel.com/en-us/forums/intel-fortran-compiler-for-linux-and-mac-os-x/topic/558888) for more information.

This can be fixed by adding the following to `.profile` ([./profile](./profile)):
```bash
# prevent ~/intel/ism/rm directory
export INTEL_DISABLE_ISIP=1
```
