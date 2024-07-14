#!/usr/local/bin/Rscript

args = commandArgs(trailingOnly=TRUE)

# import libraries
library(ggplot2)
library(ggthemes)



table <- read.table(args[1], header = TRUE, sep = "\t")
table
table$size
table$number_of_reads


p<-ggplot(data=table, aes(x = factor(size) , y=number_of_reads)) +
	  geom_bar(stat="identity", width = 0.5, color="black", fill="dark green") +
	    theme_hc() +
		ggtitle(args[1])

pdf(args[2])
print(p)     # Plot 1 --> in the first page of PDF
dev.off()

