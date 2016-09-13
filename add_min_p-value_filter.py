#!/usr/bin/python
import gzip
import sys

thres = 0.0001
with gzip.open(sys.argv[1]) as f:
	f.readline().strip()
	for l in f:
		#if l.startswith("snp"):
		#	continue
		spl = l.strip().split("\t")
		min_p = 1
		for p in spl[3:]:
			if p == "NA":
				continue
			p = float(p)
			if p < min_p:
				min_p = p
		if min_p < thres:
			spl[0] = min_p
			print "\t".join(map(str,spl))
