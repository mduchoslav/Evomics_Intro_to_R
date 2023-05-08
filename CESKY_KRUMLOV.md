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

```
asmstats ilAgrStra1_PacBioHiFi_filtered.fasta.gz > ilAgrStra1_PacBioHiFi_filtered.fasta.gz.stats
```

Now have a look at your ilAgrStra1_PacBioHiFi_filtered.fasta.gz.stats file. Answer the following questions:
1-) How many reads in total do you have?

2-) What is the size of the largest read in your dataset?

3-) What is the size of the smallest read in your dataset?

4-) What is the total amount of basepairs in your dataset?

5-) What is your reads N50?

Take a note of all of that so we can discuss the results together later today.

### 3.1 General stats: manipulating files on the command line

### 3.2 Plotting reads length distribution

### 2.1 Running Histex

Ok, I know the numbering seems a bit confunsing as we just came back to 2.1. This is not wrong, it'a because now we are going to go back to the results we got by running FastK. If you run was succesfull, you should now have two files in your kmers directory, one that ends in .hist and the other in .prof. We want to use the .hist output now to create a user readable histogram from Gene's kmer counter. We do this with Histex for the same FasK package.

```
Histex -h1:1000 -kA  ilAgrStra1_PacBioHiFi_filtered.hist > 
```
The command above means we are dumping 

 Talk to shane as ask why this is giving me a very strange prediction
 
 /software/team311/cz3/bin/Histex -h1:1000 -kA m64222e_210328_153138.ccs.bc1011_BAK8A_OA--bc1011_BAK8A_OA.filtered.hist |  awk '{print $1" "$2}' > genomescope.hist
 
 http://qb.cshl.edu/genomescope/analysis.php?code=cjMZcOHbX8F51WZprcvZ
 

### 2.2. Plotting it on Genomescope

Now you are going to take your output file and upload it to [genomescope](http://qb.cshl.edu/genomescope/) on the Browser. How does your kmer profile looks like? Let's regrupe and discuss before we go to genome assembly.

## 4. Genome assembly with Hifiasm

Ok, that we learned a lot about kmer counting and we know the general statistics of our dataset, we are going to run hifiasm to assemble some reads! Unfortunatelly we cannot run hifiasm for the full dataset as it would use too much memory, so I have prepared a smaller dataset for us to run. This dataset is the one you have copied to your hifiasm folder.

Ok, so the first thing you can do is to run asmstats to understand a bit about this small dataset.

```
# go to the hifiasm directory
cd ../hifiasm

#Run asmstats on the file
asmstats PacBioHiFi_100.fa.gz
```

How many reads fo we have? What is the reads N50?

Now let's run hifiasm on the reads

```
hifiasm -o ilAgrStra1.asm -t 4 PacBioHiFi_100.fa.gz
```

This should take only a couple of minutes. Once its done, hifiasm will output a series of files, they will end in .bed and .gfa. Have a look at the [hifiasm](https://github.com/chhylp123/hifiasm) github page to get acostumed with the software. 

The output we are interested in is the one ending in .asm.bp.r_utg.noseq.gfa. Open this file on bandage. Bandage will look something like the image bellow, you need to upload the file and then click 'Draw graph'.


![image](https://user-images.githubusercontent.com/4116164/236863823-05841121-6dd8-40af-8885-6482662f423c.png)

The output we are interested in is the one ending in .asm.bp.r_utg.noseq.gfa. Open this file on bandage. 
