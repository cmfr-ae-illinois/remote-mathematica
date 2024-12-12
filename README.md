# Using a Remote Kernel in Mathematica

This is a quick guide on how to use a remote Mathematica kernel on the Illinois cluster. While this solution may not be perfect, it works effectively.

## Files Needed

You will need two files for this guide:

1. `wolframkernel.sbatch`
2. `remoteKernel.wl`

### `wolframkernel.sbatch`

This is the job file to run on the cluster. You will need to modify it to include your name and account details. It is a simple script that starts a kernel on a node.

### `remoteKernel.wl`

This is a Mathematica package. It is not required but contains functions and constants that you might find useful. Ensure it is on your local machine, and you can load it in Mathematica by executing:

```mathematica
Get["path/to/remoteKernel.wl"]
```

## Connecting to the Remote Kernel

### Step 1: Start the Job

Once the job is started and the kernel is running (there will be no output, but if there are no errors and the job is running, you can assume the kernel is active), you need the name of the node running the kernel. You can find it using:

```shell
$ squeue -u $USER
```

Look for the job named `wfrm_kn`.

### Step 2: Start Mathematica

Start your local instance of Mathematica and load the `remoteKernel.wl` package.

### Step 3: Connect to the Remote Kernel

To connect to the remote kernel, evaluate the following expression in Mathematica:

```mathematica
link = ConnectToRemote["NodeName"] (* Replace NodeName with the actual name of the node running the kernel *)
```

## Closing the Kernel

Once your calculations are complete, you should close the remote kernel and terminate the connection. Use the following function:

```mathematica
KillKernel[link]
```

This will close the kernel and the link, and it will automatically end the job.

### Note

By default, there is a 5-hour time limit on the job (this can be changed in the `.sbatch` file). The kernel will stop automatically after this period, without saving progress.

## Using the Remote Kernel

It is important to note that your local kernel and the remote kernel are not synchronized; they only communicate via a link. This means:

- You can perform other computations locally while the remote kernel works.
- Variables and results are not shared automatically between the two kernels.

To send an expression to the remote kernel for evaluation, use:

```mathematica
LinkWrite[link, expr]
```

Since you want to send the expression `expr` itself (not its evaluated result), it is recommended to use `Unevaluated[expr]` as shown:

```mathematica
LinkWrite[link, Unevaluated[expr]]
```

This sends the unevaluated expression `expr` to the remote kernel for evaluation but does not wait for the result, allowing you to continue working locally.

### Checking for Results

- To check if the result is ready: `LinkReadyQ[link]`
- To retrieve the result: `LinkRead[link]`
- To do both: `LinkReadQ[link]`

## Tips and Tricks

### Memory Sharing

The local and remote kernels do not share memory. You need to explicitly send symbol definitions if required. Additionally, `Unevaluated[]` prevents symbolic replacement before sending an expression. For example:

```mathematica
T = 1 + 1
LinkWrite[link, Unevaluated[T + 3]]
```

This will send the expression `T + 3` to the remote kernel. Since memory is not shared, the remote kernel does not know the value of `T`.

### Solution: ReplaceAll

To send the evaluated version of `T`, use `ReplaceAll` (`/.`) like this:

```mathematica
T = 1 + 1
LinkWrite[link, Unevaluated[Temp + 3] /. {Temp -> T}]
```

This sends `2 + 3` to the remote kernel, which evaluates it and returns `5`.

