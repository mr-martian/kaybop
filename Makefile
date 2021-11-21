SHELL = /bin/bash -o pipefail

all: kaybop.hfst

.deps/.d:
	mkdir -p .deps
	touch $@

kaybop.hfst: .deps/morphology.hfst .deps/stem.hfst .deps/stem-inf.hfst
	hfst-substitute -f '{stem}:{stem}' -T .deps/stem.hfst .deps/morphology.hfst | hfst-substitute -o $@ -f '{steminf}:{steminf}' -T .deps/stem-inf.hfst

.deps/morphology.hfst: kaybop.lexd .deps/.d
	lexd $< | hfst-txt2fst -o $@
.deps/stem.hfst: .deps/az.hfst
	hfst-substitute -o $@ -f '{in}' -t '@0@' $<
.deps/stem-inf.hfst: .deps/az.hfst .deps/add-infix.hfst
	hfst-compose -1 .deps/add-infix.hfst -2 .deps/az.hfst -o $@

.deps/%.lexd: lexicons/%.lexd .deps/header.lexd .deps/.d
	cat .deps/header.lexd > $@
	cat $< >> $@
.deps/%.hfst: .deps/%.lexd
	lexd $< | hfst-txt2fst -o $@
.deps/header.lexd: .deps/.d
	printf 'PATTERNS\nRoot\nLEXICON Root\n' > $@
.deps/infix.lexd: .deps/.d
	printf 'PATTERNS\n[gyin(p):{in}]\n' > $@
.deps/any-star.hfst:
	echo '?*' | hfst-regexp2fst -o $@
.deps/add-infix.hfst: .deps/infix.hfst .deps/any-star.hfst
	hfst-concatenate -1 .deps/any-star.hfst -2 .deps/infix.hfst | hfst-concatenate -1 - -2 .deps/any-star.hfst -o $@

.deps/ab.hfst: .deps/a.hfst .deps/b.hfst
	hfst-disjunct $^ -o $@
.deps/cd.hfst: .deps/c.hfst .deps/d.hfst
	hfst-disjunct $^ -o $@
.deps/ef.hfst: .deps/e.hfst .deps/f.hfst
	hfst-disjunct $^ -o $@
.deps/gh.hfst: .deps/g.hfst .deps/h.hfst
	hfst-disjunct $^ -o $@
.deps/ij.hfst: .deps/i.hfst .deps/j.hfst
	hfst-disjunct $^ -o $@
.deps/kl.hfst: .deps/k.hfst .deps/l.hfst
	hfst-disjunct $^ -o $@
.deps/mn.hfst: .deps/m.hfst .deps/n.hfst
	hfst-disjunct $^ -o $@
.deps/op.hfst: .deps/o.hfst .deps/p.hfst
	hfst-disjunct $^ -o $@
.deps/qr.hfst: .deps/q.hfst .deps/r.hfst
	hfst-disjunct $^ -o $@
.deps/st.hfst: .deps/s.hfst .deps/t.hfst
	hfst-disjunct $^ -o $@
.deps/uv.hfst: .deps/u.hfst .deps/v.hfst
	hfst-disjunct $^ -o $@
.deps/wx.hfst: .deps/w.hfst .deps/x.hfst
	hfst-disjunct $^ -o $@
.deps/yz.hfst: .deps/y.hfst .deps/z.hfst
	hfst-disjunct $^ -o $@
.deps/ad.hfst: .deps/ab.hfst .deps/cd.hfst
	hfst-disjunct $^ -o $@
.deps/eh.hfst: .deps/ef.hfst .deps/gh.hfst
	hfst-disjunct $^ -o $@
.deps/il.hfst: .deps/ij.hfst .deps/kl.hfst
	hfst-disjunct $^ -o $@
.deps/mp.hfst: .deps/mn.hfst .deps/op.hfst
	hfst-disjunct $^ -o $@
.deps/qt.hfst: .deps/qr.hfst .deps/st.hfst
	hfst-disjunct $^ -o $@
.deps/ux.hfst: .deps/uv.hfst .deps/wx.hfst
	hfst-disjunct $^ -o $@
.deps/yz1.hfst: .deps/yz.hfst .deps/monosyl.hfst
	hfst-disjunct $^ -o $@
.deps/ah.hfst: .deps/ad.hfst .deps/eh.hfst
	hfst-disjunct $^ -o $@
.deps/ip.hfst: .deps/il.hfst .deps/mp.hfst
	hfst-disjunct $^ -o $@
.deps/qx.hfst: .deps/qt.hfst .deps/ux.hfst
	hfst-disjunct $^ -o $@
.deps/ap.hfst: .deps/ah.hfst .deps/ip.hfst
	hfst-disjunct $^ -o $@
.deps/qz.hfst: .deps/qx.hfst .deps/yz1.hfst
	hfst-disjunct $^ -o $@
.deps/az.hfst: .deps/ap.hfst .deps/qz.hfst
	hfst-disjunct $^ -o $@

clean:
	rm -rf .deps

.PRECIOUS: .deps
