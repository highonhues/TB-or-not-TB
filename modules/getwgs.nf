#!/usr/bin/env nextflow

process GET_WGS {

    // outputs saved to the defined datadir
    publishDir "${params.datadir}", mode: 'copy'
    conda 'conda-forge::wget=1.21.4'

    output:
    path "*"   // all the unzipped downloaded files 

    script:
    // download loop in Bash
    // iterating over the groovy list params.downloads
    // and pass each name + url into wget
    def dl_list = params.downloads.collect { "${it.name}|${it.url}" }.join("\n")

    """
    echo "Starting file downloads..."
    
    #  pre processing
    # Read the name|url pairs and loop through them

    while IFS="|" read -r name url; do

        echo "Downloading: \$name from \$url"
        
        # -O forces the saved filename to be exactly what we want
        wget -nc -O "\$name" "\$url"

    done <<EOF
    ${dl_list}
    EOF

    echo "Download complete."

    """
}
