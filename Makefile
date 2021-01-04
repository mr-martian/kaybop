all: kaybop.hfst
kaybop.hfst: kaybop_irreg.hfst kaybop_AM.hfst kaybop_NZ.hfst
	hfst-disjunct $^ -o $@
kaybop_irreg.hfst: kaybop_irreg.lexd
	lexd $< | hfst-txt2fst -o $@
kaybop_AM.hfst: kaybop_AM.lexd
	lexd $< | hfst-txt2fst -o $@
kaybop_NZ.hfst: kaybop_NZ.lexd:
	lexd $< | hfst-txt2fst -o $@
kaybop_irreg.lexd: morphology.lexd irregular.lexd
	cat $^ > $@
kaybop_AM.lexd: morphology.lexd lexiconAM.lexd
	cat $^ > $@
kaybop_NZ.lexd: morphology.lexd lexiconNZ.lexd
	cat $^ > $@
clean:
	rm -f *.hfst kaybop*.lexd
