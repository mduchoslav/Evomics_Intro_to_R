# Genome assembly: kmer counting and assembly

Today we are going to count DNA kmers, (i) assemble a portion of a genome and (ii) run a pipeline to assemble and annotate a mitochondrial genome. This is really exciting. We will be working with datasets from the [Darwin Tree of Life Project](https://www.darwintreeoflife.org/). The species we are assembling is the cute moth _Agriphila straminella_ . 

## 1. Organize your data
### 1.1. Create a directory
In order to keep your project neat, go to your home folder and make folders for your work today such as:
```
mkdir genome_assembly
mkdir genome_assembly/kmers
mkdir genome_assembly/hifiasm
mkdir genome_assembly/MitoHiFi
```
### 1.2 Symlink and/or copy files

For our largest file, we are going to make a [symbolic link](https://www.futurelearn.com/info/courses/linux-for-bioinformatics/0/steps/201767#:~:text=A%20symlink%20is%20a%20symbolic,directory%20in%20any%20file%20system.) so we don't have to copy it to every student folder. Do as bellow:

```
# go inside your kmers folder
cd genome_assembly/kmers

#symlink the large PacbioHiFi data there
ln -s /home/genomics/workshop_materials/mu2/ilAgrStra1_PacBioHiFi_filtered.fasta.gz .
```
### 1.2.1 Copy the smaller file.
Now let's get one more file we are going to need. This is a small file, so we can copy it. This time we are placing it in the hifiasm folder. We will also need it in the MitoHiFi folder, so after we copy it to the hifiasm folder, we are going to symlink it to the MitoHiFi folder.

```
# leave the kmers folder and go to hifiasm
cd ../hifiasm

# Run the command bellow to see where you are. pwd will print the whole path to the directory (folder) where yoy currently are.
pwd

# This file is small, so we can copy it
cp /home/genomics/workshop_materials/mu2/PacBioHiFi_100.fa.gz .

# And now let's symlink this file from hifiasm to our MitoHiFi folder. 
ln -s PacBioHiFi_100.fa.gz ../MitoHiFi/
```

## 2. Counting kmers 

Ok great. Now that you have the files symbolically linked and/or copied, let's start our analyses. The first one we are going to run is [FastK](https://github.com/thegenemyers/FASTK) to count kmers of 31bp (k=31) for our largest dataset. We do as follows:

```
# Go inside the kmers directory
cd ../kmers

# Always remember: if you feel lost, run pwd to confirm where you are.
pwd

# Let's list files in your directory with the command bellow, do you see your PacBioHiFi dataset?
ls -ltrh .

# If you see your file, now let's count kmers with FastK, run the command bellow
FastK -k31 -p ./ilAgrStra1_PacBioHiFi_filtered.fasta.gz
```
This will take around 45 minutes to run, so let's go to step 3 to run a few more analyses, and we come back to this step in 45.

## 3. General reads statistics
Ok, so while FastK is running, I want you to get to know your dataset a bit better. For that, we can run the script asmsstats that will give us some general statistics such as: (i) numbers of reads, max read length, min read length, how many base pairs in total, [N50](https://en.wikipedia.org/wiki/N50,_L50,_and_related_statistics) of our reads and so on.





