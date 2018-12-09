#!/bin/bash

sbatch RunWaterfallC.sh
sbatch RunLionessC.sh
sbatch RunHouseC.sh

sbatch RunWaterfallGo.sh
sbatch RunLionessGo.sh
sbatch RunHouseGo.sh

#sbatch RunSpaceGo.sh
#sbatch RunSpaceC.sh