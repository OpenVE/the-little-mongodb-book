SOURCE_FILE_NAME = mongodb.markdown
BOOK_FILE_NAME = mongodb

PDF_BUILDER = pandoc
PDF_BUILDER_FLAGS = \
	--latex-engine xelatex \
	--template ../common/pdf-template.tex \
	--listings

EPUB_BUILDER = pandoc
EPUB_BUILDER_FLAGS = \
	--epub-cover-image

MOBI_BUILDER = kindlegen

PO4A_COMMON_FLAGS ?= \
	-f text \
	-M UTF-8 \
	-m en/mongodb.markdown


%/:
	[ -d $* ] || mkdir $*

%/mongodb.markdown: %/ locale/%/mongodb.po
	po4a-translate ${PO4A_COMMON_FLAGS} -p locale/$*/mongodb.po -l $*/mongodb.markdown

%/mongodb.pdf: %/mongodb.markdown
	cd $* && $(PDF_BUILDER) $(PDF_BUILDER_FLAGS) $(SOURCE_FILE_NAME) -o $(BOOK_FILE_NAME).pdf

%/title.png: %/
	[ -f $*/title.png ] || cp en/title.png $*/

%/title.txt: %/
	[ -f $*/title.txt ] || cp en/title.txt $*/

%/mongodb.epub: %/title.png %/title.txt %/mongodb.markdown
	$(EPUB_BUILDER) $(EPUB_BUILDER_FLAGS) $^ -o $@

%/mongodb.mobi: %/mongodb.epub
	$(MOBI_BUILDER) $^

createpo:
	mkdir locale/${LANG} && po4a-gettextize ${PO4A_COMMON_FLAGS} -p locale/${LANG}/mongodb.po

updatepo:
	po4a-updatepo ${PO4A_COMMON_FLAGS} -p locale/${LANG}/mongodb.po

clean:
	rm -f */$(BOOK_FILE_NAME).pdf
	rm -f */$(BOOK_FILE_NAME).epub
	rm -f */$(BOOK_FILE_NAME).mobi

.PHONY: createpo updatepo clean
