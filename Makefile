OPENSCAD = openscad
ARCHIVE_OUT = archive.tar

# When adding a new directory of scad sources, add it below
SCAD_DIRS := effector frame motion
# When a new 2D scad is added, add it to this list
2D_SCADS := effector/plate.scad

# If there are any top-level SCADs that we want to process, append them here
SCAD_FILES := $(foreach d,$(SCAD_DIRS),$(wildcard $d/*.scad))
STL_FILES := $(patsubst %.scad,%.stl,$(filter-out $(2D_SCADS),$(SCAD_FILES)))
DXF_FILES := $(patsubst %.scad,%.dxf,$(filter $(2D_SCADS),$(SCAD_FILES)))

all: archive

archive: $(ARCHIVE_OUT)

scads: stls dxfs

stls: $(STL_FILES)
dxfs: $(DXF_FILES)

$(ARCHIVE_OUT): $(STL_FILES) $(DXF_FILES) PRINTING.md VERSION.txt BOM.md
	tar -cvf $@ $^

VERSION.txt:
	git describe --always --tags --long > $@

%.stl: %.scad
	$(OPENSCAD) -o $@ $^

%.dxf: %.scad
	$(OPENSCAD) -o $@ $^

clean:
	rm -vf $(STL_FILES) $(DXF_FILES) archive.tar VERSION.txt

.PHONY: scads archive stls dxfs clean all
