# MJM: Minimal job manager written in bash (yes in bash)

## Description

MJM is a minimal job manager for personal use on a single computer. It provides
simple means to send and manage jobs. Stop wasting your computing power while
sleeping or taking a shower!

Its main features are:
* All the jobs are sent to `screen` for easy management and interaction.
* Simple queue with maximum number of simultaneously running jobs.
* Allows for priority settings (very-high, high, normal, low, very-low).

## Installation

The program consists of a bunch of bash scripts and is provided with a simple
simple installation script.

TBD

## Simple Usage

TBD

Command specific help can be obtained via
```
mjm help [cmd]
```
where `cmd` is one of the commands below.

### Sending jobs
```
mjm send cmd
```
where cmd is the command to be executed. Note that quotation marks should be
used for more complicated commands, e.g. `mjm send "cmd1 && cmd2"`.

### Showing the queue
```
mjm list
```
print list of all running and queuing jobs in queue order. The job names given
here are the names used through the program.

Printing only the job names can achieved using `-p`.

### Interacting with running/queuing jobs
```
mjm atach job
```
attach to the screen session corresponding to a given job. Can be required in
order to interact with a running job. If the job fails or Ctrl-C is used, check
that the stopped job is not showing in the queue any more. Use `mjm purge job`
to delete it from the queue database.

```
mjm kill job1 job2 ...
```
kill given jobs.

### Debugging
MJM comes with a couple of debugging commands such as:

```
mjm pid job1 job2 ...
```
prints PIDs of given jobs. Jobs can be safely killed with the `kill` command.

```
mjm purge [job1 job2 ...]
```
completely wipe out all queue information for given jobs. If no job is given,
do it for all jobs. Can be useful if jobs still show in the queue but are not
running anymore.

```
mjm unlock
```
unlock queue. MJM uses a global lock to avoid race conditions while accessing
the queue files. Can be useful if something went wrong while submitting a job.

## Credits
Copyleft 🄯 2017 Romain Mueller

name do surname at gmail dot com
