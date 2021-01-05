
rule msisensor2:
    input:
        bam = "DNA_bam/{sample}-ready.bam"
    output:
        msi_score = "MSI/{sample}.msi"
    params:
        prefix = "MSI/{sample}.msi",
        models = "/opt/msisensor2/models_hg38"
    singularity:
        config["singularitys"]["msisensor2"]
    shell:
        "msisensor2 msi -M {params.models} -t {input.bam} -o {params.prefix}"