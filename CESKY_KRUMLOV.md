# Genome assembly: kmer counting and assembly

Today we are going to count DNA kmers, (i) assemble a portion of a genome and (ii) run a pipeline to assemble and annotate a mitochondrial genome. This is really exciting. We will be working with datasets from the [Darwin Tree of Life Project](https://www.darwintreeoflife.org/). The species we are assembling is the cute moth _Agriphila straminella_ . 

## 1. Organize your data
### 1.1. Create a directory
In order to keep your project neat, go to your home folder and make a folder for your work today such as:
```
mkdir genome_assembly
mkdir genome_assembly/kmers
mkdir genome_assembly/hifiasm
mkdir genome_assembly/MitoHiFi
```
### 1.2 Symlink and/or copy files

For our largest file, we are going to make a [symbolic link](https://www.futurelearn.com/info/courses/linux-for-bioinformatics/0/steps/201767#:~:text=A%20symlink%20is%20a%20symbolic,directory%20in%20any%20file%20system.) so we don't have to copy it to every student folder. 

```
# go inside your kmers folder
cd genome_assembly/kmers

#symlink the large PacbioHiFi data there
ln -s /home/genomics/workshop_materials/mu2/ilAgrStra1_PacBioHiFi_filtered.fasta.gz .
```
### 1.2.1 Now let's copy one more file we are going to need. This time we are placing it in the hifiasm folder. We will also need it in the MitoHiFi folder, so after we copy it to the hifiasm folder, we are going to symlink it to the MitoHiFi folder.

```
# leave the kmers folder and go to hifiasm
cd ../hifiasm

# This file is small, so we can copy it
cp /home/genomics/workshop_materials/mu2/PacBioHiFi_100.fa.gz .

# And now let's symlink this file from hifiasm to our MitoHiFi folder. 
ln -s PacBioHiFi_100.fa.gz ../MitoHiFi/
```

## 2. Counting kmers 

Ok great. Now that you have the files symbolically linked and copied, let's start our analyses. The first one we are going to run is FastK to count kmers of 31bp (k=31). 
