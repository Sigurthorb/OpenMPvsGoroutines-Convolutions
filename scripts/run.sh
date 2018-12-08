#!/bin/bash

function runImages() {
     sbatch compScript.sh $1 "lady" "png"
     sbatch compScript.sh $1 "lioness" "jpg"
     sbatch compScript.sh $1 "waterfall" "jpg"
}

function mkAndRun() {
    cd .. && make $1 && cd - && runImages $1
}

mkAndRun "Block"
mkAndRun "Cycle"
mkAndRun "CycleCollapse"
