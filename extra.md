### 3.3 Manipulating files on the command line
We have just ran `asmstats` which is a nice script written by my boss Shane McCarthy, but I want to show that even if you don't have that script right away, you can get first general metrics for your fasta file with simple unix commands.
We know all fasta sequence have a header starting with `>` plus an ID. Then, in the next line we have our DNA or protein sequence. So, if we want to count the number of sequences in a fasta file, one thing we can do it count how many times `>` happens in that file. We can do that as follows:

```
zcat ilAgrStra1_PacBioHiFi_filtered.0.5.fasta.gz | grep ">" | wc

```
Let me explain the command above: first we are displaying the content of the compressed file with zcat (if the file wasn't zipped, we could go straight to grep), then we use a pipe `|` that basically sends the result of our first command to the next, so we are displaying the content of the zipped multifasta file, and then we are using `grep` to find a specific pattern inside our file, which is `>`. Finally we send the result of grep with a pipe `|` to another comand, the `wc`, which basically means _word count_. So we are counting how many times the symbol `>` happens in that file, wich is the same as calculating how many fasta sequences we have in our fasta file. :)  
