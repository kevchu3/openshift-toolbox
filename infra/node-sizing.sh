#!/bin/bash
set -e
NODE_SIZES_ENV=./node-sizing.env
function dynamic_memory_sizing {
    total_memory=$(free -g|awk '/^Mem:/{print $2}')
    # total_memory=8 test the recommended values by modifying this value
    recommended_systemreserved_memory=0
    if (($total_memory <= 4)); then # 25% of the first 4GB of memory
        recommended_systemreserved_memory=$(echo $total_memory 0.25 | awk '{print $1 * $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=1
        total_memory=$((total_memory-4))
    fi
    if (($total_memory <= 4)); then # 20% of the next 4GB of memory (up to 8GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.20 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 0.80 | awk '{print $1 + $2}')
        total_memory=$((total_memory-4))
    fi
    if (($total_memory <= 8)); then # 10% of the next 8GB of memory (up to 16GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.10 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 0.80 | awk '{print $1 + $2}')
        total_memory=$((total_memory-8))
    fi
    if (($total_memory <= 112)); then # 6% of the next 112GB of memory (up to 128GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.06 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 6.72 | awk '{print $1 + $2}')
        total_memory=$((total_memory-112))
    fi
    if (($total_memory >= 0)); then # 2% of any memory above 128GB
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.02 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
    fi
    echo "SYSTEM_RESERVED_MEMORY=${recommended_systemreserved_memory}Gi">> ${NODE_SIZES_ENV}
}
function dynamic_cpu_sizing {
    total_cpu=$(getconf _NPROCESSORS_ONLN)
    recommended_systemreserved_cpu=0
    if (($total_cpu <= 1)); then # 6% of the first core
        recommended_systemreserved_cpu=$(echo $total_cpu 0.06 | awk '{print $1 * $2}')
        total_cpu=0
    else
        recommended_systemreserved_cpu=0.06
        total_cpu=$((total_cpu-1))
    fi
    if (($total_cpu <= 1)); then # 1% of the next core (up to 2 cores)
        recommended_systemreserved_cpu=$(echo $recommended_systemreserved_cpu $(echo $total_cpu 0.01 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_cpu=0
    else
        recommended_systemreserved_cpu=$(echo $recommended_systemreserved_cpu 0.01 | awk '{print $1 + $2}')
        total_cpu=$((total_cpu-1))
    fi
    if (($total_cpu <= 2)); then # 0.5% of the next 2 cores (up to 4 cores)
        recommended_systemreserved_cpu=$(echo $recommended_systemreserved_cpu $(echo $total_cpu 0.005 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_cpu=0
    else
        recommended_systemreserved_cpu=$(echo $recommended_systemreserved_cpu 0.01 | awk '{print $1 + $2}')
        total_cpu=$((total_cpu-2))
    fi
    if (($total_cpu >= 0)); then # 0.25% of any cores above 4 cores
        recommended_systemreserved_cpu=$(echo $recommended_systemreserved_cpu $(echo $total_cpu 0.0025 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
    fi
    echo "SYSTEM_RESERVED_CPU=${recommended_systemreserved_cpu}">> ${NODE_SIZES_ENV}
}
function dynamic_ephemeral_sizing {
    echo "Not implemented yet"
}
function dynamic_pid_sizing {
    echo "Not implemented yet"
}
function dynamic_node_sizing {
    rm -f ${NODE_SIZES_ENV}
    dynamic_memory_sizing
    dynamic_cpu_sizing
    #dynamic_ephemeral_sizing
    #dynamic_pid_sizing
}
function static_node_sizing {
    rm -f ${NODE_SIZES_ENV}
    echo "SYSTEM_RESERVED_MEMORY=$1" >> ${NODE_SIZES_ENV}
    echo "SYSTEM_RESERVED_CPU=$2" >> ${NODE_SIZES_ENV}
}

if [ $1 == "true" ]; then
    dynamic_node_sizing
elif [ $1 == "false" ]; then
    static_node_sizing $2 $3
else
    echo "Unrecongnized command line option. Valid options are \"true\" or \"false\""
fi
