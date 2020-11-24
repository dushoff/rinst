## This is 

-include target.mk
all: target

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

# It is better to only make here _as root_ (don't use sudo).  On new systems, sudo seems to install to the user location. On yushan, sudo _usually_ works fine, but it chokes on jags-y things.

## Old Makefile
Sources += install.mk

######################################################################

FORGE = http://R-Forge.R-project.org
LME = http://lme4.r-forge.r-project.org/repos
RSTAN = http://wiki.rstan-repo.googlecode.com/git/
CRAN = http://lib.stat.cmu.edu/R/CRAN
TORONTO = http://cran.utstat.utoronto.ca
MIRR = http://probability.ca/cran
CLOUD = cloud.r-project.org
BOLKER = http://www.math.mcmaster.ca/bolker/R
NIMBLE = http://r-nimble.org

MAINR = $(CRAN)

######################################################################

-include R.mk

%.ppa: r-cran-%.apt ;

aptrule = apt install -y $* | tee $*.apt
%.apt:
	$(aptrule)

sourcerule = echo 'install.packages("$*", repos = "$(MAINR)", dependencies = TRUE)' | $(R) --vanilla | tee $*.source
%.source:
	 $(sourcerule)

######################################################################

# Bolker packages
broom.mixed.github bbmle.github bio3ss3.github fitsir.github: gituser=bbolker

%.github:
	echo 'library(devtools); install_github("$(gituser)/$*")' | $(R) --vanilla | tee $@ 

githubrule = $(MAKE) $(@:.install=.github) && $(MV) $(@:.install=.github) $@

bbmle.install: 
	$(githubrule) || ($(RM) $*.github && false)

######################################################################

%.install:
	($(MAKE) $*.ppa && $(MV) $*.apt $@) \
	|| ($(RM) $*.apt && ($(sourcerule)) && $(MV) $*.source $@) \
	|| ($(RM) $*.source && false)

######################################################################

devtools.source: libharfbuzz-dev.apt libfribidi-dev.apt pkgload.install

gir1.2-harfbuzz-0.0:

######################################################################

%.rmk:
	/bin/rm -f $*
	$(MAKE) $*

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## Want to chain and make makestuff if it doesn't exist
## Compress this ¶ to choose default makestuff route
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

## -include makestuff/wrapR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
