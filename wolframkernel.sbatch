#!/bin/bash
###############################################################################
##                                                                           ##
##                           Campus Cluster                                  ##
##                 Sample Mathematica kernel Job Batch Script                ##
##                                                                           ##
## SLURM Options (To view, run the following command below)                  ##
##                                                                           ##
##     man sbatch                                                            ##
##                                                                           ##
###############################################################################
#                                                                            
#SBATCH --time=05:00:00                  # Job run time (hh:mm:ss)
#SBATCH --nodes=1                        # Number of nodes
#SBATCH --ntasks-per-node=16             # Number of task (cores/ppn) per node
#SBATCH --job-name=wfrm_kn             # Name of batch job
#SBATCH --partition=IllinoisComputes     # Partition (queue)           
#SBATCH --account=Account-name           # Batch account to use
#SBATCH --output=wfrm_ker.log            # Name of batch job output file
#SBATCH --error=wfrm_ker.elog             # Name of batch job error file
#SBATCH --mail-user=IDName@illinois.edu  # Send email notifications
#SBATCH --mail-type=FAIL,REQUEUE,STAGE_OUT,TIME_LIMIT_90 # Type of email notifications to send
#                                                                            
###############################################################################

# Load Mathematica module (Enable Mathematica in user environment)
module load mathematica

# Run Mathematica script
WolframKernel -wstp -linkprotocol TCPIP -linkname "25565,25575"
exit
