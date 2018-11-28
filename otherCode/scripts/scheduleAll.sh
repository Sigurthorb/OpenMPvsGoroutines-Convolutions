#!/bin/bash

cd /lustre/cmsc714-1nzb/final/

sbatch repo/otherCode/scripts/spaceC.sh
sbatch repo/otherCode/scripts/spaceG.sh

sbatch repo/otherCode/scripts/houseC.sh
sbatch repo/otherCode/scripts/houseG.sh

sbatch repo/otherCode/scripts/lionessC.sh
sbatch repo/otherCode/scripts/lionessG.sh

sbatch repo/otherCode/scripts/waterfallC.sh
sbatch repo/otherCode/scripts/waterfallG.sh

sbatch repo/otherCode/scripts/ladyC.sh
sbatch repo/otherCode/scripts/ladyG.sh


