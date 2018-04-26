# Default Config Settings

SECTIONS_FILEPATH=_SECTIONS.txt
BUILDNAME=example
REFERENCES=references.bib
TEMPLATE=template.tex
# TEMPLATE=ut-thesis.tex
CSL=elsevier-with-titles
TOC=--toc

# Load in new config settings
include _CONFIG.txt
#cat := $(if $(filter $(OS),Windows_NT),type,cat)
#SECTIONS := $(shell $(cat) $(SECTIONS_FILEPATH) | tr '\n' ' ')

# This combines all the filepaths in SECTIONS_FILEPATH file
SECTIONS := $(shell cat $(SECTIONS_FILEPATH) | tr '\n\r' ' ' | tr '\n' ' ' )

# Perform task
.PHONY: all clean html pdf epub embed viewpdf viewhtml

pre:
	mkdir -p build

post:
	@echo POST

clean:
	rm -rf build

# Reason for `&&\` : http://stackoverflow.com/questions/1789594/how-to-write-cd-command-in-makefile

pdf: pre
		cd ./source/ && \
		pandoc $(TOC) -N --bibliography=$(REFERENCES) -o ../build/$(BUILDNAME).pdf --csl=../csl/$(CSL).csl --template=../$(TEMPLATE) $(SECTIONS)

word: pre
		cd ./source/ && \
		pandoc $(TOC) -N --bibliography=$(REFERENCES) -o ../build/$(BUILDNAME).docx --csl=../csl/$(CSL).csl $(SECTIONS)

pdfsafemode: pre
		cd ./source/ && \
		pandoc $(TOC) -N --bibliography=$(REFERENCES) -o ../build/$(BUILDNAME).pdf --csl=../csl/$(CSL).csl $(SECTIONS)

latex: pre
	  ln -s ../figures ./build/
		cd ./source/ && \
		pandoc $(TOC) -N --bibliography=$(REFERENCES) -o ../build/$(BUILDNAME).tex --csl=../csl/$(CSL).csl --template=$(TEMPLATE) $(SECTIONS)

html: pre
		cd ./source/ && \
		pandoc $(TOC) --mathjax="https://cdn.rawgit.com/mathjax/MathJax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --section-divs -s -N --bibliography=$(REFERENCES) --css=../templates/ui-thesis.css --template=../templates/ui-thesis.html --csl=../csl/$(CSL).csl -o ../build/$(BUILDNAME).html -t html $(SECTIONS)

embed: pre
		cd ./source/ && \
		pandoc --reference-links --mathjax="https://cdn.rawgit.com/mathjax/MathJax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --section-divs -s -N --bibliography=$(REFERENCES) --css=../templates/ui-thesis.css --template=../templates/ui-thesis.html --csl=../csl/$(CSL).csl -o ../build/$(BUILDNAME).html -t html $(SECTIONS)

epub: pre
		cd ./source/ && \
		pandoc -S -s --biblatex $(TOC) -N --bibliography=$(REFERENCES) -o ../build/$(BUILDNAME).epub -t epub  $(SECTIONS)

# open files that were rendered

viewpdf:
		open ./build/$(BUILDNAME).pdf

viewhtml:
		open ./build/$(BUILDNAME).html

default: pdf
