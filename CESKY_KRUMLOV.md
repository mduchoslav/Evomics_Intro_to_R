# Genome assembly: kmer counting and assembly

Today we are going to count DNA kmers, (i) assemble a portion of a genome and (ii) run a pipeline to assemble and annotate a mitochondrial genome. This is really exciting. 

## 1. Count kmers
### 1.1. Create a directory
In order to keep your project neat, go to your home folder and make a folder for your work today such as:
```
mkdir genome_assembly
mkdir genome_assembly/kmers
mkdir genome_assembly/hifiasm
mkdir genome_assembly/MitoHiFi
```
### 1.2 Symlink and copy files

For our largest file, we are going to make a [symbolic link](https://www.futurelearn.com/info/courses/linux-for-bioinformatics/0/steps/201767#:~:text=A%20symlink%20is%20a%20symbolic,directory%20in%20any%20file%20system.) so we don't have to copy it to every students folder


