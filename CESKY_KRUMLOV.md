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

All data we are going to need are under `/home/genomics/workshop_materials/genomeAssembly_files`. But you won't execute anything from there. We are copying files over or making symbolic links to the folders you just created in your home directory.

For our largest file, we are going to make a [symbolic link](https://www.futurelearn.com/info/courses/linux-for-bioinformatics/0/steps/201767#:~:text=A%20symlink%20is%20a%20symbolic,directory%20in%20any%20file%20system.) so we don't have to copy it to every student folder. Do as below:

```
# go inside your kmers folder
cd genome_assembly/kmers

#symlink the large PacbioHiFi data there
ln -s /home/genomics/workshop_materials/genomeAssembly_files/ilAgrStra1_PacBioHiFi_filtered.fasta.gz .
```
### 1.2.1 Copy the smaller file.
Now let's get one more file we are going to need. This is a small file, so we can copy it. This time we are placing it in the hifiasm folder. We will also need it in the MitoHiFi folder, so after we copy it to the hifiasm folder, we are going to symlink it to the MitoHiFi folder.

```
# leave the kmers folder and go to hifiasm
cd ../hifiasm

# Run the command below to see where you are. pwd will print the whole path to the directory (folder) where you currently are.
pwd

# This file is small, so we can copy it
cp /home/genomics/workshop_materials/genomeAssembly_files/PacBioHiFi_100.fa.gz .

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

# Let's list files in your directory with the command below, do you see your PacBioHiFi dataset?
ls -ltrh .

# If you see your file, now let's count kmers with FastK, run the command below
FastK -k31 -p ./ilAgrStra1_PacBioHiFi_filtered.fasta.gz
```
This will take around 45 minutes to run, so let's go to step 3 to run a few more analyses, and we come back to this step in 45. Open a new terminal tab and continue working there.

## 3. Reads general analyzes and statistics
Ok, so while `FastK` is running, I want you to get to know your dataset a bit better. So we are going to plot your reads lenght distribution, and we are going to calculate general metrics for your reads. It's important that we understand the data we are assembling. Looking at a plot of our reads length distribution, knowing general statistics for our file and doing a kmer analysis are fundamental steps to know what to expect when are assembly is done. 

### 3.1 Plotting reads length distribution
 You can use this python script I wrote to plot your reads length distribution as such:
 
 ```
 python plot_fasta_length.py ilAgrStra1_PacBioHiFi_filtered.fasta.gz ilAgrStra1_PacBioHiFi_filtered.png &
 ```
 This will run for a few minutes, go to the next step.

### 3.2 Calculating general reads statistics
We can run the script `asmsstats` that will give us some general statistics such as: (i) numbers of reads, max read length, min read length, how many base pairs in total, [N50](https://en.wikipedia.org/wiki/N50,_L50,_and_related_statistics) of our reads and so on.

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

### 3.3 Manipulating files on the command line
We have just ran `asmstats` which is a nice script written by my boss Shane McCarthy, but I want to show that even if you don't have that script right away, you can get first general metrics for your fasta file with simple unix commands.
We know all fasta sequence have a header starting with `>` plus an ID. Then, in the next line we have our DNA or protein sequence. So, if we want to count the number of sequences in a fasta file, one thing we can do it count how many times `>` happens in that file. We can do that as follows:

```
zcat ilAgrStra1_PacBioHiFi_filtered.fasta.gz | grep ">" | wc

```
Let me explain the command above: first we are displaying the content of the compressed file with zcat (if the file wasn't zipped, we could go straight to grep), then we use a pipe `|` that basically sends the result of our first command to the next, so we are displaying the content of the zipped multifasta file, and then we are using `grep` to find a specific pattern inside our file, which is `>`. Finally we send the result of grep with a pipe `|` to another comand, the `wc`, which basically means _word count_. So we are counting how many times the symbol `>` happens in that file, wich is the same as calculating how many fasta sequences we have in our fasta file. :)  

### 2.1 Running Histex and GeneScopeFK
Ok, I know the numbering seems a bit confusing as we just came back to 2.1. This is not wrong, it's because now we are going to go back to the results we got by running `FastK`. If you run was successful, you should now have two files in your kmers directory, one that ends in `.hist` and the other in `.prof`. We want to use the `.hist` output now to create a user readable histogram from Gene's kmer counter. We do this with `Histex` and GeneScopeFK from the same FastK package.

```
Histex -h1:1000 -G ilAgrStra1_PacBioHiFi_filtered.hist | Rscript GeneScopeFK.R -o Output -k 31
```
Ok, if the command about was succesful, it should create a series of outputs in the Output folder. Go inside it and open the linear_plot.png and answer the questions bellow:

Does the reads kmer plotted fit the model?
What is the expected genome size?
What is the expected heterozigosity?
What is the expected repeat content?


Exciting! You have done a kmer count and analyses of a complete PacBio dataset! &hearts; #StayCalmAndCountKmers 

## 4. Genome assembly with Hifiasm

Ok, now that we learned a lot about kmer counting and we know the general statistics of our dataset, we are going to run hifiasm to assemble some reads! Unfortunatelly we cannot run hifiasm for the full dataset as it would use too much memory, so I have prepared a smaller dataset for us to run. This dataset is the one you have copied to your hifiasm folder.

Ok, so the first thing you can do is to run `asmstats` to understand a bit about this small dataset. Or you can at least use the `grep` command (3.3) to count how many reads we have in this smaller dataset.

```
# go to the hifiasm directory
cd ../hifiasm

#Run asmstats on the file
asmstats PacBioHiFi_100.fa.gz > PacBioHiFi_100.fa.gz.stats
```

How many reads do we have? What is the reads N50?

Now let's run hifiasm on this small dataset.

```
hifiasm -o ilAgrStra1.asm -t 4 PacBioHiFi_100.fa.gz
```
This should take only a couple of minutes. Once its done, hifiasm will output a series of files, they will end in `.bed` and `.gfa.`. Have a look at the [hifiasm](https://github.com/chhylp123/hifiasm) github page to get acostumed with the software. 

The first output we are interested in is the one ending in `.asm.bp.r_utg.noseq.gfa`. Open this file on [bandage](https://github.com/rrwick/Bandage/releases/). Bandage will look something like the image bellow, you need to upload the file and then click `Draw graph`.


![image](https://user-images.githubusercontent.com/4116164/236863823-05841121-6dd8-40af-8885-6482662f423c.png)

 
Humn... what do you see when you look at the Bandage image? Is it a linear or circular sequence? Interesting... 
Ok, now we are going to go back to the other Hifiasm outputs. We have open the unitigs one on Bandage, but now we want to work with the final contig output Hifiasm has generated. Hifiasm outpus it all in the [.gfa](http://gfa-spec.github.io/GFA-spec/GFA1.html) format, so we need to use the one-liner bellow to get a fasta sequence out of the `.gfa`.

```
awk '/^S/ {print ">"$2"\n"$3}' ilAgrStra1.asm.bp.p_ctg.gfa > ilAgrStra1.asm.bp.p_ctg.fa
```
Ok, now we have a fasta sequence! WELL DONE, you have completed your first genome assembly!

Want to analyze a bit what you have assembled? Why not run `asmstats` on it:

```
asmstats ilAgrStra1.asm.bp.p_ctg.fa > ilAgrStra1.asm.bp.p_ctg.fa.stats
```
What are the statistics of this file? N50, how many contigs assembled, total assembly size?

Ok, so at the beginning of the tutorial I told you that we would be assembling the moth _Agriphila straminella_. But this small dataset contain only a few reads. I wonder if we have assembled something specific from _A. straminella_, like a specific chromossome or... ? Could you copy some of the sequence you've assembled and [blast it on NCBI](https://blast.ncbi.nlm.nih.gov/Blast.cgi)?

To select a portion of the sequence do:

```
more ilAgrStra1.asm.bp.p_ctg.fa
#Then copy and past it on the NCBI browser
```

What is this sequence?
Let's dicuss this and all the other results we have generated until now as a big group.

## 5. Assembling and annotating mitochondrial genomes

Beyond the nuclear genome, we have inside (most of) all us animals another genome: the mitochondria. PacBio HiFi is great in assembling it too, but because of the circular nature of the molecule, assemblers often assemble it redundantly (as we just discussed for the case above). So I have written a pipeline to specifically assemble mitochondrial genomes, it's called [MitoHiFi](https://github.com/marcelauliano/MitoHiFi). MitoHiFi basically orchestrats a series of other tools to assemble (Hifiasm is the assembler inside it!), remove redandancy, annotate, rotate, produce plots and statistics for your mitogenome. MitoHiFi was written to work with PacBio HiFi reads and it has many running modes. Today we are going to run it starting from reads (parameter `-r`).

Because MitoHiFi has a lot of dependencies, we have built its own little universe: we built a Docker container for MitoHiFi. So anytime someone executes MitoHiFi from this Docker container (it can be from Docker or with [singularity](https://docs.sylabs.io/guides/2.6/user-guide/singularity_and_docker.html), for example), this person won't find any problems with software dependencies because it is all contained inside that little MitoHiFi Docker universe.

We are going to execute MitoHiFi Docker image with singularity today. First let's move inside our MitoHiFi folder.

```
#Check where you are with `pwd`. 
pwd

#change directories. The command to go to the MitoHiFi folder should be something like the below:
cd ../genome_assembly/MitoHiFi


# List your directory. We are going to need the `PacBioHiFi_100.fa.gz` file for this run. Do you see it there?
ls .
```

For you to have a look at the help message of MitoHiFi and to start getting to know it do:

```
singularity exec docker://ghcr.io/marcelauliano/mitohifi:master mitohifi.py --help
```

Ok, so one way that MitoHiFi works is from selecting mitochondrial reads from a pot of whole-genome sequenced reads. To do that, it maps those reads to a close-related mitogenome reference. To allow this step, we have writen a python script that downloads a complete close-related reference for you from the NCBI. So the first command you need to run before your start MitoHiFi is the following.

Remember we are assembling data for _Agriphila straminella_. So we want to find the closest referent available for it, including it's own mitogenome, if available.

```
singularity exec docker://ghcr.io/marcelauliano/mitohifi:master findMitoReference.py --species "Agriphila straminella" --outfolder . --min_length 16000
```

This should write two files for a reference mitogenome (NC_061606.1) to your folder: one ending in `.fasta` and another in `.gb`. 

Now we have all we need to run MitoHiFi. Good! We are going to use the reference we just download for parameters `-f` and `-g` and we are going to use our PacBio 100 reads as input in `-r`. The `-r` are the reads we want to assemble in order to get our mitogenome done.

```
singularity exec docker://ghcr.io/marcelauliano/mitohifi:master mitohifi.py -r PacBioHiFi_100.fa.gz -f NC_061606.1.fasta -g NC_061606.1.gb -o 5 -t 4 
```

Nice, ok. This will now run for a few minutes. What we are running above is the following: we are starting MitoHiFi from the unasembled reads of our species of insterest (`-r`), using the mitogenome of _Crambus perlellus_ as a close-related reference in `-f` and `-f`. MitoHiFi is going to annotate the mitogenome with MitoFinder, and for that it needs the genetic mitochondrial code for invertebrates which is given with `-o 5 `. Finally, we are using 4 CPUs (or threads) for this run `-t 4`.

Have a look at our github page to get yourself familiar with the software [MitoHiFi github](https://github.com/marcelauliano/MitoHiFi). 

Once MitoHiFi finishes, it will output a series of files. The most important one being the mitogenome itself called `final_mitogenome.fasta` and it's annotation in genbank format `final_mitogenome.gb`. I also want you to have a look at the plots: `final_mitogenome.annotation.png` and `final_mitogenome.coverage.png`. Have a look also at the general statistics of this mitogenome assembly an annotation in `contis_stats.tsv`.

CONGRATULATIONS!
Today you have done a lot in the world of _de novo_ genome assembly. You have (i) counted kmers to understand what is there in your reads dataset, (ii) you have calculated general statistics and plotted reads length distribution, (iii) you have ran a genome assembly from scracth using hifiasm, (iv) you have looked at hifiasm graphs, (v) you ran MitoHiFi that runs assembly (with hifiasm) and annotates a complete mitochondrial genome. WELL DONE! 


