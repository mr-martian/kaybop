# kay(f)bop(t)

This is a repo for tools and documents relating to the kay(f)bop(t) conlang.

Currently the best place for further information is [here](https://crazyninjageeks.wordpress.com/2015/11/28/introduction-to-kayfdanfsantaptvlirtsangbesputvombngagtvlimpkayfsnafkayfgaf-boptvegpdaffshofbompvlimpgafvlimpgaf/).

## Morphological Analyzer and Generator

I make no guarantee of this working on systems other than Linux, but on my machine at least, this repo contains code that can be compiled into something which can list all possible analyses of a kay(f)bop(t) word and also convert such an analysis into a correctly-spelled kay(f)bop(t) word.

### Prerequisites

* lexd
* hfst

[Installation instructions](https://wiki.apertium.org/wiki/Installation#Install_Apertium_Core_by_packaging.2Fvirtual_environment)

### Compilation

Run `make`

### Usage

```
$ echo '^fub(b)fiw(p)fe(b)fef(p)gem(p)shub(t)dan(f)$' | hfst-proc -g kaybop_morf.hfstol
loophole<adj>2/snivel<adj>2/specific<adj>2/strum<adj>2/vull<adj>2
$ echo '^snivel<adj>2$' | hfst-proc -g kaybop_gen.hfstol
fub(b)fiw(p)fe(b)fef(p)gem(p)shub(t)dan(f)
```

## Conjugation Server

A web interface that lets you select conjugations from dropdown lists and also informs you of alternative readings.

### Prerequisites

* the analyzer above
* flask

### Usage

```
$ FLASK_APP=server.py flask run --port 7000
```

Then open `http://localhost:7000` in your browser.

## Help

Try [Discord](https://discord.gg/XXsK8hfvS6).
